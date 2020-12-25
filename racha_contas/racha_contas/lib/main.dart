import 'dart:async';

import 'package:flutter/material.dart';

void main() => runApp(App());

class App extends StatefulWidget {
  @override
  State createState() => _App();
}

class _App extends State<App>{
  // VARIAVEIS
  final _tConta = TextEditingController();
  final _tPessoas = TextEditingController();
  final _tBebados = TextEditingController();
  final _tGarcom = TextEditingController();
  final _tBebidas = TextEditingController();
  var _infoText = "Sem delação premiada ein!";
  var _formKey = GlobalKey<FormState>();
  double garcom = 10;
  //Mostrar a mensagem de informação sobre o valor do peso.
  final message = TextEditingController();

  _body() {
    return Container(
        padding: EdgeInsets.all(15.0),
        child: new Column(

          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _editText("Digite o Valor da Conta", _tConta),
            _editText("Digite a quantidade de pessoas", _tPessoas),
            _editText("Digite a quantidade de bebados", _tBebados),
            _editText("Digite o valor total das bebidas", _tBebidas),
            Slider(
              value: garcom,
              min: 0,
              max: 100,
              label: "Porcentagem do Garçom.",
              activeColor: Colors.deepOrange,
              inactiveColor: Colors.orangeAccent,
              onChanged: (double valor){
                setState((){
                  garcom = valor.truncateToDouble();
                });
                _tGarcom.text = garcom.toString();
              }),
            Text(
              "Porcentagem do Garçom: ${garcom}%",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20.0)
            ),
            _buttonCalcular(),
            Text(
              message.text,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20.0)
            ),
          ],
        ));
  }

  // PROCEDIMENTO PARA LIMPAR OS CAMPOS
  void _resetFields(){
    _tConta.text = "";
    _tBebidas.text = "";
    _tBebados.text = "";
    _tGarcom.text = "";
    _tConta.text = "";
    _tPessoas.text = "";
  }

  // Widget text
  _editText(String field, TextEditingController controller) {
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

  // PROCEDIMENTO PARA VALIDAR OS CAMPOS
  String _validate(String text, String field) {
    if (text.isEmpty) {
      return "Digite $field";
    }
    return null;
  }

  // Widget button
  _buttonCalcular() {
    return Container(
      margin: EdgeInsets.only(top: 10.0, bottom: 20),
      height: 45,
      child: RaisedButton(
        color: Colors.green,
        child:
        Text(
          "Calcular",
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
          ),
        ),
        onPressed: () {
          _calculate();
          _resetFields();
        },
      ),
    );
  }

  // PROCEDIMENTO PARA CALCULAR O IMC
  void _calculate(){
    setState(() {
      double conta = double.parse(_tConta.text);
      double pessoas = double.parse(_tPessoas.text);
      double bebados = double.parse(_tBebados.text);
      double bebidas = double.parse(_tBebidas.text);

      if(pessoas > bebados && pessoas > 0 && conta > bebidas && conta > 0) {
        double alimento = conta - bebidas;
        double contaNormal = alimento / pessoas;
        double contaBebidas = contaNormal + (bebidas / bebados);
        contaNormal += contaNormal * garcom / 100;
        contaBebidas += contaBebidas * garcom / 100;
        contaBebidas = contaBebidas.roundToDouble();
        contaNormal = contaNormal.roundToDouble();
        message.text =
        "Valor da conta de pessoas que beberam: ${contaBebidas}.\n Valor da conta das outras pessoas: ${contaNormal}.";
      } else {
        message.text = "Dados inseridos são inválido. Tente novamente.";
      }

    });

  }

  // // Widget text
  _textInfo() {
    return Text(
      _infoText,
      textAlign: TextAlign.center,
      style: TextStyle(color: Colors.red, fontSize: 25.0),
    );
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rachadinha',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text("Rachadinha"),
          centerTitle: true,
          backgroundColor: Colors.orange,
        ),
        body: _body(),
      ),
    );
  }
}