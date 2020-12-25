import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'ListaItens.dart';
import 'Interface.dart';
import 'AddScreen.dart';
import 'EditScreen.dart';
import 'ItemScreen.dart';
import 'Item.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.green,
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: Lista(),
    )
  );
}//end of main

class Lista extends StatefulWidget{
  @override
  _Lista createState() => _Lista();
}//end of Lista

class _Lista extends State<Lista>{
  final String audioBD = "bancoDeIDAudio.bd";
  ListaDeCompras l;
  int nextID = 0;

  @override
  Widget build(BuildContext context){
      return Scaffold(
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () async {
            Criavel criavel = await Navigator.push(context,
                MaterialPageRoute(builder: (context) => AddOverlay(nextID))) as Criavel;
            if(criavel != null){
              nextID = criavel.nextID;
              int id = await _salvarDados(criavel.item);
              await _atualizarBancoAudio();
              criavel.item.id = id;
              setState(() {
                l.compras.add(criavel.item);
              });
              print(criavel.item.nome);
            }//end of if
          },
        ),
        appBar:AppBar(
          title: Text("Lista de compras"),
        ),
        body: Column(
            children: [
              mostrarConteudo(context),
            ]
        ),
      );
  }//end of build

  @override
  void initState() {
    l = ListaDeCompras();
    _inicializarAudio();
    _inicializarLista();
    super.initState();
  }//end of initState

  _inicializarAudio() async {
    Database bd = await _recuperarBancoDados();
    String sql = "SELECT * FROM audios";
    List usuarios = await bd.rawQuery(sql); //conseguimos escrever a query que quisermos
    setState(() {
      for(var usu in usuarios){
        nextID = usu["nextAudio"];
        print("ID do próximo audio: " + nextID.toString());
      }
    });
  }

  _atualizarBancoAudio() async {
    Database bd = await _recuperarBancoDados();
    Map<String, int> dadosUsuario = {
      "nextAudio" : nextID,
    };
    int retorno = await bd.update(
        "audios", dadosUsuario,
        where: "id = ?",  //caracter curinga
        whereArgs: [1]
    );
    print("Itens atualizados: "+ retorno.toString() + " NEXT ID = " +nextID.toString());
  }

  _recuperarBancoDados() async {
    final caminhoBancoDados = await getDatabasesPath();
    final localBancoDados = join(caminhoBancoDados, "bancoDeItens.bd");
    var bd = await openDatabase(
        localBancoDados,
        version: 1,
        onCreate: (db, dbVersaoRecente){
          String sql = "CREATE TABLE compras (id INTEGER PRIMARY KEY AUTOINCREMENT, "
              "nome VARCHAR, descricao VARCHAR, imagem VARCHAR, video VARCHAR, "
              "audio VARCHAR) ";
          db.execute(sql);
          sql = "CREATE TABLE audios (id INTEGER PRIMARY KEY AUTOINCREMENT, "
              "nextAudio INTEGER) ";
          db.execute(sql);
          db.insert("audios", {"nextAudio" : 0});
        }
    );
    return bd;
  }

  _inicializarLista() async {
    Database bd = await _recuperarBancoDados();
    String sql = "SELECT * FROM compras";
    List usuarios = await bd.rawQuery(sql); //conseguimos escrever a query que quisermos
    setState(() {
      l.compras.clear();
      for(var usu in usuarios){
        Item item = new Item("","","","","");
        item.nome = usu["nome"];
        item.descricao = usu["descricao"];
        item.id = usu["id"];
        item.imagem = usu["imagem"];
        item.video = usu["video"];
        item.audio = usu["audio"];
        l.compras.add(item);
      }
    });
  }

  _salvarDados(Item item) async {
    Database bd = await _recuperarBancoDados();
    Map<String, String> dadosUsuario = {
      "nome" : item.nome,
      "descricao" : item.descricao,
      "imagem" : item.imagem,
      "video" : item.video,
      "audio" : item.audio,
    };
    int id = await bd.insert("compras", dadosUsuario);
    print("Item criado! ID = $id");
    return id;
  }

  _excluirItem(Item item) async{
    Database bd = await _recuperarBancoDados();
    int retorno = await bd.delete(
        "compras",
        where: "id = ?",
        whereArgs: [item.id]
    );
    return retorno;
  }

  _atualizarItem(Item item) async{
    Database bd = await _recuperarBancoDados();
    Map<String, String> dadosUsuario = {
      "nome" : item.nome,
      "descricao" : item.descricao,
      "imagem" : item.imagem,
      "video" : item.video,
    };
    int retorno = await bd.update(
        "compras", dadosUsuario,
        where: "id = ?",  //caracter curinga
        whereArgs: [item.id]
    );
    print("Itens atualizados: "+ retorno.toString());
  }

  mostrarConteudo(BuildContext context){
    return Expanded(
      child: ListView.builder(
        itemCount: l.compras.length,
        itemBuilder: (context, index){
        return Container(
          padding: EdgeInsets.all(22),
          child: SizedBox(
            child: Card(
              color: Colors.yellow,
              child: InkWell(
                splashColor: Colors.green,
                child: Container(
                  child: Column(
                    children: [
                    Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(25),
                          child: l.compras[index].imagem.length > 7 ?
                          SizedBox(
                              width: 75,
                              height: 75,
                              child: imageFromString(l.compras[index].imagem)
                          )
                              :
                          Container(
                            height: 100,
                          ),
                        ),
                        Column(
                            children: [
                              Text(
                                l.compras[index].nome,
                                style: TextStyle(
                                  fontSize: 30,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                l.compras[index].descricao,
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                ),
                              ),
                            ]
                        )
                      ]
                    )]
                  )
                ),
                onTap: () async{
                  Editavel editavel = await itemScreenCall(context, l.compras[index], 0);
                  if(editavel != null) {
                    print(editavel.item.nome);
                    if (editavel.deletar) {
                      await _excluirItem(editavel.item);
                      setState(() {
                        l.compras.removeAt(index);
                      });
                    } else {
                      nextID = editavel.nextID;
                      await _atualizarBancoAudio();
                      await _atualizarItem(editavel.item);
                      setState(() {
                        l.compras[index] = editavel.item;
                      });
                    }//end of if
                  }//end of if
                }//end of onTap
              ),
            ),

          )
        );
        }//end of itemBuilder
      ),
    );
  }//end of conteudoLista
}//end of _Lista