import 'dart:math';

import 'package:flutter/material.dart';

class JogoDoAdivinha extends StatefulWidget {
  _JogoDoAdivinhaState createState() => _JogoDoAdivinhaState();
}

class _JogoDoAdivinhaState extends State<JogoDoAdivinha> {
  int gerado = 0;
  int digitado = -4;
  int vezes = 0;
  bool randomizado = false;
  final numeroDigitado = TextEditingController();
  final _texto = TextEditingController();
  var random = new Random();

  String _validate(String text, String field) {
    if (text.isEmpty) {
      return "Digite $field";
    }
    return null;
  }

  // Widget text
  caixaDeEntrada(String field, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      validator: (s) => _validate(s, field),
      keyboardType: TextInputType.number,
      style: TextStyle(
        fontSize: 22,
        color: Colors.blue,
      ),
      decoration: InputDecoration(
        labelText: field,
        labelStyle: TextStyle(
          fontSize: 22,
          color: Colors.grey,
        ),
      ),
    );
  }

  void limparCampos(){
    numeroDigitado.text = "";
    print(_texto.text);
  }//end of limparCampos

  void verificarValor(){
    setState(() {
      digitado = int.parse(numeroDigitado.text);

      if (randomizado) {
        _texto.text = "Você está quente.";

        if (digitado < gerado) {
          _texto.text = "Você está frio.";
        } else if (digitado == gerado) {
          _texto.text = "Você acertou.";
          randomizado = false;
        }

        vezes++;
      } else {
        _texto.text = "Gere um novo número para continuar a jogar!";
      }
    });
  }//end of verificarValor

  void randomizar(){
    setState((){
      gerado = random.nextInt(50);
      randomizado = true;
      vezes = 0;
    });
  }//end of randomizar


  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Jogo do Adivinha"),
      ),
      body: new Container(
        child: Column(
          children: <Widget>[
            caixaDeEntrada("Digite o valor que pensa ser correto.", numeroDigitado),


            Container(
              margin: EdgeInsets.only(top: 10.0, bottom: 20),
              height: 45,
              child: RaisedButton(
                color: Colors.green,
                child:
                  Text(
                    "Verificar",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                    ),
                  ),
                  onPressed: () {
                    verificarValor();
                    limparCampos();
                  },
              )
            ),


            Container(
                margin: EdgeInsets.only(top: 10.0, bottom: 20),
                height: 45,
                child: RaisedButton(
                  color: Colors.green,
                  child:
                  Text(
                    "Randomizar",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                    ),
                  ),
                  onPressed: () {
                    randomizar();
                  },
                )
            ),


            Text(
              _texto.text,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.red, fontSize: 25.0),
            ),

            Text(
              "Tentativas: ${vezes}",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.blue, fontSize: 32.0),
            )
          ],
        )
      )
    );
  }
}
