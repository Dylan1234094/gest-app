import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gest_app/service/obstetra_service.dart';

import '../../utilities/designs.dart';

class LoginObsWidget extends StatelessWidget {
  const LoginObsWidget({Key? key}) : super(key: key);

  static String id = '/loginObstetra';

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
  final _keyForm = GlobalKey<FormState>();
  late bool _passwordVisible;
  final correoController = TextEditingController();
  final contraseniaController = TextEditingController();

  @override
  void initState() {
    _passwordVisible = false;
    super.initState();
  }

  @override
  void dispose() {
    correoController.dispose();
    contraseniaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 20),
              child: Text(
                "Inicio de sesión",
                textAlign: TextAlign.center,
                style: kTitulo1,
              ),
            ),
            Container(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 90.0),
                child: Hero(
                  tag: 'logo',
                  child: Image.asset('assets/Gest_Icon.png'),
                ),
              ),
            ),
            Form(
              key: _keyForm,
              child: Column(
                children: [
                  Padding(
                    //! Correo
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      style: TextStyle(fontSize: 13.0),
                      controller: correoController,
                      keyboardType: TextInputType.emailAddress,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.deny(RegExp("[ ]")),
                      ],
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 15.0, horizontal: 10.0),
                        border: OutlineInputBorder(),
                        labelText: "Correo",
                        labelStyle: kInfo,
                      ),
                      validator: (value) {
                        return ValidateEmail(value!);
                      },
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              //! Contraseña
              padding: const EdgeInsets.all(8),
              child: TextFormField(
                style: TextStyle(fontSize: 13.0),
                obscureText: !_passwordVisible,
                enableSuggestions: false,
                autocorrect: false,
                controller: contraseniaController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
                  border: const OutlineInputBorder(),
                  labelText: "Contraseña",
                  labelStyle: kInfo,
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _passwordVisible = !_passwordVisible;
                      });
                    },
                    icon: Icon(_passwordVisible
                        ? Icons.visibility
                        : Icons.visibility_off),
                  ),
                ),
                validator: (value) {
                  return ValidatePassword(value!);
                },
              ),
            ),
            Center(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(colorPrincipal),
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                    fixedSize:
                        MaterialStateProperty.all(const Size(190.0, 46.0)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                  onPressed: () => {
                    if (_keyForm.currentState!.validate())
                      {
                        loginObstetra(correoController.text,
                            contraseniaController.text, context)
                      }
                  },
                  child: const Text('INICIAR SESIÓN'),
                ),
              ),
            ),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: const TextStyle(color: Colors.black, fontSize: 15.0),
                children: <TextSpan>[
                  const TextSpan(text: '¿Olvidó su contraseña? '),
                  TextSpan(
                      text: 'Recupere su cuenta',
                      style: const TextStyle(color: colorPrincipal),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          //! Enviar a recuperar contraseña
                          print("Recuperar contraseña");
                        })
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: const TextStyle(color: Colors.black, fontSize: 15.0),
                  children: <TextSpan>[
                    const TextSpan(text: '¿No tiene cuenta? '),
                    TextSpan(
                        text: 'Regístrate',
                        style: const TextStyle(color: colorPrincipal),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.pushNamed(context, '/registerObstetra');
                          })
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

ObstetraService _obstetraService = ObstetraService();

void loginObstetra(String correo, String contrasenia, BuildContext context) {
  _dialogWait(context);
  _obstetraService.loginObstetra(correo, contrasenia, context);
}

String? ValidateEmail(String value) {
  if (value.isEmpty) {
    return 'Correo es obligatorio';
  }
  if (!RegExp(
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
      .hasMatch(value)) {
    return 'Correo no es válido';
  }
  return null;
}

String? ValidatePassword(String value) {
  if (value.isEmpty) {
    return 'Contraseña es obligatorio';
  }
  if (value.length < 6) {
    return 'Contraseña debe tener mínimo 6 carácteres';
  }
  return null;
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
