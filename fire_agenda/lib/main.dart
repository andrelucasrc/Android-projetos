import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

import 'cep.dart';
import 'calendario.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.red,
          brightness: Brightness.light,
          scaffoldBackgroundColor: Colors.yellow,
        ),
        home: Agenda(),
      ));
}

class Agenda extends StatefulWidget {
  @override
  _Agenda createState() => _Agenda();
}

class Contato{
  String nome;
  String email;
  String numero;
  String cep;
  String endereco;

  Contato(String nome, String email, String numero, String cep, String endereco){
    this.nome = nome;
    this.email = email;
    this.numero = numero;
    this.cep = cep;
    this.endereco = endereco;
  }
}

class _Agenda extends State<Agenda>{
  List<Contato> contatos = [];
  List<String> aniversarios = [];
  final nomeController = TextEditingController();
  final numeroController = TextEditingController();
  final emailController = TextEditingController();
  final pesNomeController = TextEditingController();
  final pesEmailController = TextEditingController();
  final editNomeController = TextEditingController();
  final editNumeroController = TextEditingController();
  final editEmailController = TextEditingController();
  final cepController = TextEditingController();
  final enderecoController = TextEditingController();
  final editCepController = TextEditingController();
  final editEnderecoController = TextEditingController();
  int currID = -1;
  Calendario calendario;

  DateTime dateTime;
  bool temAniversario;

  inicializarLista() async{
    QuerySnapshot snap = await FirebaseFirestore.instance.collection("contatos").get();
    setState(() {
      for(QueryDocumentSnapshot doc in snap.docs){
        contatos.add(
          Contato(
            doc.get("NOME"),
            doc.get("EMAIL"),
            doc.get("NUMERO"),
            doc.get("CEP"),
            doc.get("ENDERECO")
          )
        );
      }//end of for
    });
  }

  inicializarCalendario() async{
    calendario = Calendario();
    var response = await calendario.retrieveEventsInfo();
    setState(() {
      for(String eventDetail in response){
        setState(() {
          aniversarios.add(eventDetail);
        });
      }
    });
  }//end of if

  criar(Contato contato) async{
    DocumentReference doc = await FirebaseFirestore.instance.collection("contatos").add({
      "NOME": contato.nome,
      "EMAIL": contato.email,
      "NUMERO": contato.numero,
      "CEP": contato.cep,
      "ENDERECO": contato.endereco,
    });
    setState(() {
      contatos.add(contato);
    });
  }//end of criar

  int lerSec(String email){
    int lido = -1;
    for(int i = 0; i < contatos.length; i++){
      if(contatos[i].email.compareTo(email) == 0){
        lido = i;
        i = contatos.length;
      }//end of if
    }//end of for

    return lido;
  }//end of lerSec

  int lerTer(String nome){
    int lido = -1;
    for(int i = 0; i < contatos.length; i++){
      if(contatos[i].nome.compareTo(nome) == 0){
        lido = i;
        i = contatos.length;
      }//end of if
    }//end of for

    return lido;
  }//end of lerTer

  void atualizar(Contato contato, int pos) async{
    if(pos != -1) {
      FirebaseFirestore.instance.collection("contatos").where("NOME", isEqualTo: contatos[pos].nome).get().
      then((QuerySnapshot snap) async{
        if(snap.docs.isNotEmpty)
          await FirebaseFirestore.instance.collection("contatos").doc(snap.docs.first.id).update({
            "NOME": contato.nome,
            "EMAIL": contato.email,
            "NUMERO": contato.numero,
            "CEP": contato.cep,
            "ENDERECO": contato.endereco,
          });
      });

      setState((){
        contatos[pos] = contato;
      });
    } else {
      errorMessage("Erro ao atualizar o contato.");
    }//end of if
  }//end of atualizar

  void deletar(int pos) async{
    if(pos != -1) {
      FirebaseFirestore.instance.collection("contatos").where("NOME", isEqualTo: contatos[pos].nome).get().
              then((QuerySnapshot snap) async{
                if(snap.docs.isNotEmpty)
                  await FirebaseFirestore.instance.collection("contatos").doc(snap.docs.first.id).delete();
      });
      setState((){
        contatos.removeAt(pos);
      });
    } else {
      errorMessage("Erro ao deletar contato.");
    }//end of if
  }//end of deletar

  listaDeContatos(BuildContext context){
    return Expanded(
      child: ListView.builder(
          itemCount: contatos.length,
          itemBuilder: (context, index){
            return Container(
                padding: EdgeInsets.all(22),
                child: ListTile(
                  title: Text(
                    contatos[index].nome,
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    contatos[index].numero,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                    ),
                  ),
                  onTap: () {
                    mostrarContato(index, context);
                  },
                )
            );
          }
      ),
    );
  }

  listaDeAniversarios(BuildContext context){
    return Expanded(
      child: ListView.builder(
          itemCount: aniversarios.length,
          itemBuilder: (context, index){
            return Container(
                padding: EdgeInsets.all(22),
                child: ListTile(
                  title: Text(
                    aniversarios[index],
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
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

  mostrarContato(int index, BuildContext context){
    return showDialog(
      context: context,
      builder: (context) {
          return AlertDialog(
            title: Text("Contato",
              style: TextStyle(
                fontSize: 28,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Nome: " + contatos[index].nome,
                  style: TextStyle(
                    fontSize: 24,
                  ),
                  textAlign: TextAlign.justify,
                ),
                Text("Número: " + contatos[index].numero,
                  style: TextStyle(
                    fontSize: 24,
                  ),
                  textAlign: TextAlign.justify,
                ),
                Text("Email: " + contatos[index].email,
                  style: TextStyle(
                    fontSize: 24,
                  ),
                  textAlign: TextAlign.justify,
                ),
                Text("CEP: " + contatos[index].cep,
                  style: TextStyle(
                    fontSize: 24,
                  ),
                  textAlign: TextAlign.justify,
                ),
                Text("ENDEREÇO: " + contatos[index].endereco,
                  style: TextStyle(
                    fontSize: 24,
                  ),
                  textAlign: TextAlign.justify,
                )
              ],
            ),
          );
      }
    );
  }

  message(String title, String message){
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(title),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(message),
              ],
            ),
          );
        }
    );
  }

  errorMessage(String error){
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Erro!"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(error),
              ],
            ),
          );
        }
    );
  }

  datePickerButton(DateTime startTime){
    return Container(
      margin: EdgeInsets.only(top: 10.0, bottom: 20),
      height: 45,
      child: RaisedButton(
        color: Colors.red,
        child:
        Text(
          "Aniversário",
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
          ),
        ),
        onPressed: () {
        DatePicker.showDatePicker(context,
          showTitleActions: true,
          minTime: DateTime(1900, 1, 1),
          maxTime: DateTime.now(),
          onChanged: (date) {
            print('change $date');
          }, onConfirm: (date) {
            setState(() {
              dateTime = date;
              temAniversario = true;
            });
          }, currentTime: DateTime.now(), locale: LocaleType.pt);
        }
        )
    );
  }//end of datePicker

  campoDeTexto(String texto, TextEditingController controller){
    return TextField(
      controller: controller,
      decoration: InputDecoration(
          labelText: texto
      ),
      onChanged: (text){

      },
    );
  }

  salvarContato(){
    return Container(
      margin: EdgeInsets.only(top: 10.0, bottom: 20),
      height: 45,
      child: RaisedButton(
        color: Colors.blue,
        child:
        Text(
          "Criar",
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
          ),
        ),
        onPressed: () async {
          if(validateCadastro()){
            Contato c = new Contato(nomeController.text, emailController.text,
                numeroController.text, cepController.text, enderecoController.text);
            if(temAniversario) {
              String aniversario ="Aniversário de " + nomeController.text;
              print("EVENTO:" + aniversario + "\n");
              DateTime start = new DateTime(dateTime.year, dateTime.month, dateTime.day, 0, 0, 0);
              DateTime end = new DateTime(dateTime.year, dateTime.month, dateTime.day, 23, 59, 59);
              List<String> recurrency = ["RRULE:FREQ=YEARLY;"];
              String zone = "GMT-03:00";
              String response = await calendario.inserirEvento(aniversario, start, end, recurrency, zone);
              aniversario += ": " + start.day.toString() + "/" + start.month.toString() + "/" + start.year.toString();
              setState(() {
                aniversarios.add(aniversario);
              });
              message("OPERAÇÃO NO CALENDARIO", response);
            }//end of if
            setState(() {
              criar(c);
              resetarCampos();
            });
          }
        },
      ),
    );
  }

  alterarContato(){
    return Container(
      margin: EdgeInsets.only(top: 10.0, bottom: 20),
      height: 45,
      child: RaisedButton(
        color: Colors.red,
        child:
        Text(
          "Alterar",
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
          ),
        ),
        onPressed: () async{
          if(validate()){
            Contato c = new Contato(editNomeController.text, editEmailController.text,
                editNumeroController.text, editCepController.text, editEnderecoController.text);
            await atualizar(c, currID);
            resetarCampos();
          } else {
            errorMessage("IMPOSSÍVEL DE ALTERAR O CONTATO.");
          }//end of if
        },
      ),
    );
  }

  cepSearch(TextEditingController cep, TextEditingController address){
    return Container(
      margin: EdgeInsets.only(top: 10.0, bottom: 20),
      height: 45,
      child: RaisedButton(
        color: Colors.red,
        child:
        Text(
          "PESQUISAR CEP",
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
          ),
        ),
        onPressed: () async{
          if(cep.text.length == 8){
            Map<String, dynamic> resposta = await getCepInfo(cep.text);
            List<String> cepInfo;
            String endereco = "";
            String logradouro = resposta["logradouro"];
            String complemento = resposta["complemento"];
            String bairro = resposta["bairro"];
            String cidade = resposta["localidade"];
            String estado = resposta["uf"];
            if(logradouro.length > 0) {
              endereco += "Logradouro: ";
              endereco += logradouro;
              endereco += "; ";
            }
            if(complemento.length > 0) {
              endereco += "Complemento: ";
              endereco += complemento;
              endereco += "; ";
            }
            if(bairro.length > 0) {
              endereco += "Bairro: ";
              endereco += bairro;
              endereco += "; ";
            }
            if(cidade.length > 0) {
              endereco += "Cidade: ";
              endereco += cidade;
              endereco += "; ";
            }
            if(estado.length > 0) {
              endereco += "Estado: ";
              endereco += estado;
            }
            setState(() {
              address.text = endereco;
            });
          } else {
            errorMessage("IMPOSSÍVEL ENCONTRAR O CEP.");
          }//end of if
        },
      ),
    );
  }

  deletarContato(){
    return Container(
      margin: EdgeInsets.only(top: 10.0, bottom: 20),
      height: 45,
      child: RaisedButton(
        color: Colors.red,
        child:
        Text(
          "Deletar",
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
          ),
        ),
        onPressed: () async{
          if(currID != -1){
              await deletar(currID);
              resetarCampos();
          } else {
            errorMessage("IMPOSSÍVEL DE DELETAR O CONTATO.");
          }//end of if
        },
      ),
    );
  }

  void resetarCampos(){
    currID = -1;
    nomeController.text = "";
    numeroController.text = "";
    emailController.text = "";
    pesNomeController.text = "";
    pesEmailController.text = "";
    editNomeController.text = "";
    editNumeroController.text = "";
    editEmailController.text = "";
    cepController.text = "";
    enderecoController.text = "";
    editCepController.text = "";
    editEnderecoController.text = "";
    temAniversario = false;
  }

  bool validate(){
    bool valido = true;
    if(currID == -1){
      valido = false;
    }
    if(editNomeController.text.isEmpty){
      valido = false;
    }
    if(editNumeroController.text.isEmpty){
      valido = false;
    }
    if(editEmailController.text.isEmpty){
      valido = false;
    }
    return valido;
  }

  bool validateCadastro(){
    bool valido = true;
    if(nomeController.text.isEmpty){
      valido = false;
    }
    if(numeroController.text.isEmpty){
      valido = false;
    }
    if(emailController.text.isEmpty){
      valido = false;
    }
    return valido;
  }

  cadastrarContato(BuildContext context){
    return Column(
      children: [
        campoDeTexto("NOME", nomeController),
        campoDeTexto("NUMERO", numeroController),
        campoDeTexto("EMAIL", emailController),
        campoDeTexto("CEP", cepController),
        cepSearch(cepController, enderecoController),
        campoDeTexto("ENDERECO", enderecoController),
        datePickerButton(dateTime),
        salvarContato(),
      ],
    );
  }

  void recuperarPesquisa(){
    if(currID == -1){
      errorMessage("CONTATO NÃO EXISTE NA BASE DE DADOS.");
    } else {
      setState(() {
        editNomeController.text = contatos[currID].nome;
        editNumeroController.text = contatos[currID].numero;
        editEmailController.text = contatos[currID].email;
        editCepController.text = contatos[currID].cep;
        editEnderecoController.text = contatos[currID].endereco;
      });
    }//end of if
  }//end of recuperarPesquisa

  pesquisar(){
    return Container(
      margin: EdgeInsets.only(top: 10.0, bottom: 20),
      height: 45,
      child: RaisedButton(
        color: Colors.red,
        child:
        Text(
          "PESQUISAR",
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
          ),
        ),
        onPressed: () {
          if(pesNomeController.text.isNotEmpty){
            currID = lerTer(pesNomeController.text);
            recuperarPesquisa();
          } else if(pesEmailController.text.isNotEmpty){
            currID = lerSec(pesEmailController.text);
            recuperarPesquisa();
          } else {
            errorMessage("ENTRADA DE PESQUISA ESTÁ VÁZIA.");
          }
        },
      ),
    );
  }

  editarContato(BuildContext context){
    return Column(
      children: <Widget>[
        campoDeTexto("PESQUISAR POR NOME", pesNomeController),
        campoDeTexto("PESQUISAR POR EMAIL", pesEmailController),
        pesquisar(),
        campoDeTexto("NOME", editNomeController),
        campoDeTexto("NUMERO", editNumeroController),
        campoDeTexto("EMAIL", editEmailController),
        campoDeTexto("CEP", editCepController),
        cepSearch(editCepController, editEnderecoController),
        campoDeTexto("ENDERECO", editEnderecoController),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            deletarContato(),
            alterarContato(),
          ],
        ),
      ],
    );
  }

  tab1Body(BuildContext context){
    return Column(
      children: [
        Text("LISTA DE CONTATOS", style: TextStyle(fontSize: 28, color: Colors.blue),),
        listaDeContatos(context),
      ],
    );
  }//end of tab1Body

  tab2Body(BuildContext context){
    return Column(
      children: [
        Text("CADASTRO DE CONTATO", style: TextStyle(fontSize: 28, color: Colors.blue),),
        cadastrarContato(context),
      ],
    );
  }//end of tab2Body

  tab3Body(BuildContext context){
    return Column(
      children: [
        Text("EDITAR UM CONTATO", style: TextStyle(fontSize: 28, color: Colors.blue),),
        editarContato(context),
      ],
    );
  }//end of tab3Body

  tab4Body(BuildContext context){
    return Column(
      children: [
        Text("ANIVERSÁRIOS", style: TextStyle(fontSize: 28, color: Colors.blue),),
        listaDeAniversarios(context),
      ],
    );
  }//end of tab4Body

  @override
  Widget build(BuildContext context){
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Fire Agenda"),
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.contact_phone)),
              Tab(icon: Icon(Icons.edit)),
              Tab(icon: Icon(Icons.search)),
              Tab(icon: Icon(Icons.calendar_today)),
            ],
          ),
        ),
          body: TabBarView(
            children: [
              Tab(
                child: tab1Body(context),
              ),
              Tab(
                child: SingleChildScrollView(
                  child: tab2Body(context),
                )
              ),
              Tab(
                child: SingleChildScrollView(
                  child: tab3Body(context),
                )
              ),
              Tab(
                child: tab4Body(context),
              ),
          ],
      )
      ),
    );
  }

  @override
  void initState() {
    inicializarLista();
    inicializarCalendario();
    super.initState();
  }
}
