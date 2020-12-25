import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:io';
import 'Item.dart';
import 'Interface.dart';
import 'EditScreen.dart';


Future<Editavel> itemScreenCall(BuildContext context, Item item, int nextID) async{
  return Navigator.of(context).push(ItemOverlay(item, nextID));
}

class ItemOverlay extends ModalRoute<Editavel> {
  Item item;
  VideoPlayerController video;
  int nextAudioID;

  @override
  Duration get transitionDuration => Duration(milliseconds: 400);

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => false;

  @override
  Color get barrierColor => Colors.black;

  @override
  String get barrierLabel => null;

  @override
  bool get maintainState => true;

  ItemOverlay(Item i, int nextID){
    item = i;
    video = new VideoPlayerController.file(File(item.video));
    if(i.video.length > 0)
      video.initialize();
    print("VIDEO FROM: " + item.video);
    print("AUDIO FROM: " + item.audio);
    nextAudioID = nextID;
  }//end of contructor

  @override
  Widget buildPage(
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      ) {
    // This makes sure that text and other content follows the material style
    return Material(
      // make sure that the overlay content is not cut off
      child: SafeArea(
        child: _buildOverlayContent(context),
      ),
    );
  }

  Widget _buildOverlayContent(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.edit),
        onPressed: () async {
          Editavel editavel = new Editavel();
          editavel = await Navigator.push(context,
              MaterialPageRoute(builder: (context) => EditScreen(item, 0))) as Editavel;
          if(editavel != null){
            Navigator.pop(context, editavel);
          }//end of if
        },
      ),
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.yellow,
      ),
      body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                  children: [
                    item.imagem.length > 7 ?
                    Padding(
                      padding: EdgeInsets.all(25),
                      child: imageFromString(item.imagem),
                    )
                        :
                    Container(),
                    Expanded(
                      child: Padding(
                          padding: EdgeInsets.all(30),
                          child: Text(
                            item.nome,
                            style: TextStyle(color: Colors.black, fontSize: 30.0),
                          )
                      ),
                    ),
                  ]
              ),
              Divider(
                  color: Colors.black
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: Text("Descrição:", style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),),
              ),
              Row(
                  children: [
                    Expanded(
                      child: Padding(
                          padding: EdgeInsets.all(30),
                          child: Text(
                            item.descricao,
                            style: TextStyle(color: Colors.black, fontSize: 20.0),
                          )
                      ),
                    ),
                  ]
              ),
              item.video.length > 0 ?
              Column(
                children: [
                  Divider(
                    color: Colors.black
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Text("Vídeo do Item ${item.nome}", style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),),
                  ),
                  videoPlayer(video, context),
                ],
              )
                  :
              Column(),
              item.audio.length > 0 ?
              Column(
                children: [
                  Divider(
                    color: Colors.black
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Text("Audio do Item ${item.nome}", style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      audioPlayButton(context)
                    ],
                  )
                ]
              )
                :
              Column(),
            ],
          )
      ),
    );
  }

  @override
  Widget buildTransitions(
      BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
    // You can add your own animations for the overlay content
    return FadeTransition(
      opacity: animation,
      child: ScaleTransition(
        scale: animation,
        child: child,
      ),
    );
  }

  void play() {
    if (item.audio != null && File(item.audio).existsSync()) {
      AudioPlayer audioPlayer = AudioPlayer();
      audioPlayer.play(item.audio, isLocal: true);
    }
  }

  audioPlayButton(BuildContext context){
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

  videoPlayer(VideoPlayerController video, BuildContext context){
    return Container(
        child: Column(
          children: [
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  video.dataSource.length > 7 ?
                  SizedBox(
                    height: 200,
                    width: 200,
                    child: AspectRatio(
                      aspectRatio: video.value.aspectRatio,
                      child: VideoPlayer(video),
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
          if(video.dataSource.length > 7) {
            video
              ..setLooping(true)
              ..initialize().then((_) {
                setState(() {
                  video.play();
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
          if(video.dataSource.length > 7) {
            video
              ..initialize().then((_) {
                setState(() {
                  video.pause();
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
}