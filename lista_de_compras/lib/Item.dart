import 'package:flutter/cupertino.dart';

class Item{
  int id;
  String nome;
  String descricao;
  String imagem;
  String video;
  String audio;

  Item(String n, String d, String i, String v, String a){
    id = -1;
    nome = n;
    descricao = d;
    imagem = i;
    video = v;
    audio = a;
  }//end of constructor
}//end of Item