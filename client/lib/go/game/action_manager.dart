import 'package:play_go_client/go/game.dart';
import 'package:play_go_client/go/players.dart';


typedef LocalPlayerAction = void Function(Game game, Player player);
typedef RemotePlayerAction = void Function(Game game, Player player);

class GameActionManager {
  final Game game;

  GameActionManager(this.game);

  void withLocalPlayer(LocalPlayerAction action) {
    var cPlayer = game.players.current;
    if(cPlayer.local) {
      action.call(game, cPlayer);
    }
  }

  void withRemotePlayer(RemotePlayerAction action) {
    var cPlayer = game.players.current;
    if(!cPlayer.local) {
      action.call(game, cPlayer);
    }
  }
}