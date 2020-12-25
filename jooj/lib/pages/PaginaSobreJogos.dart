import 'package:flutter/material.dart';

class PaginaSobreJogos extends StatefulWidget {
  @override
  _PaginaSobreJogosState createState() => _PaginaSobreJogosState();
}

class _PaginaSobreJogosState extends State<PaginaSobreJogos> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sobre os jogos"),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            Text(
              "Tutoriais dos Jogos:",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.red, fontSize: 28.0),
            ),
            Text(
              "\n\nJogo do Advinha:",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.red, fontSize: 25.0),
            ),
            Text(
              "\nGere um novo valor para advinhar, se você estiver frio o número escolhido é menor que o valor,"
              "caso esteja quente este valor será maior que o número sorteado.",
              style: TextStyle(color: Colors.black, fontSize: 20.0),
            ),
            Text(
              "\n\nDio Bizzare's:",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.red, fontSize: 25.0),
            ),
            Text(
              "\nClique no Dio até algo acontecer.",
              style: TextStyle(color: Colors.black, fontSize: 20.0),
            ),
            Text(
              "\n\nKONO DIO DA!",
              style: TextStyle(color: Colors.blue, fontSize: 28.0),
            ),
          ],
        )
      ),
    );
  }
}
