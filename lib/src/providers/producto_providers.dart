import 'dart:convert';
import 'package:bloc_formulario/src/shared_preferene/preferences_usuario.dart';
import 'package:http_parser/http_parser.dart';

import 'package:bloc_formulario/src/models/producto_models.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart' show XFile;
import 'package:mime_type/mime_type.dart';

class ProductoProvider {
  static ProductoProvider? _intanciaProductoProvider;

  ProductoProvider._internal();

  factory ProductoProvider() =>
      _intanciaProductoProvider ??= ProductoProvider._internal();
  // url de firabase que aputa a nuestra base datos
  final String _url = 'https://flutter-api-mapa-default-rtdb.firebaseio.com/';

  final _prefs = PreferenciasUsuario();

  token() {
    final _token = 'auth=${_prefs.getToke}';
    return _token;
  }

  Future<bool> creaProducto(ProductoModel producto) async {
    final url = Uri.parse('$_url/productos.json?auth=${_prefs.getToke}');

    //final map = producto.toJson();

    // es lo mismo que hacer jsoneconde utilizar el metodo productoModelTojson
    final resp = await http.post(url, body: productoModelToJson(producto));

    final decodeData = json.decode(resp.body);

    print('${decodeData}');

    return true;
  }

// cargar productos
  Future<List<ProductoModel>>? cargarProdutos() async {
    final url = Uri.parse('$_url/productos.json?auth=${_prefs.getToke}');

    final resp = await http.get(url);
    final List<ProductoModel> listProductos = [];

    // final decodeData = listaP(resp.body);
    final Map<String, dynamic>? decodeData = json.decode(resp.body);
    print(decodeData);

    if (decodeData == null) return [];
    decodeData.forEach((id, prod) {
      final prodTemp = ProductoModel.fromJson(prod);
      prodTemp.id = id;
      listProductos.add(prodTemp);
    });

    // print(listProductos[1].titulo);

    return listProductos.isEmpty ? [] : listProductos;
  }

  Future<int> eliminaProducto(String? id) async {
    final url = Uri.parse('$_url/productos/$id.json?auth=${_prefs.getToke}');
    final resp = await http.delete(url);

    print(json.decode(resp.body));

    return 1;
  }

  Future<bool?> editarProducto(ProductoModel producto) async {
    final url =
        Uri.parse('$_url/productos/${producto.id}.json?auth=${_prefs.getToke}');

    //final map = producto.toJson();

    // es lo mismo que hacer jsoneconde utilizar el metodo productoModelTojson
    final resp = await http.put(url, body: productoModelToJson(producto));

    final decodeData = json.decode(resp.body);

    print('${decodeData}');

    return true;
  }

  Future<String?> subirImagen(XFile? imagen) async {
    final _urlFoto = Uri.parse(
        'https://api.cloudinary.com/v1_1/dfcbxr2ny/image/upload?upload_preset=jj36zekp');

    final mimeType = mime(imagen?.path)?.split('/');

    final imageUpLoadReaquest = http.MultipartRequest('POST', _urlFoto)
      ..files.add(await http.MultipartFile.fromPath('file', imagen!.path,
          contentType: MediaType(mimeType![0], mimeType[1])));

    // enviamos la peticion
    final streamResponse = await imageUpLoadReaquest.send();

    final resp = await http.Response.fromStream(streamResponse);

    if (resp.statusCode != 200 && resp.statusCode != 201) {
      print('algo salio mal ');
      print(resp.body);
      return null;
    }

    final respData = json.decode(resp.body);

    return respData['secure_url'];
  }
}
