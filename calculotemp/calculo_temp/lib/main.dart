import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cálculo de Temperatura',
      theme: ThemeData(
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Temperatura'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double calcularFarenheit(double temp){
    return (temp*9/5) + 32;
  }

  double calcularKelvin(double temp){
    return temp + 273.15;
  }

  double calcularReaumur(double temp){
    return temp*4/5;
  }

  double calcularRankine(double temp){
    return (temp *9/5)+491.67;
  }
  @override
  Widget build(BuildContext context) {
    final textController = TextEditingController();
    int type = 0;
    double currentlyTemp = 0;
    double finalTemp = 0;
    double _finalTemp = 0;
    final message = TextEditingController();
    message.text = "Nenhuma temperatura convertida ainda.";

    void calculateTemp() {
      setState(() {
      String text = textController.text;
      currentlyTemp = double.parse(text);
      switch(type) {
        case 1:
          _finalTemp = calcularFarenheit(currentlyTemp);
          break;
        case 2:
          _finalTemp = calcularKelvin(currentlyTemp);
          break;
        case 3:
          _finalTemp = calcularReaumur(currentlyTemp);
          break;
        case 4:
          _finalTemp = calcularRankine(currentlyTemp);
          break;
        default:
          _finalTemp = null;
      }//end of switch
      setState(() {
        finalTemp = _finalTemp;
        message.text = "Temperatura convertida = $_finalTemp";
      });
    });}

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            new Container(
              margin: EdgeInsets.all(20),
              child: Text(
                'Escolha o tipo de conversão:',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  )
              ),
            ),
            Row(
              children: [
                new Container(
                  child: MaterialButton(
                    child: Text('Farenheit'),
                    color: Colors.green,
                    textColor: Colors.white,
                    onPressed: () {
                      type = 1;
                    },
                  ),
                ),

                new Container(
                  child: MaterialButton(
                    child: Text('Kelvin'),
                    color: Colors.blue,
                    textColor: Colors.white,
                    onPressed: () {
                      type = 2;
                    },
                  ),
                ),

                new Container(
                  child: MaterialButton(
                    child: Text('Reaumur'),
                    color: Colors.amber,
                    textColor: Colors.white,
                    onPressed: () {
                      type = 3;
                    },
                  ),
                ),

                new Container(
                  child: MaterialButton(
                    child: Text('Rankine'),
                    color: Colors.purple,
                    textColor: Colors.white,
                    onPressed: () {
                      type = 4;
                    },
                  ),
                ),
              ]
            ),


            new Container(
              padding: EdgeInsets.all(20),
              child: Text(
                'Digite a temperatura em Celsius: ',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                )
              ),
            ),
            new TextField(
              controller: textController,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              )
            ),

            new Container(
              padding: EdgeInsets.all(22),
              child: MaterialButton(
                padding: EdgeInsets.all(22),
                // When the user presses the button, show an alert dialog containing
                // the text that the user has entered into the text field.
                onPressed: () {
                  calculateTemp();
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
                child: Text(
                    "Calculate",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    )
                ),
                color: Colors.redAccent,
                textColor: Colors.white,
              ),
            )
          ],
        ),
      ),
    );
  }
}
