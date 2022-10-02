import 'dart:async';

import 'package:rxdart/rxdart.dart';

import 'validators.dart';

class LoginBloc with Validators {
  // el streamcroller se cambio por el bahavior que es lo mismo pero
  //este pertenerce al package rxdart
  final _emailController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();
  final _iconController = BehaviorSubject<bool>()..add(true);

// recuperar respuesta o datos del stream enviados por el sink
  Stream<String> get emailStream =>
      _emailController.stream.transform(validarEmail);
  // se le pasa el streamstranform al strem de nuestro contrroller
  Stream<String> get passwordStream =>
      _passwordController.stream.transform(validarPassword);

  Stream<bool> get iconoStream => _iconController.stream.transform(validarIcon);

  Stream<bool> get formValidStream =>
      // cambina dos respuesta de dos stream para saber si tienen data o no , esto me regresa un string
      // con el que podemos proceder a hacer una validacion en este caso si que los dos campos cumplen con la codiciones
      // como ya pasaron por el validator tenemos el resultado
      Rx.combineLatest2(emailStream, passwordStream, (e, p) => true);

// insertar valores el stream
  Function(String) get changeEmail => _emailController.sink.add;
  Function(String) get changePassword => _passwordController.sink.add;

// obtener el ultimo valor emitido por los stream
  String get getEmail => _emailController.value;
  String get getPassword => _passwordController.value;
  bool get geticono => _iconController.value;

// insertar valores  al steam del icono
  Sink<bool> get changeicono => _iconController.sink;

  dispose() {
    _iconController.close();
    _emailController.close();
    _passwordController.close();
  }
}
