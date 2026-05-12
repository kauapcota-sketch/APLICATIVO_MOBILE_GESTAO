import 'dart:convert'; //converte JSON (texto) em objeto Dart
import 'package:http/http.dart' as http; //API → faz requisições HTTP (GET, POST...)
import '../modelos/user.dart'; 

class ApiService {
  static const String url =
      'https://jsonplaceholder.typicode.com/users'; //url da APIAPI 
  static Future<List<User>> fetchUsers() async { //função assíncrona que busca dados
    final response = await http.get(Uri.parse(url)); // igual ao clique no Send (Postman)

    if (response.statusCode == 200) { //verifica se deu erro
      List data = json.decode(response.body); //Converte JSON em lista
      return data.map((e) => User.fromJson(e)).toList(); // transforma JSON em objeto
    } else {
      throw Exception('Erro ao carregar usuários'); //tratamento de erro caso a API falhe
    }
  }
}