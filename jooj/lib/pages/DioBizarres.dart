import 'package:flutter/material.dart';

class DioBizarres extends StatefulWidget {
  _DioBizarres createState() => _DioBizarres();
}//end of DioBizarres

class _DioBizarres extends State<DioBizarres>{
  int vezesClicadas = 0;
  double opacity1 = 0;
  double opacity2 = 0;
  double opacity3 = 0;
  double opacity4 = 0;
  double opacity5 = 0;
  double opacity6 = 0;
  double zawarudoOpacity = 0;
  bool theworld = false;
  Color titleColor = Colors.yellow;
  Color containerColor = Colors.lightGreenAccent;
  bool standoOn = false;
  var avatarFile = ["assets/images/dio.png", "assets/images/zawarudoanddio.png"];
  int currAvatar = 0;

  void mudaMudaMuda(){
    setState(() {
      vezesClicadas++;
      if(vezesClicadas <= 30){
        if(vezesClicadas%3 == 0)
          opacity1 += 0.1;
      } else if(vezesClicadas <= 80) {
        if(vezesClicadas%5 == 0)
          opacity2 += 0.1;
      } else if(vezesClicadas <= 150) {
        if(vezesClicadas%7 == 0)
          opacity3 += 0.1;
      } else if(vezesClicadas <= 250) {
        if(vezesClicadas%10 == 0)
          opacity4 += 0.1;
      } else if(vezesClicadas <= 400) {
        if(vezesClicadas%15 == 0)
          opacity5 += 0.1;
      } else if(vezesClicadas <= 600) {
        if(vezesClicadas%20 == 0)
          opacity6 += 0.1;
      } else if(vezesClicadas >= 1000){
        theworld = true;
        zawarudoOpacity = 1;
      }//end of if
    });
  }//end of mudaMudaMuda

  zawarudo(){
    return new Padding(
      padding: EdgeInsets.only(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          GestureDetector(
            onTap: zawarudoCheck,
            child: Image.asset("assets/images/zawarudo.png", height: 232, width: 232,),
          ),
        ],
      ),
    );
  }//end of zawarudo

  dio(){
    return new Padding(
      padding: EdgeInsets.only(left: 32, right: 32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          GestureDetector(
            onTap: mudaMudaMuda,
            child: Image.asset("assets/images/dio.png", height: 268, width: 268,),
          ),
        ],
      ),
    );
  }//end of dio

  muda(double transparency){
    return new Padding(
      padding: EdgeInsets.only(top: 16),
      child: Opacity(
        opacity: transparency,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            GestureDetector(
              onTap: mudaMudaMuda, //deve ser criada a função e página e alterado
              child: Image.asset("assets/images/muda.png",
                height: 120, width: 120,
              ),
            )
          ],
        ),
      )
    );
  }//end of muda

  zawarudoanddio(){
    return new Padding(
      padding: EdgeInsets.only(top: 32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          GestureDetector(
            onTap: mudaMudaMuda,
            child: Image.asset("assets/images/zawarudoanddio.png", height: 268, width: 268,),
          ),
        ],
      ),
    );
  }//end of zawarudoanddio

  zawarudoButton(){
    return Container(
      margin: EdgeInsets.only(top: 10.0, bottom: 20),
      height: 45,
      child: RaisedButton(
        color: Colors.red,
        child:
        Text(
          "ZAWARUDO!!!!!",
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
          ),
        ),
        onPressed: () {
          zawarudoCall();
        },
      ),
    );
  }//end of zawarudoButton

  zawarudoCall(){
    if(theworld) {
      return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
                backgroundColor: Colors.blue,
                title: Text(
                  "Zawarudo!!!!",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                  ),
                  textAlign: TextAlign.center,
                ),
                content: Container(
                  child: zawarudo(),
                )
            );
          }
      );
    }
  }//end of zawarudoCall

  zawarudoSummon(){
    setState(() {
      titleColor = Colors.red;
      containerColor = Colors.blueAccent;
      standoOn = true;
      theworld = false;
      currAvatar = 1;
      vezesClicadas = 0;
      opacity1 = 0;
      opacity2 = 0;
      opacity3 = 0;
      opacity4 = 0;
      opacity5 = 0;
      opacity6 = 0;
      zawarudoOpacity = 0;
    });
  }//end of zawarudoSummon

  zawarudoRemove(){
    setState(() {
      titleColor = Colors.yellow;
      containerColor = Colors.lightGreenAccent;
      standoOn = false;
      theworld = false;
      currAvatar = 0;
      vezesClicadas = 0;
      opacity1 = 0;
      opacity2 = 0;
      opacity3 = 0;
      opacity4 = 0;
      opacity5 = 0;
      opacity6 = 0;
      zawarudoOpacity = 0;
    });
  }//end of zawarudoRemove

  zawarudoCheck(){
    if(standoOn)
      zawarudoRemove();
    else
      zawarudoSummon();
  }

  avatar(){
    return new Padding(
      padding: EdgeInsets.only(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          GestureDetector(
            onTap: mudaMudaMuda,
            child: Image.asset(avatarFile[currAvatar], height: 268, width: 268,),
          ),
        ],
      ),
    );
  }//end of avatar


  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("Dio Bizarres"),
        backgroundColor: titleColor,
      ),
      body: Container(
        color: containerColor,
        child: Column(
          children: [
            Row(
              children: [
                muda(opacity1),
                muda(opacity2),
                muda(opacity3),
              ],
            ),

            Row(
              children: [
                muda(opacity4),
                muda(opacity5),
                muda(opacity6),
              ],
            ),

            Opacity(
              opacity: zawarudoOpacity,
              child: zawarudoButton(),
            ),

            avatar(),

            Text("Muda : ${vezesClicadas}"),
          ]
        )
      )
    );
  }//end of buildContext
}//end of _DioBizarres