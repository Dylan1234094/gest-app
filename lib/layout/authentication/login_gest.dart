import 'package:flutter/material.dart';
import 'package:gest_app/layout/gest/tabs.dart';
import 'package:gest_app/service/gestante_service.dart';

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
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.only(top: 20),
              child: Text(
                "Inicio de sesión",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),
            ),
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 25),
                child: Text(
                    "Inicie sesión con su cuenta de Google para continuar con la configuración de su cuenta"),
              ),
            ),
            InkWell(
              onTap: () {
                loginGestante(context);
              },
              child: Ink(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  color: Colors.white,
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 7,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(6),
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Image.asset('Google_G_icon.png',
                          width: 25,
                          height: 25), // <-- Use 'Image.asset(...)' here
                      const SizedBox(width: 4),
                      const Text('Iniciar sesión con Google')
                    ],
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 20),
              width: 250,
              height: 400,
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('Gest_Login.png'), fit: BoxFit.fill),
                shape: BoxShape.rectangle,
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
  Navigator.of(context).push(
    MaterialPageRoute<void>(builder: (BuildContext context) {
      return const Tabs();
    }),
  );
}

void logoutGestante(BuildContext context) {
  _gestanteService.signOutGestante(context);
}
