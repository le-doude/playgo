import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';

import 'board/layout.dart';

typedef bool KoPredicate(Board board, Stone stone, BoardCoordinate coordinate);
typedef void CaptureCallback(Stone stone);
typedef void MoveCallback(Stone stone, BoardCoordinate coordinate);

class Board {
  final Layout layout;
  final KoPredicate isKo;
  final CaptureCallback onCapture;
  final MoveCallback onPlace;
  late final List<List<Intersection>> _intersections;

  Iterable<Intersection> get intersections =>
      _intersections.expand((element) => element);

  Board(this.layout, this.isKo, this.onCapture, this.onPlace) {
    this._intersections = List.generate(
        this.layout.columns,
        (column) => List.generate(this.layout.rows,
            (row) => Intersection(this, layout, BoardCoordinate(column, row))));
    this._intersections.forEach((element) {
      element.forEach((intersection) {
        intersection.init();
      });
    });
  }

  Intersection at(BoardCoordinate coordinate) {
    return _intersections[coordinate.column][coordinate.row];
  }

  bool canPlace(Stone stone, BoardCoordinate coordinate) {
    var intersection = at(coordinate);
    return intersection.isEmpty() &&
        (!intersection.isSuffocating(stone) ^
            intersection.isPotentialCapture(stone)) &&
        !this.isKo(this, stone, coordinate);
  }

  void place(Stone stone, BoardCoordinate coordinate) {
    if (canPlace(stone, coordinate)) {
      at(coordinate).place(stone);
      this.onPlace(stone, coordinate);
    }
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
  }

  void removeStone(Stone stone) {
    Intersection inter = stone.intersection != null
        ? stone.intersection!
        : this
            ._intersections
            .expand((rows) => rows)
            .firstWhere((i) => i.contains(stone));
    inter?.removeStone();
  }

  void _capture(Stone stone) {
    this.onCapture(stone);
  }
}

class Intersection {
  final Board _board;
  final Layout _layout;
  final BoardCoordinate _coordinate;
  late final Set<Intersection> _neighbours;
  Stone? _stone;

  bool contains(Stone stone) {
    return stone.id == this._stone?.id;
  }

  Intersection(this._board, this._layout, this._coordinate);

  void init() {
    var temp = List.empty(growable: true);
    if (!isOnTopEdge()) temp.add(_board.at(_coordinate..up()));
    if (!isOnBottomEdge()) temp.add(_board.at(_coordinate..down()));
    if (!isOnLeftEdge()) temp.add(_board.at(_coordinate..left()));
    if (!isOnRightEdge()) temp.add(_board.at(_coordinate..right()));
    _neighbours = Set.unmodifiable(temp.whereType<Intersection>());
  }

  BoardCoordinate get coordinate => _coordinate;

  Set<Intersection> neighbours() {
    return _neighbours;
  }

  void place(Stone stone) {
    this._stone = stone;
    _updateGroups();
    _processLiberties();
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

  void _processLiberties() {
    var groups = _neighbours.map((e) => e.stone().group).toSet();
    groups.add(this.stone().group);
    var opponent =
        groups.where((g) => g.stones.first.color != this.stone().color);
    opponent.forEach((g) {
      g.processFreedomAndCapture();
    });
  }

  void _updateGroups() {
    _neighbours.forEach((neighbour) {
      if (neighbour.stone().color == this.stone().color) {
        this.stone().link(neighbour.stone());
      }
    });
  }

  Stone stone() {
    return _stone!;
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

  bool isSuffocating(Stone stone) {
    var sameColorNeighbour = this
        .neighbours()
        .where((n) => n.isTaken() && n.stone().color == stone.color);
    var set =
        sameColorNeighbour.expand((n) => n.stone().group.freedoms()).toSet();
    return set.length == 1 && this._coordinate == set.first;
  }

  bool isPotentialCapture(Stone stone) {
    var differentColorNeighbours = this
        .neighbours()
        .where((n) => n.isTaken() && n.stone().color != stone.color);
    var set = differentColorNeighbours
        .expand((n) => n.stone().group.freedoms())
        .toSet();
    return set.length == 1 && this._coordinate == set.first;
  }

  void _capture() {
    this._board._capture(this._stone!);
    this._stone = null;
  }

  Stone? get maybeStone => _stone;

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

  void _capture() {
    this.intersection!._capture();
  }

  void resetGroup() {
    this.group = Group(stones: [this]);
  }
}

class Group {
  static final Uuid uuids = Uuid();
  final UuidValue id;
  final Set<Stone> stones;

  Group({UuidValue? id, Iterable<Stone>? stones})
      : id = id ?? uuids.v4obj(),
        stones = stones?.toSet() ?? Set();

  Group merge(Group other) {
    if (this == other) {
      return this;
    }
    List<Stone> newSet = List.empty(growable: true);
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

  void processFreedomAndCapture() {
    if (freedoms().isEmpty) {
      this._capture();
    }
  }

  Set<BoardCoordinate> freedoms() {
    var set = this
        .stones
        .map((stone) => stone.intersection)
        .whereType<Intersection>()
        .expand((intersection) => intersection.neighbours())
        .where((nInt) => nInt.isEmpty())
        .map((e) => e._coordinate)
        .toSet();
    return set;
  }

  void _capture() {
    this.stones.forEach((stone) => stone._capture());
  }
}
