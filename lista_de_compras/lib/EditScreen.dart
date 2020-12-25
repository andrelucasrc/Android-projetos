import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:image_picker/image_picker.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:io';
import 'Item.dart';
import 'Interface.dart';
import 'AudioPlayer.dart';

class Editavel{
  Item item;
  bool deletar;
  int nextID;
}//end of Editavel

class EditScreen extends StatefulWidget {
  Item item;
  int nextIDAudio;

  EditScreen(Item i, int nextAudioId){
    item = i;
    nextIDAudio = nextAudioId;
  }

  _EditScreen createState() => _EditScreen(item, nextIDAudio);
}

class _EditScreen extends State<EditScreen> {
  Item item;
  final ImagePicker picker = new ImagePicker();
  VideoPlayerController _videoController;
  final nome = new TextEditingController();
  final descricao = new TextEditingController();
  PickedFile _img;
  AudioRecorder recorder;

  _EditScreen(Item i, int nextAudioID){
    item = i;
    recorder = AudioRecorder(nextAudioID);
    recorder.recordFilePath = i.audio;
  }//end of _EditScreen

  @override
  initState(){
    _img = PickedFile(item.imagem);
    _videoController = new VideoPlayerController.file(File(item.video));
    if(item.video.length > 0)
      _videoController.initialize();

    nome.text = item.nome;
    descricao.text = item.descricao;
    super.initState();
  }//end of contructor

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          excluir(context),
          editar(context),
        ],
      ),
      appBar: AppBar(
        title: Text("Editar Item ${item.nome}",
            style: TextStyle(color: Colors.white)
        ),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            textField("Digite o nome:", nome),
            textField("Digite a descrição", descricao),
            Padding(
              padding: EdgeInsets.all(10),
              child: Text("Imagem do Item ${item.nome}", style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),),
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: EdgeInsets.all(25),
                    child: imageFromString(_img.path),
                  ),
                  addImgButton(context),
                ]
            ),
            Divider(
              color: Colors.black,
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: Text("Video do Item ${item.nome}", style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),),
            ),
            videoPlayer(_videoController, context),
            Divider(
              color: Colors.black,
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: Text("Audio do Item ${item.nome}", style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                audioResumeButton(context),
                audioRecordStartButton(context),
                audioRecordStopButton(context),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(40),
            ),
          ],
        ),
      ),
    );
  }

  void play() {
    if (recorder.recordFilePath != null && File(recorder.recordFilePath).existsSync()) {
      AudioPlayer audioPlayer = AudioPlayer();
      audioPlayer.play(recorder.recordFilePath, isLocal: true);
    }
  }

  audioRecordStartButton(BuildContext context){
    return Container(
      margin: EdgeInsets.only(top: 10.0, bottom: 20),
      height: 45,
      child: RaisedButton(
        color: Colors.red,
        child: Row(
            children: [
              Icon(Icons.mic),
            ]
        ),
        onPressed: () async {
          recorder.startRecord();
        }
      )
    );
  }//end of audioRecordStart

  audioResumeButton(BuildContext context){
    return Container(
      margin: EdgeInsets.only(top: 10.0, bottom: 20),
      height: 45,
      child: RaisedButton(
        color: Colors.blue,
        child: Row(
            children: [
              Icon(Icons.play_arrow),
            ]
        ),
        onPressed: () async {
          play();
        },
      ),
    );
  }

  audioRecordStopButton(BuildContext context){
    return Container(
      margin: EdgeInsets.only(top: 10.0, bottom: 20),
      height: 45,
      child: RaisedButton(
        color: Colors.red,
        child: Row(
            children: [
              Icon(Icons.mic_off),
            ]
        ),
        onPressed: () async {
          recorder.stopRecord();
        },
      ),
    );
  }

  videoPlayer(VideoPlayerController video, BuildContext context){
    return Container(
        child: Column(
          children: [
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _videoController.dataSource.length > 7 ?
                  SizedBox(
                    height: 200,
                    width: 200,
                    child: AspectRatio(
                      aspectRatio: _videoController.value.aspectRatio,
                      child: VideoPlayer(_videoController),
                    ),
                  )
                      :
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                    ),
                    width: 150,
                    height: 150,
                    child: Icon(
                      Icons.videocam_off,
                      color: Colors.grey[800],
                    ),
                  ),
                  Column(
                      children: [
                        playVideoButton(video, context),
                        stopVideoButton(video, context),
                        addVideoButton(video, context),
                      ]
                  )
                ]
            )
          ],
        )
    );
  }//end of videoPlayer

  playVideoButton(VideoPlayerController video, BuildContext context){
    return Container(
      margin: EdgeInsets.only(top: 10.0, bottom: 20),
      height: 45,
      child: RaisedButton(
        color: Colors.red,
        child: Row(
            children: [
              Icon(Icons.play_arrow),
            ]
        ),
        onPressed: () {
          if(_videoController.dataSource.length > 7) {
            _videoController
              ..setLooping(true)
              ..initialize().then((_) {
                setState(() {
                  _videoController.play();
                });
              });
          } else {
            dialogMessage("Erro ao reproduzir vídeo.",
                "Nenhum vídeo foi carregado na base de dados.",
                context, Colors.red
            );
          }
        },
      ),
    );
  }//end of addImgButton

  stopVideoButton(VideoPlayerController video, BuildContext context){
    return Container(
      margin: EdgeInsets.only(top: 10.0, bottom: 20),
      height: 45,
      child: RaisedButton(
        color: Colors.red,
        child: Row(
            children: [
              Icon(Icons.stop),
            ]
        ),
        onPressed: () {
          if(_videoController.dataSource.length > 7) {
            _videoController
              ..initialize().then((_) {
                setState(() {
                  _videoController.pause();
                });
              });
          } else {
            dialogMessage("Erro ao reproduzir vídeo.",
                "Nenhum vídeo foi carregado na base de dados.",
                context, Colors.red
            );
          }
        },
      ),
    );
  }//end of addImgButton

  addVideoButton(VideoPlayerController controller, BuildContext context){
    return Container(
      margin: EdgeInsets.only(top: 10.0, bottom: 20),
      height: 45,
      child: RaisedButton(
        color: Colors.blue,
        child: Row(
            children: [
              Icon(Icons.file_upload),
            ]
        ),
        onPressed: () async{
          addVideoDialog(controller, context);
        },
      ),
    );
  }//end of addImgButton

  addVideoDialog(VideoPlayerController controller, BuildContext context){
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc){
          return Container(
            child: new Wrap(
              children: <Widget>[
                new ListTile(
                  leading: addVideoFromGalery(),
                  title: new Text("Adicionar pela galeria "),
                ),
                new ListTile(
                  leading: addVideoFromCamera(),
                  title: new Text("Adicionar pela câmera"),
                ),
              ],
            ),
          );
        }
    );
  }//end of addImgDialog

  addVideoFromCamera(){
    return Container(
      margin: EdgeInsets.only(top: 10.0, bottom: 20),
      height: 45,
      child: RaisedButton(
        color: Colors.blue,
        child:
        Icon(Icons.photo_camera),
        onPressed: () async {
          PickedFile video = await picker.getVideo(
            source: ImageSource.camera,
          );
          setState(() {
            if(video != null) {
              setState((){
                _videoController = VideoPlayerController.file(File(video.path));
                _videoController.initialize();
                print("VIDEO FROM: " + _videoController.dataSource);
              });
            }//end of if
          });
        },
      ),
    );
  }//end of addFromGalery

  addVideoFromGalery(){
    return Container(
      margin: EdgeInsets.only(top: 10.0, bottom: 20),
      height: 45,
      child: RaisedButton(
        color: Colors.blue,
        child:
        Icon(Icons.image),
        onPressed: () async {
          PickedFile video = await picker.getVideo(
            source: ImageSource.gallery,
          );
          setState(() {
            if(video != null) {
              setState(() {
                _videoController = VideoPlayerController.file(File(video.path));
                _videoController.initialize();
                print("VIDEO FROM: " + _videoController.dataSource);
              });
            }//end of if
          });
        },
      ),
    );
  }//end of addFromGalery

  addImgButton(BuildContext context){
    return Container(
      margin: EdgeInsets.only(top: 10.0, bottom: 20),
      height: 45,
      child: RaisedButton(
        color: Colors.blue,
        child: Row(
            children: [
              Icon(Icons.add),
              Icon(Icons.image),
            ]
        ),
        onPressed: () {
          addImgDialog(context);
        },
      ),
    );
  }//end of addImgButton

  addImgDialog(BuildContext context){
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc){
          return Container(
            child: new Wrap(
              children: <Widget>[
                new ListTile(
                  leading: addImgFromGalery(),
                  title: new Text("Adicionar pela galeria "),
                ),
                new ListTile(
                  leading: addImgFromCamera(),
                  title: new Text("Adicionar pela câmera"),
                ),
              ],
            ),
          );
        }
    );
  }//end of addImgDialog

  addImgFromCamera(){
    return Container(
      margin: EdgeInsets.only(top: 10.0, bottom: 20),
      height: 45,
      child: RaisedButton(
        color: Colors.blue,
        child:
        Icon(Icons.photo_camera),
        onPressed: () async {
          PickedFile img = await picker.getImage(
            source: ImageSource.camera,
          );
          setState(() {
            if(img != null) {
              setState(() {
                _img = img;
              });
            }//end of if
          });
        },
      ),
    );
  }//end of addFromGalery

  addImgFromGalery(){
    return Container(
      margin: EdgeInsets.only(top: 10.0, bottom: 20),
      height: 45,
      child: RaisedButton(
        color: Colors.blue,
        child:
        Icon(Icons.image),
        onPressed: () async {
          PickedFile img = await picker.getImage(
            source: ImageSource.gallery,
          );
          setState(() {
            if(img != null) {
              _img = img;
            }//end of if
          });
        },
      ),
    );
  }//end of addFromGalery

  editar(BuildContext context){
    return Container(
      margin: EdgeInsets.only(top: 10.0, bottom: 20),
      height: 45,
      child: RaisedButton(
        color: Colors.blue,
        child:
        Icon(Icons.edit),
        onPressed: () {
          String video = "";
          String image = "";
          if(_img.path.length > 7){
            image = _img.path;
          }//end of if
          if(_videoController.dataSource.length > 7){
            video = _videoController.dataSource;
          }//end of if
          Editavel editavel = new Editavel();
          editavel.item = new Item(nome.text, descricao.text, image, video, recorder.recordFilePath);
          editavel.deletar = false;
          Navigator.pop(context, editavel);
        },
      ),
    );
  }//end of editar

  excluir(BuildContext context){
    return Container(
      margin: EdgeInsets.only(top: 10.0, bottom: 20),
      height: 45,
      child: RaisedButton(
        color: Colors.red,
        child:
        Icon(Icons.delete),
        onPressed: () {
          Editavel editavel = new Editavel();
          editavel.item = item;
          editavel.deletar = true;
          editavel.nextID = recorder.fileNumber;
          Navigator.pop(context, editavel);
        },
      ),
    );
  }//end of excluir
}