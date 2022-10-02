import 'package:bloc_formulario/src/providers/producto_providers.dart';
import 'package:rxdart/rxdart.dart';

import 'package:bloc_formulario/src/models/producto_models.dart';
import 'package:image_picker/image_picker.dart' show XFile;

//pasame a manejar toda la aplicacion atravez de stream

class ProductosBloc {
  final _productosController = BehaviorSubject<List<ProductoModel>?>();
  final _cargandoController = BehaviorSubject<bool>();

  final _productosProvder = ProductoProvider();

  Stream<List<ProductoModel>?> get productosStream =>
      _productosController.stream;

  Stream<bool> get cargando => _cargandoController.stream;

  // cargar producto
  void cargadoProductos() async {
    final productos = await _productosProvder.cargarProdutos();
    _productosController.sink.add(productos);
  }

  //agg producto
  void crearProductos(ProductoModel producto) async {
    // notificamos que estamos cargando algo
    _cargandoController.sink.add(true);
    // creamos el producto
    await _productosProvder.creaProducto(producto);

    // notificamos que ya dejamos de cargar algo
    _cargandoController.sink.add(false);
  }

  //agg producto
  void editarProductos(ProductoModel producto) async {
    // notificamos que estamos cargando algo
    _cargandoController.sink.add(true);
    // editar el producto
    await _productosProvder.editarProducto(producto);

    // notificamos que ya dejamos de cargar algo
    _cargandoController.sink.add(false);
  }

  //agg producto
  void eliminarProductos(String? id) async {
    // notificamos que estamos cargando algo
    _cargandoController.sink.add(true);
    // creamos el producto
    await _productosProvder.eliminaProducto(id);

    // notificamos que ya dejamos de cargar algo
    _cargandoController.sink.add(false);
  }

  // subir foto

  Future<String?> subirFoto(XFile? foto) async {
    _cargandoController.sink.add(true);
    final fotoUrl = await _productosProvder.subirImagen(foto);
    _cargandoController.sink.add(false);
    return fotoUrl;
  }

  dispose() {
    _productosController.close();
    _cargandoController.close();
  }
}
