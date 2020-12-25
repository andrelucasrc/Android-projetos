import 'dart:io';

import 'package:flutter/material.dart';
import 'package:jooj/pages/JogoDoAdivinha.dart';
import 'package:jooj/pages/PaginaSobreJogos.dart';
import 'package:jooj/pages/DioBizarres.dart';

class PaginaInicial extends StatefulWidget {
  @override
  _PaginaInicialState createState() => _PaginaInicialState();
}

class _PaginaInicialState extends State<PaginaInicial> {
  void _abrirSobreJogos() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PaginaSobreJogos()
        ));
  }
  void _abrirJogoDoAdivinha() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => JogoDoAdivinha()
        ));
  }

  void _zawarudo() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DioBizarres()
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Jogos"),
        ),
        body: Container(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text("Para acessar os jogos clique nas imagens"),
               Padding(
                   padding: EdgeInsets.only(top: 32),
                 child: Row(
                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                   children: <Widget>[
                     GestureDetector(
                       onTap: _abrirSobreJogos,
                       child: Image.asset("assets/images/sobre.png"),
                     ),
                     GestureDetector(
                       onTap: _abrirJogoDoAdivinha,
                       child: Image.asset("assets/images/adivinha.png", height: 163, width: 163,),
                     ),
                   ],
                 ),
               ),
                Padding(
                  padding: EdgeInsets.only(top: 32),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      GestureDetector(
                        onTap: _zawarudo,
                        child: Image.asset("assets/images/diobizarres.png", height: 300, width: 270),
                      ),
                    ],
                  ),
                ),
              ],
            ),
        ),
    );
  }
}
