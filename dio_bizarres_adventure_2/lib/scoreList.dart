import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'score.dart';

class ScoreList extends StatefulWidget {
  @override
  _ScoreList createState() => _ScoreList();
}

class _ScoreList extends State<ScoreList> {
  List<Score> list = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: const Text('Boxer Game - Scores'),
      ),
      body: Column(

      ),
    );
  }

  @override
  void initState(){
    inicializarLista();
    super.initState();
  }

  inicializarLista() async{
    QuerySnapshot snap = await FirebaseFirestore.instance.collection("scores").get();
    setState(() {
      for(QueryDocumentSnapshot doc in snap.docs){
        Score s = Score();
        s.playerName = doc.get("NOME");
        s.maxLevel = doc.get("LEVEL");
        list.add(s);
      }//end of for
    });
  }

  listaDeContatos(BuildContext context){
    return Expanded(
      child: ListView.builder(
          itemCount: list.length,
          itemBuilder: (context, index){
            return Card(
              color: Colors.red,
                child: ListTile(
                  title: Text(
                    list[index].playerName,
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    "Max Level = ${list[index].maxLevel}",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                    ),
                  ),
                  onTap: () {
                  },
                )
            );
          }
      ),
    );
  }
}