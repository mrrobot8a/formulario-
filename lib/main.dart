import 'package:flutter/material.dart';

import 'src/bloc/provider.dart';
import 'src/routers/routers.dart';
import 'src/shared_preferene/preferences_usuario.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs =
      PreferenciasUsuario(); // toda mi aplicacion va a tener las preferencias cargadas antes de que se dibujen los widgets
  await prefs
      .initPrefs(); // hasta que las preferencia sean cargadas  inicie miapp
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  final prefs = PreferenciasUsuario();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    print(prefs.getToke);
    return Provider(
      isVisble: false,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
          primaryColor: Colors.deepPurple,
        ),
        initialRoute: '/loginPage',
        routes: getApplicationRoutes(),
      ),
    );
  }
}
