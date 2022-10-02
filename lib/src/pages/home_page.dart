import 'package:bloc_formulario/src/bloc/producto_bloc.dart';
import 'package:bloc_formulario/src/providers/producto_providers.dart';
import 'package:flutter/material.dart';

import '../bloc/provider.dart';
import '../models/producto_models.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    // TODO: implement initState
    // _loadData();
    // productosBloc?.cargadoProductos();
    super.initState();
  }

  // final productosProvider = ProductoProvider();
  // final productosProvide = ProductoProvider();
  ProductosBloc? productosBloc;
  Future<List<ProductoModel>>? tempoList;

  @override
  Widget build(BuildContext context) {
    final blocProductos = Provider.productosBloc(context);
    blocProductos?.cargadoProductos();

    return Scaffold(
      appBar: AppBar(
        title: Text('Home page'),
        actions: [
          Icon(Icons.refresh),
        ],
      ),
      body: _crearListadoProductos(blocProductos),
      floatingActionButton: _crearFloatinbutton(context),
    );
  }

  _crearFloatinbutton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.pushNamed(context, '/productoPage')
            .then((value) => //_loadData()
                productosBloc?.cargadoProductos());
        print('hello');
      },
      backgroundColor: Colors.deepPurple,
      child: Icon(
        Icons.add,
      ),
    );
  }

  Widget _crearListadoProductos(ProductosBloc? blocProducto) {
    return StreamBuilder(
      stream: blocProducto?.productosStream,
      builder: (context, AsyncSnapshot<List<ProductoModel>?> snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data?.length,
            itemBuilder: (context, index) {
              return _crearItemList(
                  context, snapshot.data?[index], blocProducto);
            },
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}

Widget _crearItemList(BuildContext context, ProductoModel? productoM,
    ProductosBloc? productosBloc) {
  return Dismissible(
      key: UniqueKey(),
      background: Container(
        color: Colors.red,
      ),
      onDismissed: (direccion) =>
          productosBloc?.eliminarProductos(productoM?.id),
      child: Card(
        child: InkWell(
          onTap: () => Navigator.pushNamed(context, '/productoPage',
                  arguments: productoM)
              .then((value) => //_loadData()
                  productosBloc?.cargadoProductos()),
          child: Column(
            children: [
              (productoM?.fotoUrl == null)
                  ? Image(image: AssetImage('assets/17.2 no-image.png'))
                  : FadeInImage(
                      height: 300.0,
                      width: 400.0,
                      fit: BoxFit.fill,
                      placeholder: AssetImage('assets/17.1 jar-loading.gif'),
                      image: NetworkImage(productoM!.fotoUrl.toString()),
                    ),
              ListTile(
                title: Text('${productoM?.titulo} - ${productoM?.valor} '),
                subtitle: Text('${productoM?.id.toString()}'),

                //lo que puede que no quede tan claro es que esta misma navegación nos funciona al momento de de hacer el back
                //para ejecutar el código que nosotros queremos ejecutar al momento de regresar a la página inicial,
              ),
            ],
          ),
        ),
      ));
}

  // void _loadData() {
  //   setState(() {
  //     tempoList = productosProvider.cargarProdutos();
  //   });
  // }

