import 'package:flutter/material.dart';
import 'package:gest_app/layout/gest/tabs.dart';
import '../../utilities/designs.dart';
import 'package:gest_app/service/gestante_service.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class LoginGestWidget extends StatelessWidget {
  const LoginGestWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const LoginGest();
  }
}

class LoginGest extends StatefulWidget {
  const LoginGest({Key? key}) : super(key: key);

  static String id = 'loginGestante';

  @override
  State<LoginGest> createState() => _LoginGestState();
}

class _LoginGestState extends State<LoginGest> {
  final RoundedLoadingButtonController googleController =
      RoundedLoadingButtonController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20.0),
              child: Text('Inicio de Sesión', style: kTitulo),
            ),
            Text(
              "Inicie sesión con su cuenta de Google para continuar con la configuración de su cuenta",
              textAlign: TextAlign.justify,
              style: kInfo,
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: RoundedLoadingButton(
                controller: googleController,
                color: Colors.white,
                valueColor: colorPrincipal,
                successColor: colorPrincipal,
                elevation: 10,
                onPressed: () => {loginGestante(context)},
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/google_icon.png',
                        width: 30, height: 30),
                    SizedBox(width: 5.0),
                    Text(
                      'Iniciar sesión con Google',
                      style: TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.w500,
                          color: colorSecundario),
                    )
                  ],
                ),
              ),
            ),
            Flexible(
              child: Image.asset('assets/mujer_embarazada.png'),
            )
          ],
        ),
      ),
    );
  }
}

GestanteService _gestanteService = GestanteService();

void loginGestante(BuildContext context) {
  //_dialogWait(context);
  _gestanteService.signInGestante(context);
}

void logoutGestante(BuildContext context) {
  _gestanteService.signOutGestante(context);
}

Future<void> _dialogWait(BuildContext context) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        content: Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width / 10,
          height: MediaQuery.of(context).size.height / 10,
          child: const CircularProgressIndicator(),
        ),
      );
    },
  );
}
