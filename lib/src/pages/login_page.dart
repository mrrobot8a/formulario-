import 'package:bloc_formulario/src/utils/utils.dart';
import 'package:flutter/material.dart';
import '../bloc/login_bloc.dart';
import '../bloc/provider.dart';
import '../models/users_models.dart';
import '../providers/usuario_provider.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final usuarioProvider = UsuarioProvider();

  late UserModel usuario = UserModel();

  bool _loading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          _crearFondo(context),
          _loginForm(context),
        ],
      ),
    );
  }

  Widget _crearFondo(context) {
    final size = MediaQuery.of(context).size;
    final fondoMorado = Container(
      height: size.height * 0.4,
      width: double.infinity,
      decoration: const BoxDecoration(
        // PROPIEDAD QUE MEDA UN DEGRADADO LINEAN
        gradient: LinearGradient(
          colors: <Color>[
            Color.fromRGBO(63, 63, 156, 1.0),
            Color.fromRGBO(90, 70, 178, 1.0),
          ],
        ),
      ),
    );

    final circulo = Container(
      width: 100.0,
      height: 100.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100.0),
        color: Color.fromRGBO(255, 255, 255, 0.05),
      ),
    );

    // pordemos apilar stack
    return Stack(
      children: [
        fondoMorado,
        // el positioned me va ubicar el widget dentro de un stack
        // no se puede poner todas las propiedades
        Positioned(top: 100, left: 40, child: circulo),
        Positioned(top: -40, right: -30, child: circulo),
        Positioned(bottom: -50, left: -40, child: circulo),
        Positioned(bottom: -50, right: -20, child: circulo),
        Positioned(bottom: 100, right: 60, child: circulo),
// al no definirle un alto ni año el container se expande a todo el ancho de la pantall
        Container(
          padding: EdgeInsets.only(top: 60),
          child: Column(children: [
            Icon(
              Icons.person_pin_circle,
              size: 110.0,
              color: Colors.white,
            ),
            SizedBox(
              width: double.infinity,
              height: 10.0,
            ),
            Text(
              'Jhon anderson peralta ochoa',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            )
          ]),
        )
      ],
    );
  }

  Widget _loginForm(context) {
    final size = MediaQuery.of(context).size;
    // inicializamos el Provider en una varible ;  al pasarle el context desde aqqui al OF que esta en el provider
    // el busca en el arbor de widgets el context del clase Provider y me retorna instancia loginbloc que contiene los metodo
    //para manejar el estado y nos da acceso a el
    final bloc = Provider.of(context);

    final cuadro = Container(
      width: size.width * 0.85,
      margin: EdgeInsets.symmetric(vertical: 30.0),
      padding: EdgeInsets.symmetric(vertical: 50.0),
      height: size.height * .53,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5.0),
        boxShadow: <BoxShadow>[
          BoxShadow(
              color: Colors.black26,
              blurRadius: 3.0,
              offset: Offset(1.0, 6.0),
              spreadRadius: 3.0)
        ],
      ),
      child: Column(
        children: [
          Text('Ingreso'),
          SizedBox(
            height: 60.0,
          ),
          _crearEmail(bloc),
          SizedBox(
            height: 20.0,
          ),
          _crearPassword(bloc),
          SizedBox(
            height: 30.0,
          ),
          _crearBotton(context, bloc),
        ],
      ),
    );
    // me va  permitir hacer scroll dependiendo del alto o ancho que tenga su hijo
    // primordiar elementos que queremos el scroll
    return SingleChildScrollView(
        child: Column(
      children: [
        SafeArea(
          child: Container(
            height: 180.0,
          ),
        ),
        cuadro,
        TextButton(
          onPressed: () => Navigator.pushReplacementNamed(
            context,
            '/registrarPage',
          ),
          child: Text('¿crear una cuenta?'),
        ),
        SizedBox(
          height: 100.0,
        ),
      ],
    ));
  }

  _crearEmail(LoginBloc? bloc) {
    return StreamBuilder(
        stream: bloc
            ?.emailStream, //recuperamos  los datos al stream que enviamos con el sink
        builder: (_, AsyncSnapshot snapshot) {
          print('heeeeeeeeeeeeeeeeeeee');
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: TextField(
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                icon: Icon(Icons.alternate_email),
                hintText: 'ejemplo@correo.com',
                labelText: 'Correo electronico',
                counterText: snapshot.data,
                errorText: snapshot.error?.toString(),
              ),

              onChanged:
                  bloc?.changeEmail, // enviamos datos al stream con el sink
            ),
          );
        });
  }

  _crearPassword(LoginBloc? bloc) {
    return StreamBuilder(
        //<-------------------
        stream: bloc?.passwordStream,
        builder: (_, AsyncSnapshot snaps) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: StreamBuilder<Object>(
                //<------------------------
                stream: bloc!.iconoStream,
                initialData: true,
                builder: (context, AsyncSnapshot snapshotico) {
                  print(snapshotico.data);
                  return TextField(
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: bloc.geticono,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                          onPressed: () {
                            bloc.changeicono
                                .add(snapshotico.data ? false : true);
                          },
                          icon: Icon(snapshotico.data
                              ? Icons.remove_red_eye_outlined
                              : Icons.abc)),
                      icon: Icon(Icons.lock_outline),
                      labelText: 'Contraseña',
                      counterText: snaps.data,
                      errorText:
                          // ignore: prefer_null_aware_operators
                          snaps.error != null ? snaps.error.toString() : null,
                    ),
                    onChanged: bloc.changePassword,
                  );
                }),
          );
        });
  }

  _crearBotton(BuildContext context, LoginBloc? bloc) {
    return StreamBuilder<Object>(
        stream: bloc?.formValidStream,
        builder: (context, AsyncSnapshot snapshot) {
          return ElevatedButton(
            onPressed: snapshot.hasData && _loading
                ? () {
                    print(' combinacion de input stream${snapshot.data}');

                    _loading = false;

                    print(' aqui loadfing $_loading');
                    setState(() {});
                    _login(context, bloc);
                  }
                : null,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 80.0, vertical: 20.0),
              child: Text('ingresar'),
            ),
            style: ElevatedButton.styleFrom(
              elevation: 5,
              primary: Colors.deepPurple,
              textStyle: TextStyle(color: Colors.white),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          );
        });
  }

  _login(BuildContext context, LoginBloc? bloc) async {
    usuario.email = bloc?.getEmail;
    usuario.password = bloc?.getPassword;

    var resp = await usuarioProvider.inicarSesion(usuario);
    _loading = true;

    if (resp['ok']) {
      // ignore: use_build_context_synchronously
      Navigator.pushReplacementNamed(
        context,
        '/homePage',
      );
    } else {
      // ignore: use_build_context_synchronously
      await alertDialog(context, resp['mensaje']);
    }

    // Navigator.pushReplacementNamed(
    //   context,
    //   '/homePage',
    // );
  }
}
