import 'package:shared_preferences/shared_preferences.dart';

class PreferenciasUsuario {
  static final PreferenciasUsuario _instancia = PreferenciasUsuario._internal();

  // patron singleton siempre va a devolver la misma instancia de la clase , el mismo espacio de memeria siempre que se hace new

  //cuando acen new disparan el contructor que me devuelve la misma intancia =  _instancia
  //carga rapida
  factory PreferenciasUsuario() {
    // constructor normal
    return _instancia;
  }

  PreferenciasUsuario._internal(); // metodo internal contructor

  SharedPreferences? _prefs;

//
  initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // // ninguna de estas propiedades se usan

  // bool? _colorsecundario;
  // int? _genero;
  // String? _nombre;

  // get y set del genero

  get getgenero {
    return _prefs!.getInt('genero') ?? 1;
  }

  set setgenero(int value) {
    _prefs?.setInt('genero', value);
  }

  // get y set del Color secundario

  get getColorSecundario {
    return _prefs!.getBool('colorSe') ?? false;
  }

  set setColorSecundario(bool value) {
    _prefs?.setBool('colorSe', value);
  }

  // get y set del token

  get getToke {
    return _prefs!.getString('Token') ?? '';
  }

  set setToken(String value) {
    _prefs?.setString('Token', value);
  }

  // get y set del la ruta de la ultima pagina
  get getUtimaPagina {
    return _prefs!.getString('ulPagina') ?? 'home';
  }

  set setUltimaPagina(String value) {
    _prefs?.setString('ulPagina', value);
  }
}
