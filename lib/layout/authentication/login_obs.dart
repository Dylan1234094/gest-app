import 'package:flutter/material.dart';
import 'package:gest_app/service/obstetra_service.dart';

class LoginObsWidget extends StatelessWidget {
  const LoginObsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const LoginObs();
  }
}

class LoginObs extends StatefulWidget {
  const LoginObs({Key? key}) : super(key: key);

  @override
  State<LoginObs> createState() => _LoginObsState();
}

class _LoginObsState extends State<LoginObs> {
  final correoController = TextEditingController();
  final contraseniaController = TextEditingController();

  @override
  void dispose() {
    correoController.dispose();
    contraseniaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Iniciar Sesión"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
              child: TextFormField(
                controller: correoController,
                decoration: const InputDecoration(labelText: 'Correo'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16, left: 8, right: 8),
              child: TextFormField(
                controller: contraseniaController,
                decoration: const InputDecoration(labelText: 'Contraseña'),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: ElevatedButton(
                  onPressed: () => {loginObstetra(correoController.text, contraseniaController.text, context)},
                  child: const Text('INICIAR SESIÓN'),
                ),
              ),
            ),
            ElevatedButton(
                style: ButtonStyle(foregroundColor: MaterialStateProperty.all<Color>(Colors.white)),
                onPressed: () {
                  Navigator.pushNamed(context, '/registerObstetra');
                },
                child: const Text('Registrarse'))
          ],
        ),
      ),
    );
  }
}

ObstetraService _obstetraService = ObstetraService();

void loginObstetra(String correo, String contrasenia, BuildContext context) {
  _obstetraService.loginObstetra(correo, contrasenia, context);
}
