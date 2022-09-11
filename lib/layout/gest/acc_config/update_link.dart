import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gest_app/data/model/obstetra.dart';
import 'package:gest_app/service/gestante_service.dart';

import 'package:intl/intl.dart' as intl;

class UpdateLinkObs extends StatefulWidget {
  const UpdateLinkObs({Key? key}) : super(key: key);

  @override
  State<UpdateLinkObs> createState() => _UpdateLinkObsState();
}

class _UpdateLinkObsState extends State<UpdateLinkObs> {
  final _keyForm = GlobalKey<FormState>();
  final obsCodeController = TextEditingController();

  @override
  void dispose() {
    obsCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(""),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _keyForm,
          child: Column(
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.only(top: 10, left: 8, right: 8, bottom: 3),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Código de obstetra',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 8, right: 8, bottom: 10),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Ingresa el código de una Obstetra para enviar los resultados del monitoreo a su cuenta',
                  ),
                ),
              ),
              Padding(
                  //! Código Obstetra
                  padding: const EdgeInsets.all(8),
                  child: TextFormField(
                      controller: obsCodeController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Código Obstetra",
                      ),
                      validator: (value) {
                        return ValidateCodeFormat(value!);
                      })),
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  child: ElevatedButton(
                    onPressed: () => {
                      if (_keyForm.currentState!.validate())
                        {
                          _dialogWait(context),
                          validateCodeObstetra(obsCodeController.text).then((value) {
                            if (value.id != "") {
                              Navigator.pop(context);
                              _dialogCodeFound(context, value);
                            } else {
                              Navigator.pop(context);
                              _dialogCodeNotFound(context, obsCodeController.text);
                            }
                          })
                        }
                    },
                    child: const Text('GUARDAR'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
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

Future<void> _dialogCodeNotFound(BuildContext context, String codeObs) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        actions: <Widget>[
          TextButton(
            child: const Text("Aceptar"),
            style: TextButton.styleFrom(textStyle: Theme.of(context).textTheme.labelLarge),
            onPressed: () => Navigator.pop(context),
          )
        ],
        title: const Text("Código Inválido"),
        content: Text(
            "El código $codeObs no se encuentra asociado a ninguna obstetra.\n\nPor favor, consulte nuevamente con su especialista."),
      );
    },
  );
}

Future<void> _dialogCodeFound(BuildContext context, Obstetra obstetra) {
  var uid = FirebaseAuth.instance.currentUser!.uid;

  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        actions: <Widget>[
          TextButton(
            child: const Text("Aceptar"),
            style: TextButton.styleFrom(textStyle: Theme.of(context).textTheme.labelLarge),
            onPressed: () => updateCodigoObstetra(uid, obstetra.codigoObstetra!, context),
          )
        ],
        title: const Text("Código Válido"),
        content: RichText(
          text: TextSpan(
            style: const TextStyle(color: Colors.black, fontSize: 16.0),
            children: <TextSpan>[
              const TextSpan(text: "Sus datos serán compartidos con el/la especialista"),
              TextSpan(
                  text: " ${obstetra.nombre} ${obstetra.apellido}.",
                  style: const TextStyle(fontWeight: FontWeight.bold))
            ],
          ),
        ),
      );
    },
  );
}

Future<Obstetra> validateCodeObstetra(String codeObs) async {
  GestanteService _gestanteService = GestanteService();

  return await _gestanteService.validateCodeObstetra(codeObs);
}

void updateCodigoObstetra(String id, String codigoObs, BuildContext context) {
  GestanteService _gestanteService = GestanteService();

  return _gestanteService.updateCodeObstetra(id, codigoObs, context);
}

String? ValidateCodeFormat(String value) {
  if (value.isEmpty) {
    return 'Debe ingresar un código de obstetra';
  }
  if (value.length != 6) {
    return 'Código debe tener 6 dígitos';
  }
  return null;
}
