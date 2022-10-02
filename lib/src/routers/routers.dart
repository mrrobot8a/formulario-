import 'package:bloc_formulario/src/pages/registro_page.dart';
import 'package:flutter/material.dart';

import '../pages/home_page.dart';
import '../pages/login_page.dart';
import '../pages/producto_page.dart';

Map<String, WidgetBuilder> getApplicationRoutes() {
  return <String, WidgetBuilder>{
    '/loginPage': (context) => LoginPage(),
    '/registrarPage': (context) => RegistroPage(),
    '/homePage': (context) => HomePage(),
    '/productoPage': (context) => ProductPage(),
  };
}
