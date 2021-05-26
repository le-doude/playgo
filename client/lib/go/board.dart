import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';

import 'board/layout.dart';

typedef bool KoPredicate(Board board, Stone stone, Position coordinate);
typedef void CaptureCallback(Stone stone);
typedef void MoveCallback(Stone stone, Position coordinate);

abstract class BoardState extends ChangeNotifier {
  List<StonePosition> get state;
}

class StonePosition {
  final String color;
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

class Board extends BoardState {
  final Layout layout;
  late final List<List<Intersection>> _intersections;

  Iterable<Intersection> get intersections =>
      _intersections.expand((element) => element);

  Iterable<Group> get groups =>
      intersections.map((e) => e.stone?.group).whereType<Group>().toSet();

  Board(this.layout) {
    this._intersections = this.layout.generateTable((int column, int row) =>
        Intersection(this, this.layout, Position(column, row)));
    this._intersections.forEach((element) {
      element.forEach((intersection) {
        intersection._linkNeighbours();
      });
    });
  }

  Intersection at(Position coordinate) {
    return _intersections[coordinate.column][coordinate.row];
  }

  void place(Stone stone, Position coordinate) {
    at(coordinate).place(stone);
    notifyListeners();
  }

  Set<Stone> placeWithCapture(Stone stone, Position coordinate) {
    var intersection = at(coordinate);
    intersection.place(stone);
    var capturedGroups = intersection
        .neighbouringGroups()
        .where((g) => g.color != stone.color && g.freedomsCount() <= 0);
    var stones = capturedGroups.expand((e) => e.stones).toSet();
    capturedGroups.forEach((g) => _removeGroupImpl(g));
    try {
      return stones;
    } finally {
      notifyListeners();
    }
  }

  bool canPlaceWithCapture(Stone stone, Position position) {
    return at(position).canPlaceWithCapture(stone);
  }

  void remove(Position coord) {
    at(coord).removeStone();
    notifyListeners();
  }

  void removeAll(List<Position> coordinates) {
    coordinates.map((e) => at(e)).forEach((i) => i.removeStone());
    notifyListeners();
  }

  void removeGroup(Group group) {
    _removeGroupImpl(group);
    notifyListeners();
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
    intersections.forEach((i) => i.removeStone(process: false));
  }

  void removeStone(Stone stone) {
    Intersection inter = stone.intersection != null
        ? stone.intersection!
        : this
            ._intersections
            .expand((rows) => rows)
            .firstWhere((i) => i.contains(stone));
    inter.removeStone();
    notifyListeners();
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
  final Board _board;
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

  bool canPlaceWithCapture(Stone stone) {
    return empty && (!wouldSuffocate(stone) || wouldCapture(stone));
  }

  bool contains(Stone stone) {
    return stone.id == this._stone?.id;
  }

  Intersection(this._board, this._layout, this._coordinate);

  void _linkNeighbours() {
    var temp = _layout
        .computeNeighbours(this._coordinate)
        .map((e) => this._board.at(e));
    _neighbours = Set.unmodifiable(temp);
  }

  void place(Stone stone) {
    this._stone = stone;
    this._stone!.intersection = this;
    _updateGroups();
  }

  Stone removeStone({bool process = true}) {
    var old = this._stone!;
    this._stone = null;
    // old.intersection = null;
    if (process) {
      Set<Stone> oldGroup = Set.from(old.group.stones);
      oldGroup.remove(old);
      _remakeGroup(oldGroup);
    }
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

  bool wouldSuffocate(Stone stone) {
    // check if ANY neighbour is freedom or has same color
    var selfSuffocation =
        () => !neighbours.any((i) => i.empty || stone.color == i.stone?.color);
    // check if we are taking the last liberty of all our neighbours of same color
    var neighbourSuffocation = () => neighbouringGroups().any((g) {
          return g.color == stone.color && g.freedomsCount() == 1;
        });
    return selfSuffocation() || neighbourSuffocation();
  }

  bool wouldCapture(Stone stone) {
    return neighbouringGroups().any((g) {
      if (g.color == stone.color) {
        return false;
      }
      var f = g.freedoms();
      return f.length == 1 && f.first == this._coordinate;
    });
  }

  Set<Group> neighbouringGroups() {
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

class Stone {
  static final Uuid uuids = Uuid();
  final UuidValue id;
  final String color;
  Intersection? intersection; // stone cant be moved to another intersection
  late Group group;

  Stone({UuidValue? id, required String color})
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
}

class Group {
  static final Uuid uuids = Uuid();
  final UuidValue _id;
  final Set<Stone> _stones;

  String get color => stones.first.color;

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
