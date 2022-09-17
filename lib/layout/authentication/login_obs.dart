import 'package:flutter/gestures.dart';
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
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.only(top: 20),
              child: Text(
                "Inicio de sesión",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 20),
              width: 100,
              height: 100,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/Gest_Icon.png'),
                  fit: BoxFit.fill,
                ),
                shape: BoxShape.rectangle,
              ),
            ),
            Form(
              key: _keyForm,
              child: Column(
                children: [
                  Padding(
                      //! Correo
                      padding: const EdgeInsets.all(8),
                      child: TextFormField(
                          controller: correoController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Correo",
                          ),
                          validator: (value) {
                            return ValidateEmail(value!);
                          })),
                  Padding(
                      //! Contraseña
                      padding: const EdgeInsets.all(8),
                      child: TextFormField(
                          obscureText: !_passwordVisible,
                          enableSuggestions: false,
                          autocorrect: false,
                          controller: contraseniaController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              labelText: "Contraseña",
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _passwordVisible = !_passwordVisible;
                                    });
                                  },
                                  icon: Icon(_passwordVisible ? Icons.visibility : Icons.visibility_off))),
                          validator: (value) {
                            return ValidatePassword(value!);
                          })),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: ElevatedButton(
                style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(borderRadius: BorderRadius.circular(18))),
                    backgroundColor: MaterialStateProperty.all<Color>(const Color.fromRGBO(4, 121, 189, 1)),
                    foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                    fixedSize: MaterialStateProperty.all(const Size(180, 40))),
                onPressed: () => {
                  if (_keyForm.currentState!.validate())
                    {loginObstetra(correoController.text, contraseniaController.text, context)}
                },
                child: const Text('INICIAR SESIÓN'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: RichText(
                text: TextSpan(
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 15.0,
                  ),
                  children: <TextSpan>[
                    const TextSpan(text: '¿Olvidó su contraseña? '),
                    TextSpan(
                        text: 'Recupere su cuenta.',
                        style: const TextStyle(color: Colors.blue),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            //! Enviar a recuperar contraseña
                            print("Recuperar contraseña");
                          })
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 0),
              child: RichText(
                text: TextSpan(
                  style: const TextStyle(color: Colors.grey, fontSize: 15.0),
                  children: <TextSpan>[
                    const TextSpan(text: '¿No tiene cuenta? '),
                    TextSpan(
                        text: 'Regístrate.',
                        style: const TextStyle(color: Colors.blue),
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
    return 'Email es obligatorio';
  }
  if (!RegExp(
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
      .hasMatch(value)) {
    return 'Email no es válido';
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
