import 'dart:convert';
import 'package:bloc_formulario/src/shared_preferene/preferences_usuario.dart';
import 'package:http/http.dart' as http;

import '../models/users_models.dart';

class UsuarioProvider {
//clave de la api de firebase
  final String _firebaseToken = 'AIzaSyC-RZ94wk-eg0jcnS5fQgxkHNmmnO0FBe4';
  final prefs = PreferenciasUsuario();

  //iniciarsesion
  Future<Map<String, dynamic>> inicarSesion(UserModel user) async {
    final String _url =
        'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$_firebaseToken';

    final url = Uri.parse(_url);

    //final map = producto.toJson();

    // es lo mismo que hacer jsoneconde utilizar el metodo productoModelTojson

    print(userModelToJson(user));

    final resp = await http.post(url,
        headers: {"Content-Type": 'application/json '},
        body: userModelToJson(user));

    final decodeData = json.decode(resp.body);

    print('provider user ${decodeData}');

    if (decodeData.containsKey('idToken')) {
      prefs.setToken = decodeData['idToken'];
      return {'ok': true, 'token': decodeData['idToken']};
    } else {
      return {'ok': false, 'mensaje': decodeData['error']['message']};
    }
  }

  //metodo para crear usuario

  Future<dynamic> creaUsuario(UserModel user) async {
    final String _url =
        "https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$_firebaseToken";

    final url = Uri.parse(_url);

    //final map = producto.toJson();

    // es lo mismo que hacer jsoneconde utilizar el metodo productoModelTojson

    print(userModelToJson(user));

    final resp = await http.post(url,
        headers: {"Content-Type": 'application/json '},
        body: userModelToJson(user));

    final decodeData = json.decode(resp.body);

    print('${decodeData}');

    if (decodeData.containsKey('idToken')) {
      prefs.setToken = decodeData['idToken'];

      return {'ok': true, 'token': decodeData['idToken']};
    } else {
      return {'ok': false, 'mensaje': decodeData['error']['message']};
    }
  }
}
