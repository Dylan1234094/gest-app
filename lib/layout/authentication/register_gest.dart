import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gest_app/layout/authentication/linkobs_gest.dart';
import 'package:gest_app/layout/authentication/vitalsigns_gest.dart';
import 'package:gest_app/shared/date_input.dart';
import 'package:gest_app/service/gestante_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gest_app/shared/textfield_date.dart';

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

class registerGestArguments {
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

  registerGestArguments(this.nombre, this.apellido, this.correo, this.telefono, this.dni, this.fechaNacimiento,
      this.fechaRegla, this.fechaEco, this.fechaCita, this.fcmTokenObs, this.codigoObs);
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
    final args = ModalRoute.of(context)!.settings.arguments as linkObsArguments;
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
            padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.only(top: 20.0),
                  child: Text('Registro de Datos', textAlign: TextAlign.center, style: kTitulo),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 20.0, bottom: 12.0),
                  child: Text(
                    'Registre sus datos que permitan a usted y al obstetra brindar un mejor monitoreo de su estado de salud gestacional.',
                    style: kInfo,
                  ),
                ),
                InputTextWidget(
                  //! Nombre
                  Controller: nombreController,
                  Formatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]")),
                  ],
                  Label: 'Nombre(s)',
                  inputType: TextInputType.text,
                  Validator: (value) {
                    return ValidateText("Nombre", value!);
                  },
                  Enabled: true,
                ),
                InputTextWidget(
                  //! Apellido
                  Controller: apellidoController,
                  Formatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]")),
                  ],
                  Label: 'Apellido(s)',
                  inputType: TextInputType.text,
                  Validator: (value) {
                    return ValidateText("Apellido", value!);
                  },
                  Enabled: true,
                ),
                InputTextWidget(
                  //! Celular
                  Controller: telefonoController,
                  Formatters: [FilteringTextInputFormatter.digitsOnly],
                  Label: 'Celular',
                  inputType: TextInputType.number,
                  Validator: (value) {
                    return ValidatePhoneNumber(value!);
                  },
                  Enabled: true,
                ),
                InputTextWidget(
                  //! Correo
                  Controller: correoController,
                  Formatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]")),
                  ],
                  Label: 'Correo',
                  inputType: TextInputType.emailAddress,
                  Enabled: false,
                ),
                InputTextWidget(
                  //! DNI
                  Controller: dniController,
                  Formatters: [FilteringTextInputFormatter.digitsOnly],
                  Label: 'DNI',
                  inputType: TextInputType.number,
                  Validator: (value) {
                    return ValidateDNI(value!);
                  },
                  Enabled: true,
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
                    padding: EdgeInsets.all(20.0),
                    child: ElevatedButton(
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
                      onPressed: () => {
                        if (_keyForm.currentState!.validate())
                          {
                            Navigator.pushNamed(context, VitalSignsGest.id,
                                arguments: registerGestArguments(
                                    nombreController.text,
                                    apellidoController.text,
                                    correoController.text,
                                    telefonoController.text,
                                    dniController.text,
                                    fechaNacimientoController.text,
                                    fechaReglaController.text,
                                    fechaEcoController.text,
                                    fechaCitaController.text,
                                    linkObsController.text))
                          }
                      },
                      child: const Text('SIGUIENTE', style: kTextoBoton),
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
  InputTextWidget({
    required this.Controller,
    required this.Formatters,
    required this.Label,
    required this.inputType,
    this.Validator,
    required this.Enabled,
  });

  final TextEditingController Controller;
  final TextInputType inputType;
  final List<TextInputFormatter> Formatters;
  final String Label;
  final FormFieldValidator<String>? Validator;
  final bool Enabled;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        style: TextStyle(fontSize: 13.0),
        enabled: Enabled,
        controller: Controller,
        keyboardType: inputType,
        inputFormatters: Formatters,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
          border: OutlineInputBorder(),
          labelText: Label,
          labelStyle: kInfo,
        ),
        validator: Validator,
      ),
    );
  }
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

String? ValidateDNI(String value) {
  if (value.isEmpty) {
    return 'DNI es obligatorio';
  }
  if (value.length != 8) {
    return 'Celular debe tener 8 dígitos';
  }
  return null;
}
