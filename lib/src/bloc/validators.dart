import 'dart:async';

class Validators {
  final validarEmail =
      // sele indica que tipo de dato va  recibir y que tipo de dato va emitir <dato de entrada ,dato de salisa>
      StreamTransformer<String, String>.fromHandlers(
    // (recibimos el string o la data del streambuilder, sink para enviar la data al stream )
    handleData: ((email, sink) {
      Pattern pattern =
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
      // expresion regular
      RegExp regExp = RegExp(pattern.toString());
      // si los datos son correctos los agrega al stream con el sink
      if (regExp.hasMatch(email)) {
        sink.add(email);

        // con es error retorna que hay un error , esto lo captura el snapshot.error
      } else if (email.isEmpty) {
        sink.addError('el campo esta vacio');
      } else {
        sink.addError('correo erroneo');
      }
    }),
  );

  final validarPassword =
      // sele indica que tipo de dato va  recibir y que tipo de dato va emitir <dato de entrada ,dato de salisa>
      StreamTransformer<String, String>.fromHandlers(
    handleData: ((password, sink) {
      if (password.length >= 6) {
        sink.add(password);
      } else if (password.isEmpty) {
        sink.addError('el campo esta vacio');
      } else {
        sink.addError('Password mayor de 6');
      }
    }),
  );

  final validarIcon = StreamTransformer<bool, bool>.fromHandlers(
    handleData: ((bool interruptor, sink) {
      if (interruptor) {
        sink.add(true);
        print('true aqui');
      } else if (interruptor == null) {
        sink.add(false);
      } else {
        sink.add(false);
        print('false aqui');
      }
    }),
  );
}
