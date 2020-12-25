import 'package:flutter/material.dart';
import 'dart:async';
import 'package:sensors/sensors.dart';
import 'game.dart';
import 'saveScorePage.dart';

class DioBizarres extends StatefulWidget {
  @override
  _DioBizarres createState() => _DioBizarres();
}

class _DioBizarres extends State<DioBizarres>{
  static const double _screenWidth = 400;
  Game game;
  String action = "NOTHING";
  int playerAction = 0;
  Timer enemyAnimation;
  Timer endGameCheck;
  bool firstFrameAttack = true;
  bool gameOver = false;

  List<double> _accelerometerValues;
  List<StreamSubscription<dynamic>> _streamSubscriptions =
  <StreamSubscription<dynamic>>[];

  bool get maintainState => false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Boxer Game'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Card(
            child: Row(
              children: [
                Container(
                  child: Image.asset("images/Opponent Portrait ${game.opponentPortrait}.png")
                ),
                Column(
                  children: [
                    Text(game.opponent.name),
                    Text("Life: ${game.opponent.life}"),
                  ]
                )
              ]
            ),
          ),
          Center(
            child: DecoratedBox(
              decoration: BoxDecoration(
                border: Border.all(width: 1.0, color: Colors.black38),
              ),
              child: SizedBox(
                width: _screenWidth,
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(20),
                      height: 300,
                      child: Image.asset("images/Opponent 0${game.currAnimation}.png", fit: BoxFit.fill)
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                            width: 300,
                            height: 40,
                            child: Card(
                              color: Colors.green,
                              child: Text("Your Action: $action"),
                            )
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
          Card(
            child: Row(
                children: [
                  Container(
                      child: Image.asset("images/Opponent Portrait ${game.playerPortrait}.png")
                  ),
                  Column(
                      children: [
                        Text(game.player.name),
                        Text("Life: ${game.player.life}"),
                      ]
                  )
                ]
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    for (StreamSubscription<dynamic> subscription in _streamSubscriptions) {
      subscription.cancel();
    }
  }

  @override
  void setState(fn){
    if(game.gameState == 2){
      print("You've lost the game!");
      game.gameState = 3;
      gameOver = true;
      Navigator.pop(context, game.currLevel);
    }
    if(!gameOver) {
      if(game.attacking){
        if(firstFrameAttack) {
          game.changeAnimation = true;
          firstFrameAttack = false;
        }//end of if
        game.animationAttacking();
      } else {
        firstFrameAttack = true;
        game.animationStand();
      }//end of if

      if (_accelerometerValues[0] > 4) {
        action = "Desvio!";
        playerAction = 2;
      } else if (_accelerometerValues[0] < -4) {
        action = "Soco!";
        playerAction = 1;
      } else {
        action = "Nothing";
        playerAction = 0;
      }
      game.updatePlayerAction(playerAction);
      if(game.gameState == 1){
        game.gameState = 0;
        game.currLevel++;
        game.calculateOpponentStats();
        game.player.life = 5;
        game.calculateOpponentStats();
        print("You've won the game!");
      }
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();
    game = Game();
    game.updateOpponentAction();
    _accelerometerValues =     <double>[0, 0, 0];
    _streamSubscriptions
        .add(accelerometerEvents.listen((AccelerometerEvent event) {
      setState(() {
        _accelerometerValues = <double>[event.x, event.y, event.z];
      });
    }));
  }
}
