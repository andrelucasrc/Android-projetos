import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class ToDoApplication extends StatefulWidget{
  _ToDoApplication createState() => _ToDoApplication();
}

class _ToDoApplication extends State<ToDoApplication>{
  List<Tarefa> itens = [];
  final tarefaController = TextEditingController();
  final obsController = TextEditingController();

  _recuperarBancoDados() async {
    final caminhoBancoDados = await getDatabasesPath();
    final localBancoDados = join(caminhoBancoDados, "banco3.bd");
    var bd = await openDatabase(
        localBancoDados,
        version: 1,
        onCreate: (db, dbVersaoRecente){
          String sql = "CREATE TABLE tarefas (id INTEGER PRIMARY KEY AUTOINCREMENT, titulo VARCHAR, detalhes VARCHAR) ";
          db.execute(sql);
        }
    );
    return bd;
  }

  _inicializarLista() async{
    Database bd = await _recuperarBancoDados();
    String sql = "SELECT * FROM tarefas";
    List usuarios = await bd.rawQuery(sql); //conseguimos escrever a query que quisermos
    setState(() {
      itens.clear();
      for(var usu in usuarios){
        Tarefa tarefa = Tarefa();
        tarefa.titulo = usu["titulo"];
        tarefa.detalhes = usu["detalhes"];
        tarefa.id = usu["id"];
        itens.add(tarefa);
      }
    });
  }

  _salvarDados(Tarefa tarefa) async {
    Database bd = await _recuperarBancoDados();
    Map<String, String> dadosUsuario = {
      "titulo" : tarefa.titulo,
      "detalhes" : tarefa.detalhes
    };
    int id = await bd.insert("tarefas", dadosUsuario);
    print("Usuário criado! ID = $id");
    return id;
  }

  _excluirTarefa(Tarefa tarefa) async{
    Database bd = await _recuperarBancoDados();
    int retorno = await bd.delete(
        "tarefas",
        where: "id = ?",
        whereArgs: [tarefa.id]
    );
    return retorno;
  }

  _atualizarTarefa(Tarefa tarefa) async{
    Database bd = await _recuperarBancoDados();
    Map<String, String> dadosUsuario = {
      "titulo" : tarefa.titulo,
      "detalhes" : tarefa.detalhes,
    };
    int retorno = await bd.update(
        "tarefas", dadosUsuario,
        where: "id = ?",  //caracter curinga
        whereArgs: [tarefa.id]
    );
    print("Itens atualizados: "+ retorno.toString());
  }

  addItensButton(BuildContext context){
    return FloatingActionButton(
        backgroundColor: Colors.lightGreen,
        elevation: 6,
        child: Icon(Icons.add),
        onPressed: (){
          print("Botão pressionado!");
          showDialog(
              context: context,
              builder: (context){
                return AlertDialog(
                  title: Text("Adicionar tarefa: "),
                  content: Column(
                    children: [
                      TextField(
                        controller: tarefaController,
                        decoration: InputDecoration(
                            labelText: "Digite o título da tarefa"
                        ),
                        onChanged: (text){

                        },
                      ),
                      TextField(
                        controller: obsController,
                        decoration: InputDecoration(
                            labelText: "Digite a observação da tarefa"
                        ),
                        onChanged: (text){

                        },
                      )
                    ]
                  ),
                  actions: <Widget>[
                    FlatButton(
                        onPressed: (){
                          Navigator.pop(context);
                        },
                        child: Text("Cancelar")
                    ),
                    FlatButton(
                        onPressed: () async {
                          Navigator.pop(context);
                          setState(() {
                            if(tarefaController.text.length > 0) {
                              Tarefa item = Tarefa();
                              item.titulo = tarefaController.text;
                              item.detalhes = obsController.text;
                              item.id = _salvarDados(item);
                              itens.add(item);
                              tarefaController.text = "";
                              obsController.text = "";
                            }
                          });
                        },
                        child: Text("Salvar")
                    ),
                  ],

                );
              }
          );
        }
    );
  }

  editarTarefa(int index, BuildContext context){
    return AlertDialog(
      backgroundColor: Colors.lightGreenAccent,
      title: Text(
        "Edite sua tarefa:",
        style: TextStyle(
          fontSize: 25,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Column(
          children: [
            TextField(
              controller: tarefaController,
              decoration: InputDecoration(
                  labelText: "Digite o novo título da tarefa"
              ),
              onChanged: (text){

              },
            ),
            TextField(
              controller: obsController,
              decoration: InputDecoration(
                  labelText: "Digite a nova observação da tarefa"
              ),
              onChanged: (text){

              },
            )
          ]
      ),
      actions: <Widget>[
        FlatButton(
            onPressed: () async {
              setState(() {
                _excluirTarefa(itens[index]);
                itens.removeAt(index);
              });
              Navigator.pop(context);
            },
            child: Text("Remover")
        ),
        FlatButton(
            onPressed: () async {
              setState(() {
                Navigator.pop(context);
                if(tarefaController.text.length > 0) {
                  Tarefa item = Tarefa();
                  item.titulo = tarefaController.text;
                  item.detalhes = obsController.text;
                  item.id = itens[index].id;
                  _atualizarTarefa(item);
                  itens.removeAt(index);
                  itens.add(item);
                  tarefaController.text = "";
                  obsController.text = "";
                }
              });
            },
            child: Text("Atualizar")
        ),
      ],
    );
  }

  listaDeTarefas(BuildContext context){
    return Expanded(
      child: ListView.builder(
          itemCount: itens.length,
          itemBuilder: (context, index){
            return Container(
                padding: EdgeInsets.all(22),
                child: ListTile(
                  title: Text(
                    itens[index].titulo,
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    itens[index].detalhes,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white70,
                    ),
                  ),
                  onTap: () {
                    return showDialog(
                      context: context,
                      builder: (context) {
                        return editarTarefa(index, context);
                      }
                    );
                  },
                )
            );
          }
      ),
    );
  }


  Widget build(BuildContext context) {
    _inicializarLista();

    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de Tarefas"),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: addItensButton(context),

      body: Column(
        children: <Widget>[
          listaDeTarefas(context),
        ],
      ),
    );
  }
}

class Tarefa{
  int id;
  String titulo;
  String detalhes;

  Tarefa(){
    id = -1;
    titulo = "";
    detalhes = "";
  }
}