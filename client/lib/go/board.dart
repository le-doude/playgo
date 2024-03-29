import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';
import 'package:uuid/uuid.dart';

import 'board/layout.dart';

typedef bool KoPredicate(BoardImpl board, Stone stone, Position coordinate);
typedef void CaptureCallback(Stone stone);
typedef void MoveCallback(Stone stone, Position coordinate);

abstract class Board {
  static Board make(Layout layout) {
    return BoardImpl(layout);
  }

  BoardNotifier get notifier;

  List<StonePosition> get state;

  Intersection get(Position coordinate);

  bool canPlace(Stone stone, Position position);

  Set<Stone> place(Stone stone, Position coordinate);

  void clear(Position coord);

  void clearAll(List<Position> coordinates);

  void clearBoard();

  void removeGroup(Group group);

  void removeStone(Stone stone);

  void notifyStateChange() {
    this.notifier.value = this.state;
  }
}

class BoardNotifier extends ValueNotifier<List<StonePosition>> {
  BoardNotifier(List<StonePosition> value) : super(value);

  void update(Board state) {
    this.value = state.state;
  }
}

class StonePosition {
  final StoneColors color;
  final Position position;

  StonePosition(this.color, this.position);

  @override
  bool operator ==(Object other) =>
      other is StonePosition &&
      runtimeType == other.runtimeType &&
      color == other.color &&
      position == other.position;

  @override
  int get hashCode => color.hashCode ^ position.hashCode;
}

class BoardImpl extends Board {
  final Layout layout;
  late final List<List<Intersection>> _intersections;
  late final BoardNotifier _notifier;

  Iterable<Intersection> get intersections =>
      _intersections.expand((element) => element);

  Iterable<Group> get groups =>
      intersections.map((e) => e.stone?.group).whereType<Group>().toSet();

  BoardImpl(this.layout) {
    this._intersections = this.layout.generateTable((int column, int row) =>
        Intersection(this, this.layout, Position(column, row)));
    this._intersections.forEach((element) {
      element.forEach((intersection) {
        intersection._linkNeighbours();
      });
    });
    this._notifier = BoardNotifier(this.state);
  }

  BoardNotifier get notifier => _notifier;

  Intersection get(Position coordinate) {
    return _intersections[coordinate.column][coordinate.row];
  }

  Set<Stone> place(Stone stone, Position coordinate) {
    var intersection = get(coordinate);
    intersection.place(stone);
    var capturedGroups = intersection
        ._neighbouringGroups()
        .where((g) => g.color != stone.color && g.freedomsCount() <= 0);
    var stones = capturedGroups.expand((e) => e.stones).toSet();
    capturedGroups.forEach((g) => _removeGroupImpl(g));
    try {
      return stones;
    } finally {
      notifyStateChange();
    }
  }

  bool canPlace(Stone stone, Position position) {
    return get(position).canPlace(stone);
  }

  void clear(Position coord) {
    get(coord).clear();
    notifyStateChange();
  }

  void clearAll(List<Position> coordinates) {
    coordinates.map((e) => get(e)).forEach((i) => i.clear());
    notifyStateChange();
  }

  void clearBoard() {
    this.intersections.forEach((i) {
      i.stone?._resetGroup(); // separate groups to avoid reprocessing
      i.clear();
    });
    notifyStateChange();
  }

  void removeGroup(Group group) {
    _removeGroupImpl(group);
    notifyStateChange();
  }

  void _removeGroupImpl(Group group) {
    var stones = group.stones;
    var intersections =
        stones.map((e) => e.intersection).whereType<Intersection>().toSet();
    if (stones.length != intersections.length) {
      intersections.addAll(this
          ._intersections
          .expand((rows) => rows)
          .where((i) => stones.any((s) => i.contains(s))));
    }
    intersections.forEach((i) {
      i.stone?._resetGroup(); // separate groups to avoid reprocessing
      i.clear();
    });
  }

  void removeStone(Stone stone) {
    Intersection inter = stone.intersection != null
        ? stone.intersection!
        : this
            ._intersections
            .expand((rows) => rows)
            .firstWhere((i) => i.contains(stone));
    inter.clear();
    notifyStateChange();
  }

  @override
  // TODO: implement state
  List<StonePosition> get state => this
      .intersections
      .where((element) => element.present)
      .map((e) => StonePosition(e.stone!.color, e.coordinate))
      .toList();
}

class Intersection {
  static final Logger logger = Logger();

  final BoardImpl _board;
  final Layout _layout;
  final Position _coordinate;
  late final Set<Intersection> _neighbours;
  Stone? _stone;

  @override
  bool operator ==(Object other) =>
      other is Intersection && _coordinate == other._coordinate;

  @override
  int get hashCode => _coordinate.hashCode;

  Stone? get stone => _stone;

  Position get coordinate => _coordinate;

  Set<Intersection> get neighbours => _neighbours;

  bool canPlace(Stone stone) {
    if(present) return false;
    for (var n in neighbours) {
      // stone would have liberties of its own
      if (n.empty) return true;
      if (n.stone?.color != stone.color) {
        // stone would capture some neighbours to make liberties
        var freedoms = n.stone?.group?.freedoms();
        if (freedoms?.length == 1 &&
            freedoms?.contains(this._coordinate) == true) return true;
      } else {
        // stone would get liberties of neighbours of same color
        // neighbours have liberties beside the current one
        if (n.stone?.group?.freedoms()?.any((p) => p != this._coordinate) ==
            true) return true;
      }
    }
    return false;
  }

  bool contains(Stone stone) {
    return stone.id == this._stone?.id;
  }

  Intersection(this._board, this._layout, this._coordinate);

  void _linkNeighbours() {
    var temp = _layout
        .computeNeighbours(this._coordinate)
        .map((e) => this._board.get(e));
    _neighbours = Set.unmodifiable(temp);
  }

  void place(Stone stone) {
    this._stone = stone;
    this._stone!.intersection = this;
    _updateGroups();
  }

  Stone clear() {
    var old = this._stone!;
    this._stone = null;
    Set<Stone> oldGroup = Set.from(old.group.stones);
    oldGroup.remove(old);
    _remakeGroup(oldGroup);
    return old;
  }

  void _updateGroups() {
    _neighbours.forEach((neighbour) {
      if (this.present &&
          neighbour.present &&
          this._stone!.color == neighbour._stone?.color) {
        this._stone!._link(neighbour._stone!);
      }
    });
  }

  bool get empty => _stone == null;

  bool get present => !empty;

  Set<Group> _neighbouringGroups() {
    return this
        .neighbours
        .map((i) => i.stone?.group)
        .whereType<Group>()
        .toSet();
  }

  void _remakeGroup(Iterable<Stone> oldGroupStones) {
    oldGroupStones.forEach((stone) {
      stone._resetGroup();
    });
    oldGroupStones.forEach((stone) {
      if (stone.intersection != null) {
        stone.intersection!.place(stone);
      }
    });
  }
}

enum StoneColors {
  White, Black
}

class Stone {
  static final Uuid uuids = Uuid();
  final UuidValue id;
  final StoneColors color;
  Intersection? intersection; // stone cant be moved to another intersection
  late Group group;

  Stone({UuidValue? id, required StoneColors color})
      : id = id ?? uuids.v4obj(),
        color = color {
    this.group = Group(stones: [this]);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Stone && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  void _link(Stone stone) {
    this.group.merge(stone.group);
  }

  void _resetGroup() {
    this.group = Group(stones: [this]);
  }

  @override
  String toString() {
    return 'Stone{color: $color}';
  }
}

class Group {
  static final Uuid uuids = Uuid();
  final UuidValue _id;
  final Set<Stone> _stones;

  StoneColors get color => stones.first.color;

  Group({UuidValue? id, required Iterable<Stone> stones})
      : _id = id ?? uuids.v4obj(),
        _stones = Set.unmodifiable(stones) {
    // can process freedoms ahead since Group is immutable
  }

  UuidValue get id => _id;

  Set<Stone> get stones => _stones;

  Group merge(Group other) {
    if (this == other) {
      return this;
    }
    Set<Stone> newSet = Set();
    newSet.addAll(this.stones);
    newSet.addAll(other.stones);
    var group = Group(stones: newSet);
    group.stones.forEach((stone) {
      stone.group = group;
    });
    return group;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Group && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  int freedomsCount() {
    return freedoms().length;
  }

  Set<Position> freedoms() {
    return this
        .stones
        .map((stone) => stone.intersection)
        .whereType<Intersection>()
        .expand((intersection) => intersection.neighbours)
        .where((nInt) => nInt.empty)
        .map((e) => e._coordinate)
        .toSet();
  }
}
