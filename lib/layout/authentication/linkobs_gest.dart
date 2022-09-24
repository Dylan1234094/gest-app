import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gest_app/data/model/obstetra.dart';
import 'package:gest_app/layout/authentication/register_gest.dart';
import 'package:gest_app/service/gestante_service.dart';

import '../../utilities/designs.dart';

class LinkObsGest extends StatelessWidget {
  const LinkObsGest({Key? key}) : super(key: key);

  static String id = 'linkObstetraGestante';

  @override
  Widget build(BuildContext context) {
    return const LinkObs();
  }
}

class LinkObs extends StatefulWidget {
  const LinkObs({Key? key}) : super(key: key);

  @override
  State<LinkObs> createState() => _LinkObsState();
}

class linkObsArguments {
  final String codigoObs;

  linkObsArguments(this.codigoObs);
}

class _LinkObsState extends State<LinkObs> {
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
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Form(
          key: _keyForm,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 20.0),
                  child: Text('Vinculación con Obstetra',
                      textAlign: TextAlign.center, style: kTitulo),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20.0),
                  child: Text(
                    'Ingresa el código de un(a) obstetra para compartirle sus resultados del monitoreo',
                    textAlign: TextAlign.justify,
                    style: kInfo,
                  ),
                ),
                Padding(
                  //! Código Obstetra
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: TextFormField(
                    controller: obsCodeController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 10.0),
                      border: OutlineInputBorder(),
                      labelText: "Código Obstetra",
                      labelStyle: kInfo,
                    ),
                    validator: (value) {
                      return ValidateCodeFormat(value!);
                    },
                  ),
                ),
                Center(
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: ElevatedButton(
                      onPressed: () => {
                        if (_keyForm.currentState!.validate())
                          {
                            _dialogWait(context),
                            validateCodeObstetra(obsCodeController.text)
                                .then((value) {
                              if (value.id != "") {
                                Navigator.pop(context);
                                _dialogCodeFound(context, value);
                              } else {
                                Navigator.pop(context);
                                _dialogCodeNotFound(
                                    context, obsCodeController.text);
                              }
                            })
                          }
                      },
                      child: const Text('VINCULAR'),
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(colorPrincipal),
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                        fixedSize:
                            MaterialStateProperty.all(const Size(160.0, 46.0)),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
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
        contentPadding:
            EdgeInsets.only(right: 20, left: 20, top: 20, bottom: 10),
        actionsPadding: EdgeInsets.only(bottom: 10),
        title: const Text('Código Inválido', style: TextStyle(fontSize: 13)),
        content: Text(
          'El código "$codeObs" no se encuentra asociado a ninguna obstetra.\n\nPor favor, consulte nuevamente con su especialista para ingresar el código correcto.',
          style: kPopUpInfo,
          textAlign: TextAlign.justify,
        ),
        actions: <Widget>[
          TextButton(
            child: Text('ACEPTAR', style: TextStyle(fontSize: 10)),
            onPressed: () => Navigator.pop(context),
          )
        ],
      );
    },
  );
}

Future<void> _dialogCodeFound(BuildContext context, Obstetra obstetra) {
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
            child: Text('ACEPTAR', style: TextStyle(fontSize: 10)),
            //onPressed: () => Navigator.pop(context),
            onPressed: () => Navigator.pushNamed(
              context,
              RegisterGest.id,
              arguments: linkObsArguments(obstetra.codigoObstetra!),
            ),
          )
        ],
      );
    },
  );
}

Future<Obstetra> validateCodeObstetra(String codeObs) async {
  GestanteService _gestanteService = GestanteService();

  return await _gestanteService.validateCodeObstetra(codeObs);
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
