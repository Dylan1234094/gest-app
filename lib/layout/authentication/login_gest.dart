import 'package:flutter/material.dart';
import 'package:gest_app/layout/gest/guide/guide_detail.dart';
import 'package:gest_app/layout/gest/tabs.dart';
import 'package:gest_app/service/gestante_service.dart';
import 'package:googleapis/fitness/v1.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginGestWidget extends StatelessWidget {
  const LoginGestWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const LoginGest();
  }
}

class LoginGest extends StatefulWidget {
  const LoginGest({Key? key}) : super(key: key);

  @override
  State<LoginGest> createState() => _LoginGestState();
}

class _LoginGestState extends State<LoginGest> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Iniciar Sesión"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: Text(
                  "Inicie sesión con su cuenta de Google para continuar con la configuración de su cuenta"),
            ),
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: ElevatedButton(
                  onPressed: () => {loginGestante(context)},
                  child: const Text('INICIAR SESIÓN CON GOOGLE'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

GestanteService _gestanteService = GestanteService();

void loginGestante(BuildContext context) {
  _gestanteService.signInGestante(context);
  // Navigator.of(context).push(
  //   MaterialPageRoute<void>(builder: (BuildContext context) {
  //     return Tabs();
  //   }),
  // );
}

void logoutGestante(BuildContext context) {
  _gestanteService.signOutGestante(context);
}
