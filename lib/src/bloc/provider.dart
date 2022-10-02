import 'package:bloc_formulario/src/bloc/producto_bloc.dart';
import 'package:flutter/material.dart';

import 'login_bloc.dart';

// este provaider puede manejarme varios bloc al mismo tiempo

class Provider extends InheritedWidget {
  // se puede poner mas variables- o intancias de blocs que queremos manejar global mente
  final loginBloc = LoginBloc();
  final _loginProducto = ProductosBloc();

  static Provider? _instancia;

// de la linea 11 ala 15 es un singleton
// contruncto primado por _internal
  Provider._internal({
    Key? key,
    required Widget child,
    required this.isvisble,
  }) : super(child: child);

  factory Provider({
    Key? key,
    required Widget child,
    required bool isVisble,
  }) =>
      // aqui el constructo factory me va regresa la la instacia anterios al hot reload
      //si la intacia no esta creada cree la instancia con los datos que ya tiene
      //pero si la instacia ya esta creada no instancie otra vez la el constructor si no mantengame esa misma
      // instancia con los mismo datos
      _instancia ??= Provider._internal(
        key: key,
        isvisble: isVisble,
        child: child,
      );

  bool isvisble; // valor agregado por mi

  // ak actulizarse , me actualice todos sus hijos
  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => true;

// va   buscar en todo el arbor el widget provider que es este
  static LoginBloc? of(BuildContext context) {
    // que se vaya abuscar en estes contexto la instacia del provider widgets y conviertame esa instancia y regreseme la instancia de  loginBloc
    return (context.dependOnInheritedWidgetOfExactType<Provider>() as Provider)
        .loginBloc;
  }

  // va   buscar en todo el arbor el widget provider que es este
  static ProductosBloc? productosBloc(BuildContext context) {
    // que se vaya abuscar en estes contexto la instacia del provider widgets y conviertame esa instancia y regreseme la instancia de  loginBloc
    return (context.dependOnInheritedWidgetOfExactType<Provider>() as Provider)
        ._loginProducto;
  }
}

// class Myinhere extends InheritedWidget {
//   Myinhere({
//     required Widget child,
//     required this.value,
//   }) : super(child: child);

//   double value;

//   static Myinhere of(BuildContext context) =>
//       context.findAncestorWidgetOfExactType<Myinhere>()!;

//   @override
//   bool updateShouldNotify(covariant Myinhere oldWidget) =>
//       oldWidget.value != value;
// }
