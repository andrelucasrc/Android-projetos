import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  // VARIAVEIS
  final _tPeso = TextEditingController();
  final _tAltura = TextEditingController();
  var _infoText = "Informe seus dados!";
  var _formKey = GlobalKey<FormState>();
  //Mostrar a mensagem de informação sobre o valor do peso.
  final message = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Calculadora de IMC"),
        centerTitle: true,
        actions: <Widget>[
          IconButton(icon: Icon(Icons.refresh),
              onPressed: _resetFields)
        ],
      ),
      body: _body(),
    );
  }

  // PROCEDIMENTO PARA LIMPAR OS CAMPOS
  void _resetFields(){
    _tPeso.text = "";
    _tAltura.text = "";
    setState(() {
      _infoText = "Informe seus dados!";
      _formKey = GlobalKey<FormState>();
    });
  }

  _body() {
    return SingleChildScrollView(
        padding: EdgeInsets.all(15.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              _editText("Peso (kg)", _tPeso),
              _editText("Altura (cm)", _tAltura),
              _buttonCalcular(),
              _textInfo(),
            ],
          ),
        ));
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
        color: Colors.blue,
        child:
        Text(
          "Calcular",
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
          ),
        ),
        onPressed: () {
          if(_formKey.currentState.validate()){
            _calculate();
          }
          return showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                // Retrieve the text the that user has entered by using the
                // TextEditingController.
                content: Text(message.text),
              );
            },
          );
        },
      ),
    );
  }

  // PROCEDIMENTO PARA CALCULAR O IMC
  void _calculate(){
    setState(() {
      double peso = double.parse(_tPeso.text);
      double altura = double.parse(_tAltura.text) / 100;
      double imc = peso / (altura * altura);
      String imcStr = imc.toStringAsPrecision(4);
      _infoText = imcStr;

      //Verificar o imc e mudar a mensagem!
      if(imc < 18.5){
        message.text = "Tá abaixo do peso, pode comer um MC lanche feliz!";
      } else if(imc <= 24.9){
        message.text = "Tá normal, continue assim!";
      } else if(imc <= 34.9){
        message.text = "Tá obeso de grau 1, melhor manerar nas fritas!";
      } else if(imc <= 39.9){
        message.text = "Tá obeso de grau 2, melhor ir para a esteira ein!";
      } else {
        message.text = "Ta obeso de grau 3, come uma salada aí meu amigo!";
      }
    });

  }

  // // Widget text
  _textInfo() {
    return Text(
      _infoText,
      textAlign: TextAlign.center,
      style: TextStyle(color: Colors.blue, fontSize: 25.0),
    );
  }
}