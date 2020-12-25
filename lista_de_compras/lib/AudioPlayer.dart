import 'package:record_mp3/record_mp3.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'dart:async';

class AudioRecorder{
  int fileNumber;
  String statusText = "";
  bool isComplete = false;
  String recordFilePath = "";

  AudioRecorder(int f){
    fileNumber = f;
  }//end of contructor

  Future<bool> checkPermission() async {
    return true;
  }

  void startRecord() async {
    bool hasPermission = await checkPermission();
    if (hasPermission) {
      statusText = "Gravação a iniciar...";
      print(statusText);
      recordFilePath = await getFilePath();
      isComplete = false;
      RecordMp3.instance.start(recordFilePath, (type) {
        statusText = "Gravação iniciada--->$type";
        print(statusText);
      });
    } else {
      statusText = "Gravação falhou";
      print(statusText);
    }
  }//end of startRecord

  void pauseRecord() {
    if (RecordMp3.instance.status == RecordStatus.PAUSE) {
      bool s = RecordMp3.instance.resume();
      if (s) {
        statusText = "Gravação resumida...";
        print(statusText);
      }
    } else {
      bool s = RecordMp3.instance.pause();
      if (s) {
        statusText = "Gravação pausada...";
        print(statusText);
      }
    }
  }

  void stopRecord() {
    bool s = RecordMp3.instance.stop();
    if (s) {
      statusText = "Gravação parada";
      print(statusText);
      isComplete = true;
    }
  }

  void resumeRecord() {
    bool s = RecordMp3.instance.resume();
    if (s) {
      statusText = "Gravação resumida...";
    }
  }

  Future<String> getFilePath() async {
    Directory storageDirectory = await getApplicationDocumentsDirectory();
    String sdPath = storageDirectory.path + "/record";
    var d = Directory(sdPath);
    if (!d.existsSync()) {
      d.createSync(recursive: true);
    }
    return sdPath + "/test_${fileNumber++}.mp3";
  }//end of getFilePay
}//end of audio player