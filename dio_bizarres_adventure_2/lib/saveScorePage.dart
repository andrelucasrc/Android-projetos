import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'score.dart';

class SaveScore extends StatefulWidget {
  int max;

  SaveScore(int maxLevel){
    print("Max level reach = $maxLevel");
    max = maxLevel;
  }

  @override
  _SaveScore createState() => _SaveScore(max);
}

class _SaveScore extends State<SaveScore> {
  int maxLevel;
  final nameController = TextEditingController();

  _SaveScore(int max){
    maxLevel = max;
  }

  @override
  void initState(){
    // Firebase.initializeApp();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Boxer Game - Salve sua pontuação!'),
        ),
        body: Column(
          children: [
            Text(
              "Parabéns você chegou ao nível ${maxLevel}",
              style: TextStyle(color: Colors.red, fontSize: 20),
            ),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: "Digite o seu apelido(3 caracteres)",
              ),
              maxLength: 3,
              onChanged: (text){

              },
            ),
            saveButton(),
          ],
        )
    );
  }//end of build

  saveButton(){
    return Container(
      margin: EdgeInsets.only(top: 10.0, bottom: 20),
      height: 45,
      child: RaisedButton(
        color: Colors.green,
        child:
        Text(
          "Salvar",
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
          ),
        ),
        onPressed: () async {
          if(nameController.text.length == 3){
            Score score = Score();
            score.playerName = nameController.text;
            score.maxLevel = maxLevel;
            save(score);
            Navigator.pop(context);
          }
        },
      ),
    );
  }

  save(Score score) async{
    await FirebaseFirestore.instance.collection("scores").add({
      "NOME": score.playerName,
      "LEVEL": score.maxLevel,
    });
  }
}