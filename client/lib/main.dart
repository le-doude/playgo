import 'package:flutter/material.dart';
import 'package:play_go_client/go/board.dart';
import 'package:play_go_client/go/board/board_theme.dart';
import 'package:play_go_client/go/board/board_widget.dart';
import 'package:play_go_client/go/board/layout.dart';
import 'package:play_go_client/go/board/stone_preview_holder.dart';
import 'package:play_go_client/go/game/action_manager.dart';
import 'package:play_go_client/go/players.dart';
import 'package:play_go_client/go/rules.dart';

import 'go/game/local_game.dart';

void main() {
  runApp(PlayGoClientApp());
}

class PlayGoClientApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: PlayGoClientHomePage(title: 'Play Go Server'),
    );
  }
}

class PlayGoClientHomePage extends StatefulWidget {
  PlayGoClientHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _PlayGoClientHomePageState createState() => _PlayGoClientHomePageState();
}

class _PlayGoClientHomePageState extends State<PlayGoClientHomePage> {
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    var layout = Layouts.STANDARD_19_BY_19;
    var board = Board.make(layout);
    var actionManager = GameActionManager(LocalGame(board, Rules.japanese(),
        PlayerTurnManager.local([Player("black"), Player("white")])));
    var previewHolder = StonePreviewHolder(null);
    var boardWidget = BoardWidget(
      board: board.notifier,
      theme: Themes.base,
      layout: layout,
      previewHolder: previewHolder,
      onClick: (coord) => actionManager
          .withLocalPlayer((game, player) => {game.place(player, coord)}),
      onHover: (coord) {
        actionManager.withLocalPlayer((game, player) {
          if (game.allowed(player, coord)) {
            previewHolder.value = StonePreview(player.color, coord);
          } else {
            previewHolder.clear();
          }
        });
      },
      onMoveAway: () => previewHolder.clear(),
    );

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Container(
          padding: EdgeInsets.all(10), child: Center(child: boardWidget)),
      floatingActionButton: FloatingActionButton(
        onPressed: () => actionManager.withLocalPlayer((game, player) {
          game.pass(player);
        }),
        tooltip: 'Pass',
        child: Text('Pass'),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
