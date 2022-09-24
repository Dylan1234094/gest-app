import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gest_app/layout/monitoring/gest_list.dart';
import 'package:gest_app/service/obstetra_service.dart';

import '../../../data/model/gestante.dart';
import '../../../data/model/obstetra.dart';
import '../../../service/gestante_service.dart';
import '../../../utilities/designs.dart';
import '../../monitoring/detailgest_obstetra.dart';

class DatosObstetra extends StatefulWidget {
  const DatosObstetra({Key? key}) : super(key: key);

  static String id = '/datosObstetra';

  @override
  State<DatosObstetra> createState() => _DatosObstetraState();
}

class _DatosObstetraState extends State<DatosObstetra> {
  var uid = FirebaseAuth.instance.currentUser!.uid;
  final _keyForm = GlobalKey<FormState>();
  final obsCodeController = TextEditingController();

  void ConfirmDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          contentPadding: EdgeInsets.only(right: 20, left: 20, top: 20, bottom: 10),
          actionsPadding: EdgeInsets.only(bottom: 10),
          title: Text(
            '¿Estás seguro de desvincular obstetra?',
            style: TextStyle(fontSize: 13),
          ),
          content: RichText(
            text: TextSpan(
              text: 'La obstetra actualmente vinculada dejará de controlar sus datos.',
              style: DefaultTextStyle.of(context).style,
            ),
          ),
          actions: [
            TextButton(
              child: Text("CANCELAR", style: TextStyle(fontSize: 10, color: colorSecundario)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("ACEPTAR", style: TextStyle(fontSize: 10)),
              onPressed: () {
                desvincularObstetra(uid, context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    obsCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mi Obstetra', style: kTituloCabezera),
      ),
      body: FutureBuilder<Gestante>(
        future: getGestante(uid),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case (ConnectionState.waiting):
              return const Center(
                child: CircularProgressIndicator(),
              );
            case (ConnectionState.done):
              if (snapshot.hasData) {
                return FutureBuilder<Obstetra>(
                    future: validateCodeObstetra(snapshot.data!.codigoObstetra!),
                    builder: (context, snapshotObs) {
                      switch (snapshotObs.connectionState) {
                        case (ConnectionState.waiting):
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        case (ConnectionState.done):
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
                            child: snapshotObs.data!.codigoObstetra! != ""
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.only(top: 10.0),
                                        child: Text(
                                          'Nombre: ${snapshotObs.data!.nombre!}',
                                          textAlign: TextAlign.start,
                                          style: kInfo,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(top: 20.0),
                                        child: Text('Apellido: ${snapshotObs.data!.nombre!}',
                                            textAlign: TextAlign.start, style: kInfo),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(top: 20.0),
                                        child: Text('Correo: ${snapshotObs.data!.correo!}',
                                            textAlign: TextAlign.start, style: kInfo),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(top: 20.0),
                                        child: Text('Código: ${snapshotObs.data!.codigoObstetra!}',
                                            textAlign: TextAlign.start, style: kInfo),
                                      ),
                                      Center(
                                        child: Padding(
                                          padding: EdgeInsets.all(20.0),
                                          child: ElevatedButton(
                                            onPressed: () => {ConfirmDialog(context)},
                                            child: const Text('DESVINCULAR', style: kTextoBoton),
                                            style: ButtonStyle(
                                              backgroundColor: MaterialStateProperty.all<Color>(colorPrincipal),
                                              foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                              fixedSize: MaterialStateProperty.all(const Size(160.0, 46.0)),
                                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(10.0),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  )
                                : SingleChildScrollView(
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
                                              },
                                            ),
                                          ),
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
                                                child: const Text('SIGUIENTE'),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                          );
                        default:
                          return const Text("Algo salió mal");
                      }
                    });
              } else {
                //GET ERROR BODY
                return const Text("ERROR BODY");
              }
            default:
              return const Text("Algo salió mal");
          }
        },
      ),
    );
  }
}

//Desvinculación
void desvincularObstetra(String id, BuildContext context) {
  GestanteService _gestanteService = GestanteService();

  return _gestanteService.desvincularObstetra(id, context);
}

//Vinculación
String? ValidateCodeFormat(String value) {
  if (value.isEmpty) {
    return 'Debe ingresar un código de obstetra';
  }
  if (value.length != 6) {
    return 'Código debe tener 6 dígitos';
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

Future<void> _dialogCodeFound(BuildContext context, Obstetra obstetra) {
  var uid = FirebaseAuth.instance.currentUser!.uid;

  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        contentPadding: EdgeInsets.only(right: 20, left: 20, top: 20, bottom: 10),
        actionsPadding: EdgeInsets.only(bottom: 10),
        title: Text(
          'Vinculación exitosa',
          style: TextStyle(fontSize: 13),
        ),
        content: RichText(
          text: TextSpan(
            text: 'La obstetra ',
            style: DefaultTextStyle.of(context).style,
            children: <TextSpan>[
              TextSpan(
                text: '${obstetra.nombre} ${obstetra.apellido}.',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(text: 'estará controlando sus datos a partir del momento.')
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text("ACEPTAR", style: TextStyle(fontSize: 10)),
            onPressed: () {
              updateCodigoObstetra(uid, obstetra.codigoObstetra!, obstetra.fcmToken!, context);
            },
          )
        ],
      );
    },
  );
}

Future<void> _dialogCodeNotFound(BuildContext context, String codeObs) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        contentPadding:
            EdgeInsets.only(right: 20, left: 20, top: 20, bottom: 10),
        actionsPadding: EdgeInsets.only(bottom: 10),
        title: Text('Vinculación exitosa', style: TextStyle(fontSize: 13)),
        content: Text(
          'El/La obstetra ${obstetra.nombre} ${obstetra.apellido} estará controlando sus datos a partir del momento.',
          style: kPopUpInfo,
          textAlign: TextAlign.justify,
        ),
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
<<<<<<< HEAD

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

void updateCodigoObstetra(String id, String codigoObs, String fcmToken, BuildContext context) {
  GestanteService _gestanteService = GestanteService();

  return _gestanteService.updateCodeObstetra(id, codigoObs, fcmToken, context);
}

Future<Obstetra> validateCodeObstetra(String codeObs) async {
  GestanteService _gestanteService = GestanteService();

  return await _gestanteService.validateCodeObstetra(codeObs);
}
=======
>>>>>>> origin/diseños

void updateCodigoObstetra(String id, String codigoObs, String fcmToken, BuildContext context) {
  GestanteService _gestanteService = GestanteService();

  return _gestanteService.updateCodeObstetra(id, codigoObs, fcmToken, context);
}

Future<Obstetra> validateCodeObstetra(String codeObs) async {
  GestanteService _gestanteService = GestanteService();

  return await _gestanteService.validateCodeObstetra(codeObs);
}
