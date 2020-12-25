import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_list/Pages/ToDoApplication.dart';

class StartPage extends StatefulWidget{
  _StartPage createState() => _StartPage();
}

class _StartPage extends State<StartPage>{
  final _loginText = TextEditingController();
  final _passwordText = TextEditingController();
  final _userCad = TextEditingController();
  final _passCad = TextEditingController();


  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "To Do List - Login",
          style: TextStyle(
            color: Colors.lightGreenAccent,
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),

      ),
      body: Form(
        child: Column(
          children: [
            caixaDeEntrada("Digite seu login", _loginText),
            caixaDeSenha("Digite sua senha", _passwordText),
            botaoDeLogin(context),
            botaoDeCadastro(context),
          ],
        ),
      ),
    );
  }

  limparCampos(){
    setState(() {
      _loginText.text = "";
      _userCad.text = "";
      _passwordText.text = "";
      _passCad.text = "";
    });
  }

  entrada(BuildContext context){
    limparCampos();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ToDoApplication()
      )
    );
  }

  botaoDeCadastro(BuildContext context){
    return Container(
        margin: EdgeInsets.only(top: 10.0, bottom: 20),
        height: 45,
        child: RaisedButton(
          color: Colors.green,
          child:
          Text(
            "Cadastrar uma nova conta",
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
            ),
          ),
          onPressed: () async {
            cadastrar(context);
          }
        )
    );
  }

  botaoDeLogin(BuildContext context){
    return Container(
        margin: EdgeInsets.only(top: 10.0, bottom: 20),
        height: 45,
        child: RaisedButton(
          color: Colors.green,
          child:
          Text(
            "Entrar no sistema",
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
            ),
          ),
          onPressed: () async {
            String login, senha;
            login = _loginText.text;
            senha = _passwordText.text;
            final prefs = await SharedPreferences.getInstance();
            String systemLogin = await prefs.getString("login");
            String systemPassword = await prefs.getString("senha");
            if(systemLogin == login && systemPassword == senha) {
              entrada(context);
            } else {
              return showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    backgroundColor: Colors.greenAccent,
                    title: Text(
                      "LOGIN OU SENHA INVÁLIDO!",
                      style: TextStyle(
                        fontSize: 25,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    content: Text(
                      "Tente novamente ou se cadastre!",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                    actions: <Widget>[
                      FlatButton(
                        onPressed: () async {
                          setState(() {

                          });
                          Navigator.pop(context);
                        },
                        child: Text("Cancelar")
                      ),

                      FlatButton(
                        onPressed: () async {
                          setState(() {
                            Navigator.pop(context);
                            cadastrar(context);
                          });
                        },
                        child: Text("Cadastrar")
                      ),
                  ]);
                }
              );
            }
          },
        )
    );
  }

  // Widget text
  caixaDeEntrada(String field, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.text,
      style: TextStyle(
        fontSize: 22,
        color: Colors.black,
      ),
      decoration: InputDecoration(
        labelText: field,
        labelStyle: TextStyle(
          fontSize: 22,
          color: Colors.white,
        ),
      ),
    );
  }

  caixaDeSenha(String field, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.text,
      obscureText: true,
      style: TextStyle(
        fontSize: 22,
        color: Colors.black,
      ),
      decoration: InputDecoration(
        labelText: field,
        labelStyle: TextStyle(
          fontSize: 22,
          color: Colors.white,
        ),
      ),
    );
  }

  cadastrar(BuildContext context) async{
    return showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          backgroundColor: Colors.lightGreenAccent,
          title: Text(
            "Cadastro",
            style: TextStyle(
              fontSize: 25,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            children: [
              caixaDeEntrada("Crie seu usuário:", _userCad),
              caixaDeSenha("Crie sua senha:", _passCad),
            ],
          ),
            actions: <Widget>[
              FlatButton(
                  onPressed: () async {
                    setState(() {

                    });
                    Navigator.pop(context);
                  },
                  child: Text("Cancelar")
              ),

              FlatButton(
                  onPressed: () async {
                    setState(() async {
                      if(_userCad.text.length > 3 && _passCad.text.length > 3){
                        String login, senha;
                        login = _userCad.text;
                        senha = _passCad.text;
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.setString("login", login);
                        await prefs.setString("senha", senha);
                        _loginText.text = _userCad.text;
                        _passwordText.text = _passCad.text;
                        entrada(context);
                      } else {
                        return showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text(
                                "Quantidade de caracteres inválidos",
                                style: TextStyle(
                                  fontSize: 25,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              content: Text(
                                "O mínimo de caracteres necessários para Senha/Login é 4.",
                                style: TextStyle(
                                  fontSize: 25,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              actions: [
                                FlatButton(
                                    onPressed: () {
                                      setState(() {

                                      });
                                      Navigator.pop(context);
                                    },
                                    child: Text("OK!")
                                ),
                              ],
                            );
                          },
                        );
                      }
                    });
                    Navigator.pop(context);
                  },
                  child: Text("Cadastrar")
              ),
            ]
        );
      }
    );
  }
}