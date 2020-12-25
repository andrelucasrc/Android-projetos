import 'package:http/http.dart' as http;
import 'dart:convert';

//Retorna as informações sobre o cep inserido.
Future<Map<String, dynamic>> getCepInfo(String cep) async{

  //Pega o CEP dentro do banco de dados do Via Cep.
  String url = "https://viacep.com.br/ws/${cep}/json/";

  //Pega a resposta do banco de dados e decodifica ela para retorno.
  http.Response response;
  response = await http.get(url);
  Map<String, dynamic> retorno = json.decode(response.body);

  return retorno;
}//end of getCepInfo