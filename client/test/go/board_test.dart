import 'package:flutter_test/flutter_test.dart';
import 'package:play_go_client/go/board.dart';
import 'package:play_go_client/go/board/layout.dart';

void main() {
  var fiveByFive = Layout(5, 5, []);
  group('Board#place', () {
    test('will place in empty slot', () {
      BoardImpl board = BoardImpl(fiveByFive);
      var coordnates = Position(2, 2);
      var stone = Stone(color: StoneColors.Black);
      board.place(stone, coordnates);
      expect(board
          .get(coordnates)
          .stone, stone);
      expect(board
          .get(coordnates)
          .stone
          ?.group
          .stones
          .length, 1);
      expect(board
          .get(coordnates)
          .stone
          ?.group
          .freedomsCount(), 4);
    });

    test('will place in empty slot on edge', () {
      BoardImpl board = BoardImpl(fiveByFive);
      var coordnates = Position(0, 2);
      var stone = Stone(color: StoneColors.Black);
      board.place(stone, coordnates);
      expect(board
          .get(coordnates)
          .stone, stone);
      expect(board
          .get(coordnates)
          .stone
          ?.group
          .stones
          .length, 1);
      expect(stone.group.stones.length, 1);
      expect(board
          .get(coordnates)
          .stone
          ?.group
          .freedomsCount(), 3);
      expect(stone.group.freedomsCount(), 3);
    });

    test('will place in empty slot on corner', () {
      BoardImpl board = BoardImpl(fiveByFive);
      var coordnates = Position(0, 0);
      var stone = Stone(color: StoneColors.Black);
      board.place(stone, coordnates);
      expect(board
          .get(coordnates)
          .stone, stone);
      expect(board
          .get(coordnates)
          .stone
          ?.group
          .stones
          .length, 1);
      expect(stone.group.stones.length, 1);
      expect(board
          .get(coordnates)
          .stone
          ?.group
          .freedomsCount(), 2);
      expect(stone.group.freedomsCount(), 2);
    });

    test('placing stones together merge groups', () {
      BoardImpl board = BoardImpl(fiveByFive);

      var coordnates = Position(2, 2);
      board.place(Stone(color: StoneColors.Black), coordnates);
      expect(board
          .get(coordnates)
          .stone
          ?.group
          .stones
          .length, 1);
      expect(board
          .get(coordnates)
          .stone
          ?.group
          .freedomsCount(), 4);

      var coordnates2 = Position(2, 3);
      board.place(Stone(color: StoneColors.Black), coordnates2);
      expect(board
          .get(coordnates2)
          .stone
          ?.group
          .stones
          .length, 2);
      expect(board
          .get(coordnates2)
          .stone
          ?.group
          .freedomsCount(), 6);

      expect(board.groups.length, 1);
      expect(board.groups.first, board
          .get(coordnates2)
          .stone
          ?.group);
    });

    test('placing stones together merge groups on edge', () {
      BoardImpl board = BoardImpl(fiveByFive);

      var coordnates = Position(0, 2);
      board.place(Stone(color: StoneColors.Black), coordnates);
      expect(board
          .get(coordnates)
          .stone
          ?.group
          .stones
          .length, 1);
      expect(board
          .get(coordnates)
          .stone
          ?.group
          .freedomsCount(), 3);

      var coordnates2 = Position(0, 1);
      board.place(Stone(color: StoneColors.Black), coordnates2);
      expect(board
          .get(coordnates2)
          .stone
          ?.group
          .stones
          .length, 2);
      expect(board
          .get(coordnates2)
          .stone
          ?.group
          .freedomsCount(), 4);

      expect(board.groups.length, 1);
      expect(board.groups.first, board
          .get(coordnates2)
          .stone
          ?.group);
    });

    test('placing stones together merge groups on corner', () {
      BoardImpl board = BoardImpl(fiveByFive);

      var coordnates = Position(0, 0);
      board.place(Stone(color: StoneColors.Black), coordnates);
      expect(board
          .get(coordnates)
          .stone
          ?.group
          .stones
          .length, 1);
      expect(board
          .get(coordnates)
          .stone
          ?.group
          .freedomsCount(), 2);

      var coordnates2 = Position(0, 1);
      board.place(Stone(color: StoneColors.Black), coordnates2);
      expect(board
          .get(coordnates2)
          .stone
          ?.group
          .stones
          .length, 2);
      expect(board
          .get(coordnates2)
          .stone
          ?.group
          .freedomsCount(), 3);

      expect(board.groups.length, 1);
      expect(board.groups.first, board
          .get(coordnates2)
          .stone
          ?.group);
    });

    test('placing stones of different color', () {
      BoardImpl board = BoardImpl(fiveByFive);

      var coordnates = Position(1, 1);
      board.place(Stone(color: StoneColors.Black), coordnates);
      expect(board
          .get(coordnates)
          .stone
          ?.group
          .stones
          .length, 1);
      expect(board
          .get(coordnates)
          .stone
          ?.group
          .freedomsCount(), 4);

      var coordnates2 = Position(3, 3);
      board.place(Stone(color:StoneColors.White), coordnates2);
      expect(board
          .get(coordnates2)
          .stone
          ?.group
          .stones
          .length, 1);
      expect(board
          .get(coordnates2)
          .stone
          ?.group
          .freedomsCount(), 4);

      expect(board.groups.length, 2);
    });

    test('placing stones of different color in contact', () {
      BoardImpl board = BoardImpl(fiveByFive);

      var coordnates = Position(1, 1);
      board.place(Stone(color: StoneColors.Black), coordnates);
      expect(board
          .get(coordnates)
          .stone
          ?.group
          .stones
          .length, 1);
      expect(board
          .get(coordnates)
          .stone
          ?.group
          .freedomsCount(), 4);

      var coordnates2 = Position(1, 2);
      board.place(Stone(color: StoneColors.White), coordnates2);
      expect(board
          .get(coordnates2)
          .stone
          ?.group
          .stones
          .length, 1);
      expect(board
          .get(coordnates2)
          .stone
          ?.group
          .freedomsCount(), 3);
      expect(board
          .get(coordnates)
          .stone
          ?.group
          .freedomsCount(), 3);

      expect(board.groups.length, 2);
    });
  });

  group('Board#removeStone', () {
    test('triangle formation removing central stone', () {
      BoardImpl board = BoardImpl(fiveByFive);
      var coordnates = Position(2, 2);
      board.place(Stone(color: StoneColors.Black), coordnates);
      expect(board
          .get(coordnates)
          .stone
          ?.group
          .stones
          .length, 1);
      expect(board
          .get(coordnates)
          .stone
          ?.group
          .freedomsCount(), 4);
      coordnates = Position(2, 3);
      board.place(Stone(color: StoneColors.Black), coordnates);
      expect(board
          .get(coordnates)
          .stone
          ?.group
          .stones
          .length, 2);
      expect(board
          .get(coordnates)
          .stone
          ?.group
          .freedomsCount(), 6);
      coordnates = Position(3, 3);
      board.place(Stone(color: StoneColors.Black), coordnates);
      expect(board
          .get(coordnates)
          .stone
          ?.group
          .stones
          .length, 3);
      expect(board
          .get(coordnates)
          .stone
          ?.group
          .freedomsCount(), 7);

      expect(board.groups.length, 1);

      board.clear(Position(2, 3));
      expect(board.groups.length, 2);
      coordnates = Position(2, 2);
      expect(board
          .get(coordnates)
          .stone
          ?.group
          .stones
          .length, 1);
      expect(board
          .get(coordnates)
          .stone
          ?.group
          .freedomsCount(), 4);
      coordnates = Position(3, 3);
      expect(board
          .get(coordnates)
          .stone
          ?.group
          .stones
          .length, 1);
      expect(board
          .get(coordnates)
          .stone
          ?.group
          .freedomsCount(), 4);
    });

    test('cross formation remove central stone', () {
      BoardImpl board = BoardImpl(fiveByFive);
      board.place(Stone(color: StoneColors.Black), Position(2, 2));
      board.place(Stone(color: StoneColors.Black), Position(2, 1));
      board.place(Stone(color: StoneColors.Black), Position(3, 2));
      board.place(Stone(color: StoneColors.Black), Position(2, 3));
      board.place(Stone(color: StoneColors.Black), Position(1, 2));

      expect(board
          .get(Position(2, 2))
          .stone
          ?.group
          .freedomsCount(), 8);
      expect(board.groups.length, 1);

      board.clear(Position(2, 2));
      expect(board.groups.length, 4);
      expect(board
          .get(Position(2, 1))
          .stone
          ?.group
          .freedomsCount(), 4);
      expect(board
          .get(Position(3, 2))
          .stone
          ?.group
          .freedomsCount(), 4);
      expect(board
          .get(Position(2, 3))
          .stone
          ?.group
          .freedomsCount(), 4);
      expect(board
          .get(Position(1, 2))
          .stone
          ?.group
          .freedomsCount(), 4);
    });

    test('remove stone near other color', () {
      BoardImpl board = BoardImpl(fiveByFive);
      board.place(Stone(color: StoneColors.Black), Position(2, 2));
      board.place(Stone(color: StoneColors.Black), Position(2, 1));
      board.place(Stone(color: StoneColors.White), Position(1, 2));
      board.place(Stone(color: StoneColors.White), Position(1, 1));
      expect(board.groups.length, 2);

      board.removeStone(board
          .get(Position(2, 1))
          .stone!);
      expect(board
          .get(Position(2, 2))
          .stone!
          .group
          .freedomsCount(), 3);
      expect(board
          .get(Position(1, 2))
          .stone!
          .group
          .freedomsCount(), 5);
      expect(board.groups.length, 2);
    });
  });

  group('Board#removeGroup', () {
    test('complete remove of group', () {
      BoardImpl board = BoardImpl(fiveByFive);
      board.place(Stone(color: StoneColors.Black), Position(2, 2));
      board.place(Stone(color: StoneColors.Black), Position(2, 1));
      board.place(Stone(color: StoneColors.Black), Position(3, 2));
      board.place(Stone(color: StoneColors.Black), Position(2, 3));
      board.place(Stone(color: StoneColors.Black), Position(1, 2));

      expect(board
          .get(Position(2, 2))
          .present, true);
      expect(board
          .get(Position(2, 1))
          .present, true);
      expect(board
          .get(Position(3, 2))
          .present, true);
      expect(board
          .get(Position(2, 3))
          .present, true);
      expect(board
          .get(Position(1, 2))
          .present, true);

      Group group = board
          .get(Position(2, 2))
          .stone!
          .group;
      board.removeGroup(group);

      expect(board
          .get(Position(2, 2))
          .empty, true);
      expect(board
          .get(Position(2, 1))
          .empty, true);
      expect(board
          .get(Position(3, 2))
          .empty, true);
      expect(board
          .get(Position(2, 3))
          .empty, true);
      expect(board
          .get(Position(1, 2))
          .empty, true);
    });
  });
}
