import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gest_app/data/model/obstetra.dart';
import 'package:gest_app/service/obstetra_service.dart';

import 'package:intl/intl.dart' as intl;

class ProfileObs extends StatelessWidget {
  const ProfileObs({Key? key}) : super(key: key);

  static String id = '/profileObs';

  @override
  Widget build(BuildContext context) {
    return const ViewFormObs();
  }
}

class ViewFormObs extends StatefulWidget {
  const ViewFormObs({Key? key}) : super(key: key);

  @override
  State<ViewFormObs> createState() => _ViewFormObsState();
}

class _ViewFormObsState extends State<ViewFormObs> {
  final _keyForm = GlobalKey<FormState>();
  late bool _passwordVisible;
  final nombreController = TextEditingController();
  final apellidoController = TextEditingController();
  final correoController = TextEditingController();
  final telefonoController = TextEditingController();

  @override
  void initState() {
    _passwordVisible = false;
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
          title: const Text("Perfil"),
        ),
        body: FutureBuilder<Obstetra>(
          future: getObstetra(uid),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case (ConnectionState.waiting):
                return const Center(
                  child: CircularProgressIndicator(),
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
                    child: Column(
                      children: <Widget>[
                        const Padding(
                          padding: EdgeInsets.only(top: 12, bottom: 12),
                          child: Text(
                            'Actualice sus datos personales',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        Padding(
                            //! Nombre
                            padding: const EdgeInsets.all(8),
                            child: TextFormField(
                                controller: nombreController,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]")),
                                ],
                                keyboardType: TextInputType.name,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: "Nombre",
                                ),
                                validator: (value) {
                                  return ValidateText("Nombre", value!);
                                })),
                        Padding(
                            //! Apellido
                            padding: const EdgeInsets.all(8),
                            child: TextFormField(
                                controller: apellidoController,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]")),
                                ],
                                keyboardType: TextInputType.text,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: "Apellido",
                                ),
                                validator: (value) {
                                  return ValidateText("Apellido", value!);
                                })),
                        Padding(
                            //! Correo
                            padding: const EdgeInsets.all(8),
                            child: TextFormField(
                                enabled: false,
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
                            //! Telefono
                            padding: const EdgeInsets.all(8),
                            child: TextFormField(
                                controller: telefonoController,
                                keyboardType: TextInputType.number,
                                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: "Celular",
                                ),
                                validator: (value) {
                                  return ValidatePhoneNumber(value!);
                                })),
                        Padding(
                          padding: const EdgeInsets.only(top: 40),
                          child: ElevatedButton(
                            onPressed: () => {
                              if (_keyForm.currentState!.validate())
                                {
                                  updateObstetra(uid, nombreController.text, apellidoController.text,
                                          telefonoController.text, context)
                                      .then((value) => _updateObsSuccess(context))
                                      .onError((error, stackTrace) => _updateObsFailed(context))
                                }
                            },
                            child: const Text('Guardar'),
                          ),
                        ),
                      ],
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

ObstetraService _obstetraService = ObstetraService();

Future<Obstetra> getObstetra(String id) {
  return _obstetraService.getObstetra(id);
}

Future<void> updateObstetra(String id, String nombre, String apellido, String telefono, BuildContext context) {
  return _obstetraService.updateObstetra(id, nombre, apellido, telefono, context);
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
        contentPadding: EdgeInsets.only(right: 20, left: 20, top: 20, bottom: 10),
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
        contentPadding: EdgeInsets.only(right: 20, left: 20, top: 20, bottom: 10),
        actionsPadding: EdgeInsets.only(bottom: 10),
        title: Text(
          'Algo salió mal...',
          style: TextStyle(fontSize: 13),
        ),
        content: RichText(
          text: TextSpan(
            text: 'Su perfil no fue actualizado. Por favor, inténtelo más tarde',
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
