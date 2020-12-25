import 'package:flutter/material.dart';
import 'dioBizarres2.dart';
import 'saveScorePage.dart';
import 'scoreList.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class StartPage extends StatefulWidget {
  @override
  _StartPage createState() => _StartPage();
}

class _StartPage extends State<StartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: const Text('Boxer Game - Start'),
    ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            children: [
              Text("Para jogar:\n", style: TextStyle(color: Colors.blue, fontSize: 24, fontWeight: FontWeight.bold)),
              Text("Incline o celular para a direita para atacar!\n"
                  "Incline o celular para a esquerda para desviar!\n",
                  style: TextStyle(color: Colors.blueAccent, fontSize: 16)
              ),
            ],
          ),
          startGame(context),
          recordes(context),
        ],
      )
    );
  }//end of build

  recordes(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10.0, bottom: 20),
      height: 45,
      child: RaisedButton(
        color: Colors.green,
        child: Center(
            child: Container(
              child: Text(
                  "Ver os recordes!", style: TextStyle(
                  color: Colors.white,
                  fontSize: 16
              )
              ),
            )
        ),
        onPressed: () async {
          await Navigator.push(context,
              MaterialPageRoute(builder: (context) => ScoreList()));
        },
      ),
    );
  }

  startGame(BuildContext context){
    return Container(
      margin: EdgeInsets.only(top: 10.0, bottom: 20),
      height: 45,
      child: RaisedButton(
        color: Colors.green,
        child: Center(
          child: Container(
            child: Text(
              "Comece a pancadaria!", style: TextStyle(
              color: Colors.white,
              fontSize: 16
              )
            ),
          )
        ),
        onPressed: () async {
          int maxLevel = await Navigator.push(context,
          MaterialPageRoute(builder: (context) => DioBizarres())) as int;
          if(maxLevel != null){
            await Navigator.push(context,
            MaterialPageRoute(builder: (context) => SaveScore(maxLevel)));
          }
        }
      ),
    );
  }
}