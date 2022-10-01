import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gest_app/data/model/gestante.dart';
import 'package:gest_app/service/gestante_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gest_app/utilities/textfield_date.dart';
import 'package:gest_app/utilities/designs.dart';

class ProfileGest extends StatelessWidget {
  const ProfileGest({Key? key}) : super(key: key);

  static String id = '/profileGest';

  @override
  Widget build(BuildContext context) {
    return const ViewFormGest();
  }
}

class ViewFormGest extends StatefulWidget {
  const ViewFormGest({Key? key}) : super(key: key);

  @override
  State<ViewFormGest> createState() => _ViewFormGestState();
}

class RegisterGestArguments {
  final String nombre;
  final String apellido;
  final String correo;
  final String telefono;
  final String dni;
  final String fechaNacimiento;
  final String fechaRegla;
  final String fechaEco;
  final String fechaCita;

  RegisterGestArguments(
      this.nombre,
      this.apellido,
      this.correo,
      this.telefono,
      this.dni,
      this.fechaNacimiento,
      this.fechaRegla,
      this.fechaEco,
      this.fechaCita);
}

class _ViewFormGestState extends State<ViewFormGest> {
  final _keyForm = GlobalKey<FormState>();
  final nombreController = TextEditingController();
  final apellidoController = TextEditingController();
  final correoController = TextEditingController();
  final telefonoController = TextEditingController();
  final dniController = TextEditingController();
  final fechaNacimientoController = TextEditingController();
  final fechaReglaController = TextEditingController();
  final fechaEcoController = TextEditingController();
  final fechaCitaController = TextEditingController();

  @override
  void dispose() {
    nombreController.dispose();
    apellidoController.dispose();
    correoController.dispose();
    telefonoController.dispose();
    dniController.dispose();
    fechaNacimientoController.dispose();
    fechaReglaController.dispose();
    fechaEcoController.dispose();
    fechaCitaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var correo = FirebaseAuth.instance.currentUser!.email;
    var uid = FirebaseAuth.instance.currentUser!.uid;

    correoController.text = correo!;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Perfil", style: kTituloCabezera),
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
              if (!snapshot.hasData) {
                return const Center(
                  child: Text("Algo salió mal..."),
                );
              }
              nombreController.text = snapshot.data!.nombre!;
              apellidoController.text = snapshot.data!.apellido!;
              telefonoController.text = snapshot.data!.telefono!;
              dniController.text = snapshot.data!.dni!;
              fechaNacimientoController.text = snapshot.data!.fechaNacimiento!;
              fechaReglaController.text = snapshot.data!.fechaRegla!;
              fechaEcoController.text = snapshot.data!.fechaEco!;
              fechaCitaController.text = snapshot.data!.fechaCita!;
              return SingleChildScrollView(
                child: Form(
                  key: _keyForm,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20.0, horizontal: 10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
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
                            return validateText("Nombre", value!);
                          },
                          enabled: true,
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
                            return validateText("Apellido", value!);
                          },
                          enabled: true,
                        ),
                        InputTextWidget(
                          //! Celular
                          controlador: telefonoController,
                          formatters: [FilteringTextInputFormatter.digitsOnly],
                          label: 'Celular',
                          inputType: TextInputType.number,
                          validacion: (value) {
                            return validatePhoneNumber(value!);
                          },
                          enabled: true,
                        ),
                        InputTextWidget(
                          //! Correo
                          controlador: correoController,
                          formatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(
                                RegExp("[a-z A-Z á-ú ]")),
                          ],
                          label: 'Correo',
                          inputType: TextInputType.emailAddress,
                          enabled: false,
                        ),
                        InputTextWidget(
                          //! DNI
                          controlador: dniController,
                          formatters: [FilteringTextInputFormatter.digitsOnly],
                          label: 'DNI',
                          inputType: TextInputType.number,
                          validacion: (value) {
                            return validateDNI(value!);
                          },
                          enabled: true,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: MyTextFormDate(
                            label: 'Fecha de nacimiento',
                            dateController: fechaNacimientoController,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: MyTextFormDate(
                            label: 'Fecha de última regla',
                            dateController: fechaReglaController,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: MyTextFormDate(
                            label: 'Fecha de primera ecografía',
                            dateController: fechaEcoController,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: MyTextFormDate(
                            label: 'Fecha de primera cita',
                            dateController: fechaCitaController,
                          ),
                        ),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
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
                                    updateGestante(
                                            uid,
                                            nombreController.text,
                                            apellidoController.text,
                                            telefonoController.text,
                                            dniController.text,
                                            fechaNacimientoController.text,
                                            fechaReglaController.text,
                                            fechaEcoController.text,
                                            fechaCitaController.text,
                                            context)
                                        .then((value) =>
                                            updateGestSuccess(context))
                                        .onError((error, stackTrace) =>
                                            updateGestFailed(context))
                                  },
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
      ),
    );
  }
}

class InputTextWidget extends StatelessWidget {
  const InputTextWidget({
    Key? key,
    required this.controlador,
    required this.formatters,
    required this.label,
    required this.inputType,
    this.validacion,
    required this.enabled,
  }) : super(key: key);

  final TextEditingController controlador;
  final TextInputType inputType;
  final List<TextInputFormatter> formatters;
  final String label;
  final FormFieldValidator<String>? validacion;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        style: const TextStyle(fontSize: 13.0),
        enabled: enabled,
        controller: controlador,
        keyboardType: inputType,
        inputFormatters: formatters,
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
          border: const OutlineInputBorder(),
          labelText: label,
          labelStyle: kSubTitulo1,
        ),
        validator: validacion,
      ),
    );
  }
}

Future<Gestante> getGestante(String id) {
  GestanteService _gestanteService = GestanteService();

  return _gestanteService.getGestante(id);
}

Future<void> updateGestante(
    String id,
    String nombre,
    String apellido,
    String telefono,
    String dni,
    String fechaNacimiento,
    String fechaRegla,
    String fechaEco,
    String fechaCita,
    BuildContext context) {
  GestanteService _gestanteService = GestanteService();

  return _gestanteService.updateGestante(id, nombre, apellido, telefono, dni,
      fechaNacimiento, fechaRegla, fechaEco, fechaCita, context);
}

String? validateText(String label, String value) {
  if (value.isEmpty) {
    return '$label es obligatorio';
  }
  if (value.length < 3) {
    return '$label debe tener mínimo 3 carácteres';
  }
  return null;
}

String? validatePhoneNumber(String value) {
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

String? validateDNI(String value) {
  if (value.isEmpty) {
    return 'DNI es obligatorio';
  }
  if (value.length != 8) {
    return 'DNI debe tener 8 dígitos';
  }
  return null;
}

Future<void> updateGestSuccess(BuildContext context) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        contentPadding:
            const EdgeInsets.only(right: 20, left: 20, top: 20, bottom: 10),
        actionsPadding: const EdgeInsets.only(bottom: 10),
        title: const Text(
          'Perfil Actualizado',
          style: TextStyle(fontSize: 13),
        ),
        content: RichText(
          text: TextSpan(
            text: 'Su perfil se ha actualizado correctamente',
            style: DefaultTextStyle.of(context).style,
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text("ACEPTAR", style: TextStyle(fontSize: 10)),
            onPressed: () {
              Navigator.of(context).popUntil(ModalRoute.withName("/"));
            },
          )
        ],
      );
    },
  );
}

Future<void> updateGestFailed(BuildContext context) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        contentPadding:
            const EdgeInsets.only(right: 20, left: 20, top: 20, bottom: 10),
        actionsPadding: const EdgeInsets.only(bottom: 10),
        title: const Text(
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
            child: const Text("ACEPTAR", style: TextStyle(fontSize: 10)),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ],
      );
    },
  );
}
