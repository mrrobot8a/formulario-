import 'dart:io';

import 'package:bloc_formulario/src/bloc/provider.dart';
import 'package:bloc_formulario/src/models/producto_models.dart';
import 'package:bloc_formulario/src/pages/home_page.dart';

import 'package:image_picker/image_picker.dart';

import '../bloc/producto_bloc.dart';
import '../utils/utils.dart' as utils;
import 'package:flutter/material.dart';

class ProductPage extends StatefulWidget {
  ProductPage({Key? key}) : super(key: key);

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  late ProductoModel producto = ProductoModel();

  ProductosBloc? productosBloc;

  bool _guardando = false;
  XFile? archivo;
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    // al ser una varible declarada en la clase la podemos utilizar en todo lado
    productosBloc = Provider.productosBloc(context);

// recibimos el producnto medel que fue enviado por parametros
    final ProductoModel? prodData =
        ModalRoute.of(context)?.settings.arguments as ProductoModel?;

    // ignore: unnecessary_null_comparison
    // verificamos que el objeto llege null o no

    // si llega null es por que es para agregar un producto y si no seetea el producto que vamos editar y los carga
    if (prodData != null) {
      producto = prodData;
    }
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('productos'),
        actions: [
          IconButton(
            onPressed: () => _mostraGaleria(ImageSource.gallery),
            icon: Icon(Icons.photo_size_select_actual),
          ),
          IconButton(
            onPressed: () => _mostraGaleria(ImageSource.camera),
            icon: Icon(Icons.camera_alt),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15.0),
          child: Form(
              key: formKey, // identificador unico de este formulario
              child: Column(
                children: [
                  Text('hello'),
                  _mostrarfoto(),
                  _crearNombre(),
                  _crearPrecio(),
                  _crearDisponible(),
                  _crearBoton(),
                ],
              )),
        ),
      ),
    );
  }

  _crearNombre() {
    return TextFormField(
      onSaved: (newValue) => producto.titulo = newValue,
      initialValue: producto.titulo,
      keyboardType: TextInputType.text,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: 'Producto',
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return ' El campo no puede estar vacio';
        } else {
          return null;
        }
      },
    );
  }

  _crearPrecio() {
    return TextFormField(
      keyboardType: TextInputType.number,
      initialValue: producto.valor == 0.0 ? null : producto.valor.toString(),
      textCapitalization: TextCapitalization.sentences,

      decoration: InputDecoration(
        labelText: 'Precio',
        hintText: '0.0',
      ),
      // on saved no ayuda  acaptura los valores depues de la validacion
      onSaved: (newValue) => producto.valor = double.parse(newValue!),
      validator: (value) {
        if (utils.isNumber(value)) {
          return null;
        } else {
          return 'Solo numeros';
        }
      },
    );
  }

  _crearBoton() {
    return ElevatedButton(
      onPressed: (_guardando) ? null : _submit,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: _guardando
            ? [
                Center(
                  child: CircularProgressIndicator(),
                )
              ]
            : [
                Icon(Icons.save),
                SizedBox(
                  width: 5.0,
                ),
                Text('Guardar'),
              ],
      ),
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 12.0),
        elevation: 5,
        primary: Colors.deepPurple,
        textStyle: TextStyle(color: Colors.white),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }

  void _submit() async {
    // aqui hacemos al formulario y a los textformfield y   asus propiedades
    // esta funcion me vefica que todas la validaciones del los textfORMfield
    if (!formKey.currentState!.validate()) return print('fallo sumit');
    // esta instruccion nos dispara la funcion de onsave de todos los textFromField que este dentro del formulario
    formKey.currentState!.save();

    print(producto.titulo);
    print(producto.valor);
    print(producto.disponible);

    setState(() {
      _guardando = true;
    });

    if (archivo != null) {
      producto.fotoUrl = await productosBloc?.subirFoto(archivo);
    }

    //validamos si el producto existe ,si no exite se crea  si exite lo edita
    if (producto.id == null) {
      //enviando el objeto producto
      productosBloc?.crearProductos(producto);
    } else {
      productosBloc?.editarProductos(producto);
    }
    Future.delayed(Duration(seconds: 1), () async {
      setState(() {
        _guardando = false;
      });
      await alertDialog(context);
    });
    //  mostrarSnackbar('Registro guardado ');
    // ignore: use_build_context_synchronously

    print('todo ok');
  }

  void mostrarSnackbar(String mensaje) {
    final snackBar = SnackBar(
      content: Text(mensaje),
      duration: Duration(microseconds: 1500),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  alertDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Done'),
            content: Text('Add Success'),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    //     BORRAR pantalla NO regresar a pantalla BACK BUTTON
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute<void>(
                          builder: (BuildContext context) => HomePage()),
                      (Route<dynamic> route) => false,
                    );
                  },
                  child: Text(
                    'cancelar',
                    style: TextStyle(color: Colors.black),
                  )),
              ElevatedButton(
                child: Text('Ok'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  _crearDisponible() {
    return SwitchListTile(
      value: producto.disponible,
      title: Text('Disponible'),
      activeColor: Colors.deepPurple,
      onChanged: (value) => setState(() {
        producto.disponible = value;
      }),
    );
  }

  Widget _mostrarfoto() {
    if (producto.fotoUrl != null) {
      return FadeInImage(
        height: 400.0,
        width: 400.0,
        fit: BoxFit.fill,
        placeholder: AssetImage('assets/17.1 jar-loading.gif'),
        image: NetworkImage(producto.fotoUrl.toString()),
      );
    } else {
      return archivo?.path == null
          ? Image(
              image: AssetImage(archivo?.path ?? 'assets/17.2 no-image.png'),
              height: 300.0,
              fit: BoxFit.fill,
            )
          : Container(
              width: 400.0,
              height: 400.0,
              child: Image.file(
                File(archivo!.path),
                fit: BoxFit.fill,
              ),
            );
    }
    ;
  }

  void _mostraGaleria(ImageSource activarPicker) async {
    archivo = await _picker.pickImage(source: activarPicker);
    //borrar la la foto anterios para darle la nueva que seleccionamos
    if (archivo != null) {
      producto.fotoUrl = null;
    }
    ;
    setState(() {});
  }
}
