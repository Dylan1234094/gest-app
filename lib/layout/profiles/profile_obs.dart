import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gest_app/data/model/obstetra.dart';
import 'package:gest_app/service/obstetra_service.dart';
import 'package:gest_app/utilities/designs.dart';

class ProfileObs extends StatelessWidget {
  const ProfileObs();

  static String id = '/profileObs';

  @override
  Widget build(BuildContext context) {
    return const ViewFormObs();
  }
}

class ViewFormObs extends StatefulWidget {
  const ViewFormObs();

  @override
  State<ViewFormObs> createState() => _ViewFormObsState();
}

class _ViewFormObsState extends State<ViewFormObs> {
  final _keyForm = GlobalKey<FormState>();
  final nombreController = TextEditingController();
  final apellidoController = TextEditingController();
  final correoController = TextEditingController();
  final telefonoController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    nombreController.dispose();
    apellidoController.dispose();
    correoController.dispose();
    telefonoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var uid = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
        appBar: AppBar(
          title: const Text("Perfil", style: kTituloCabezera),
        ),
        body: FutureBuilder<Obstetra>(
          future: getObstetra(uid),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case (ConnectionState.waiting):
                return SizedBox(
                  height: MediaQuery.of(context).size.height / 1.3,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              case (ConnectionState.done):
                if (!snapshot.hasData) {
                  return const Center(
                    child: Text("Algo salió mal..."),
                  );
                }
                nombreController.text = snapshot.data!.nombre!;
                apellidoController.text = snapshot.data!.apellido!;
                correoController.text = snapshot.data!.correo!;
                telefonoController.text = snapshot.data!.telefono!;
                return SingleChildScrollView(
                  child: Form(
                    key: _keyForm,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20.0, horizontal: 10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          const Padding(
                            padding: EdgeInsets.only(bottom: 10.0),
                            child: Text('Actualice sus datos personales',
                                style: kDescripcion),
                          ),
                          InputTextWidget(
                            //! Nombre
                            controlador: nombreController,
                            formatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(
                                  RegExp("[a-z A-Z á-ú ]")),
                            ],
                            label: 'Nombre(s)',
                            inputType: TextInputType.text,
                            validacion: (value) {
                              return ValidateText("Nombre", value!);
                            },
                          ),
                          InputTextWidget(
                            //! Apellido
                            controlador: apellidoController,
                            formatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(
                                  RegExp("[a-z A-Z á-ú ]")),
                            ],
                            label: 'Apellido(s)',
                            inputType: TextInputType.text,
                            validacion: (value) {
                              return ValidateText("Apellido", value!);
                            },
                          ),
                          InputTextWidget(
                            //! Correo
                            controlador: correoController,
                            formatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.deny(RegExp("[ ]")),
                            ],
                            label: 'Correo',
                            inputType: TextInputType.emailAddress,
                            validacion: (value) {
                              return ValidateEmail(value!);
                            },
                          ),
                          InputTextWidget(
                            //! Celular
                            controlador: telefonoController,
                            formatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            label: 'Celular',
                            inputType: TextInputType.number,
                            validacion: (value) {
                              return ValidatePhoneNumber(value!);
                            },
                          ),
                          Center(
                            child: Padding(
                              padding: EdgeInsets.all(20.0),
                              child: ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          colorPrincipal),
                                  foregroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.white),
                                  fixedSize: MaterialStateProperty.all(
                                      const Size(160.0, 46.0)),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  ),
                                ),
                                onPressed: () => {
                                  if (_keyForm.currentState!.validate())
                                    {
                                      updateObstetra(
                                        uid,
                                        nombreController.text,
                                        apellidoController.text,
                                        telefonoController.text,
                                        context,
                                      )
                                          .then((value) =>
                                              _updateObsSuccess(context))
                                          .onError(
                                            (error, stackTrace) =>
                                                _updateObsFailed(context),
                                          )
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
              default:
                return const Text("Algo salió mal");
            }
          },
        ));
  }
}

class InputTextWidget extends StatelessWidget {
  InputTextWidget({
    required this.controlador,
    required this.formatters,
    required this.label,
    required this.inputType,
    required this.validacion,
  });

  final TextEditingController controlador;
  final TextInputType inputType;
  final List<TextInputFormatter> formatters;
  final String label;
  final FormFieldValidator<String>? validacion;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        style: TextStyle(fontSize: 13.0),
        controller: controlador,
        keyboardType: inputType,
        inputFormatters: formatters,
        decoration: InputDecoration(
          contentPadding:
              EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
          border: OutlineInputBorder(),
          labelText: label,
          labelStyle: kSubTitulo1,
        ),
        validator: validacion,
      ),
    );
  }
}

ObstetraService _obstetraService = ObstetraService();

Future<Obstetra> getObstetra(String id) {
  return _obstetraService.getObstetra(id);
}

Future<void> updateObstetra(String id, String nombre, String apellido,
    String telefono, BuildContext context) {
  return _obstetraService.updateObstetra(
      id, nombre, apellido, telefono, context);
}

String? ValidateText(String label, String value) {
  if (value.isEmpty) {
    return '${label} es obligatorio';
  }
  if (value.length < 3) {
    return '${label} debe tener mínimo 3 carácteres';
  }
  return null;
}

String? ValidatePhoneNumber(String value) {
  if (value.isEmpty) {
    return 'Celular es obligatorio';
  }
  if (value[0] != '9') {
    return 'Celular debe comenzar con 9';
  }
  if (value.length != 9) {
    return 'Celular debe tener 9 dígitos';
  }
  return null;
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

Future<void> _updateObsSuccess(BuildContext context) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        contentPadding:
            EdgeInsets.only(right: 20, left: 20, top: 20, bottom: 10),
        actionsPadding: EdgeInsets.only(bottom: 10),
        title: Text(
          'Perfil Actualizado',
          style: TextStyle(fontSize: 13),
        ),
        content: RichText(
          text: TextSpan(
            text: 'Su perfil fue actualizado correctamente',
            style: DefaultTextStyle.of(context).style,
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text("ACEPTAR", style: TextStyle(fontSize: 10)),
            onPressed: () {
              Navigator.of(context).popUntil(ModalRoute.withName("/"));
            },
          )
        ],
      );
    },
  );
}

Future<void> _updateObsFailed(BuildContext context) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        contentPadding:
            EdgeInsets.only(right: 20, left: 20, top: 20, bottom: 10),
        actionsPadding: EdgeInsets.only(bottom: 10),
        title: Text(
          'Algo salió mal...',
          style: TextStyle(fontSize: 13),
        ),
        content: RichText(
          text: TextSpan(
            text:
                'Su perfil no fue actualizado. Por favor, inténtelo más tarde',
            style: DefaultTextStyle.of(context).style,
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text("ACEPTAR", style: TextStyle(fontSize: 10)),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ],
      );
    },
  );
}
