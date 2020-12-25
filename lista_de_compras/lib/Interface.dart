import 'package:flutter/material.dart';
import 'dart:io';

imageFromString(String path){
  return Container(
    child: path.length != 0
        ? ClipRRect(
      child: Image(
        image: FileImage(File(path)),
        width: 150,
        height: 150,
        fit: BoxFit.fitHeight,
      ),
    )
        : Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
      ),
      width: 150,
      height: 150,
      child: Icon(
        Icons.broken_image,
        color: Colors.grey[800],
      ),
    ),
  );
}//end of imageFromString

dialogMessage(String title, String description, BuildContext context,
    [Color bgColor = Colors.white, Color fontColor = Colors.black]){

  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            title,
            style: TextStyle(color: fontColor),
          ),
          backgroundColor: bgColor,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                description,
                style: TextStyle(color: fontColor),
              ),
            ],
          ),
        );
      }//end of builder
  );
}//end of dialogMessage

textField(String label, TextEditingController controller){
  return TextField(
    controller: controller,
    decoration: InputDecoration(
        labelText: label
    ),
    onChanged: (text){

    },
  );
}//end of textField