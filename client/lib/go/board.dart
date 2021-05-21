import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';

import 'board/layout.dart';

typedef bool KoPredicate(Board board, Stone stone, BoardCoordinate coordinate);
typedef void CaptureCallback(Stone stone);
typedef void MoveCallback(Stone stone, BoardCoordinate coordinate);

class Board extends ChangeNotifier {
  final Layout layout;
  late final List<List<Intersection>> _intersections;

  Iterable<Intersection> get intersections =>
      _intersections.expand((element) => element);

  Iterable<Group> get groups =>
      intersections.map((e) => e.stone?.group).whereType<Group>().toSet();

  Board(this.layout) {
    this._intersections = this.layout.generateTable((int column, int row) =>
        Intersection(this, this.layout, BoardCoordinate(column, row)));
    this._intersections.forEach((element) {
      element.forEach((intersection) {
        intersection._linkNeighbours();
      });
    });
  }

  Intersection at(BoardCoordinate coordinate) {
    return _intersections[coordinate.column][coordinate.row];
  }

  void place(Stone stone, BoardCoordinate coordinate) {
    at(coordinate).place(stone);
    notifyListeners();
  }

  void removeGroup(Group group) {
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
    notifyListeners();
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
}

class Intersection {
  final Board _board;
  final Layout _layout;
  final BoardCoordinate _coordinate;
  late final Set<Intersection> _neighbours;
  Stone? _stone;

  Stone? get stone => _stone;

  BoardCoordinate get coordinate => _coordinate;

  Set<Intersection> get neighbours => _neighbours;

  bool contains(Stone stone) {
    return stone.id == this._stone?.id;
  }

  Intersection(this._board, this._layout, this._coordinate);

  void _linkNeighbours() {
    var temp = List.empty(growable: true);
    if (!isOnTopEdge()) temp.add(_board.at(_coordinate..up()));
    if (!isOnBottomEdge()) temp.add(_board.at(_coordinate..down()));
    if (!isOnLeftEdge()) temp.add(_board.at(_coordinate..left()));
    if (!isOnRightEdge()) temp.add(_board.at(_coordinate..right()));
    _neighbours = Set.unmodifiable(temp.whereType<Intersection>());
  }

  void place(Stone stone) {
    this._stone = stone;
    _updateGroups();
  }

  Stone removeStone({bool process = true}) {
    var old = this._stone!;
    this._stone = null;
    old.intersection = null;
    if (process) {
      Set<Stone> oldGroup = old.group.stones;
      oldGroup.remove(old);
      _remakeGroup(oldGroup);
    }
    return old;
  }

  void _updateGroups() {
    _neighbours.forEach((neighbour) {
      if (this._stone!.color != neighbour._stone?.color) {
        this._stone!.link(neighbour._stone!);
      }
    });
  }

  bool isCorner() {
    return isOnVerticalEdge() && isOnHorizontalEdge();
  }

  bool isEdge() {
    return isOnVerticalEdge() ^ isOnHorizontalEdge();
  }

  bool isOnHorizontalEdge() {
    return (isOnTopEdge() || isOnBottomEdge());
  }

  bool isOnTopEdge() => this._coordinate.row == 0;

  bool isOnBottomEdge() => this._coordinate.row == this._layout.rows - 1;

  bool isOnVerticalEdge() {
    return (isOnLeftEdge() || isOnRightEdge());
  }

  bool isOnRightEdge() => this._coordinate.column == this._layout.columns - 1;

  bool isOnLeftEdge() => this._coordinate.column == 0;

  bool isEmpty() {
    return _stone == null;
  }

  bool isTaken() {
    return !isEmpty();
  }

  bool wouldSuffocate(Stone stone) {
    return neighbouringGroups().where((g) => g.color == stone.color).any((g) {
      var f = g.freedoms();
      return f.length > 1 && f.any((c) => c != this._coordinate);
    });
  }

  bool wouldCapture(Stone stone) {
    return neighbouringGroups().where((g) => g.color != stone.color).any((g) {
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
      stone.resetGroup();
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
  Intersection? intersection;
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

  void link(Stone stone) {
    this.group.merge(stone.group);
  }

  void resetGroup() {
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
        _stones = Set.unmodifiable(stones);

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

  Set<BoardCoordinate> freedoms() {
    var set = this
        .stones
        .map((stone) => stone.intersection)
        .whereType<Intersection>()
        .expand((intersection) => intersection.neighbours)
        .where((nInt) => nInt.isEmpty())
        .map((e) => e._coordinate)
        .toSet();
    return set;
  }
}
