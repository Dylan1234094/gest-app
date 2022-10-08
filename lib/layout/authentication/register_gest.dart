import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gest_app/layout/authentication/linkobs_gest.dart';
import 'package:gest_app/layout/authentication/vitalsigns_gest.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gest_app/utilities/textfield_date.dart';

import '../../utilities/designs.dart';

class RegisterGest extends StatelessWidget {
  const RegisterGest({Key? key}) : super(key: key);

  static String id = '/registerGestante';

  @override
  Widget build(BuildContext context) {
    return const FormGest();
  }
}

class FormGest extends StatefulWidget {
  const FormGest({Key? key}) : super(key: key);

  @override
  State<FormGest> createState() => _FormGestState();
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
  final String fcmTokenObs;
  final String codigoObs;

  RegisterGestArguments(
      this.nombre,
      this.apellido,
      this.correo,
      this.telefono,
      this.dni,
      this.fechaNacimiento,
      this.fechaRegla,
      this.fechaEco,
      this.fechaCita,
      this.fcmTokenObs,
      this.codigoObs);
}

class _FormGestState extends State<FormGest> {
  final nombreController = TextEditingController();
  final apellidoController = TextEditingController();
  final correoController = TextEditingController();
  final telefonoController = TextEditingController();
  final dniController = TextEditingController();
  final fechaNacimientoController = TextEditingController();
  final fechaReglaController = TextEditingController();
  final fechaEcoController = TextEditingController();
  final fechaCitaController = TextEditingController();
  final linkObsController = TextEditingController();
  final fcmTokenObsController = TextEditingController();

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
    linkObsController.dispose();
    fcmTokenObsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _keyForm = GlobalKey<FormState>();
    final args = ModalRoute.of(context)!.settings.arguments as LinkObsArguments;
    var correo = FirebaseAuth.instance.currentUser!.email;

    linkObsController.text = args.codigoObs;
    fcmTokenObsController.text = args.fcmTokenObs;
    correoController.text = correo!;

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
                const Padding(
                  padding: EdgeInsets.only(top: 20.0),
                  child: Text('Registro de Datos',
                      textAlign: TextAlign.center, style: kTitulo1),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 20.0, bottom: 12.0),
                  child: Text(
                    'Registre sus datos que permitan a usted y al obstetra brindar un mejor monitoreo de su estado de salud gestacional.',
                    style: kDescripcion,
                  ),
                ),
                InputTextWidget(
                  //! Nombre
                  controlador: nombreController,
                  formatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]")),
                  ],
                  label: 'Nombre(s)',
                  inputType: TextInputType.text,
                  validacion: (value) {
                    return validateText("Nombre", value!);
                  },
                  habilitado: true,
                ),
                InputTextWidget(
                  //! Apellido
                  controlador: apellidoController,
                  formatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp("[a-z A-Z á-ú]")),
                  ],
                  label: 'Apellido(s)',
                  inputType: TextInputType.text,
                  validacion: (value) {
                    return validateText("Apellido", value!);
                  },
                  habilitado: true,
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
                  habilitado: true,
                ),
                InputTextWidget(
                  //! Correo
                  controlador: correoController,
                  formatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.deny(RegExp("[ ]")),
                  ],
                  label: 'Correo',
                  inputType: TextInputType.emailAddress,
                  habilitado: false,
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
                  habilitado: true,
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
                      onPressed: () => {
                        if (_keyForm.currentState!.validate())
                          {
                            Navigator.pushNamed(context, VitalSignsGest.id,
                                arguments: RegisterGestArguments(
                                    nombreController.text,
                                    apellidoController.text,
                                    correoController.text,
                                    telefonoController.text,
                                    dniController.text,
                                    fechaNacimientoController.text,
                                    fechaReglaController.text,
                                    fechaEcoController.text,
                                    fechaCitaController.text,
                                    fcmTokenObsController.text,
                                    linkObsController.text))
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
    required this.habilitado,
  }) : super(key: key);

  final TextEditingController controlador;
  final TextInputType inputType;
  final List<TextInputFormatter> formatters;
  final String label;
  final FormFieldValidator<String>? validacion;
  final bool habilitado;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        style: const TextStyle(fontSize: 13.0),
        enabled: habilitado,
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
