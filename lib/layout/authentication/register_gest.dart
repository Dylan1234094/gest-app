import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gest_app/layout/authentication/linkobs_gest.dart';
import 'package:gest_app/shared/date_input.dart';
import 'package:gest_app/service/gestante_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gest_app/shared/textfield_date.dart';

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
      appBar: AppBar(
        title: const Text("Perfil"),
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
                    'Mi perfil',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 8, right: 8, bottom: 12),
                child: Text(
                  'Registre sus datos que permitan a usted y al obstetra brindar un mejor monitoreo de su estado de salud gestacional. ',
                ),
              ),
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
                  )),
              Padding(
                  //! Nombre
                  padding: const EdgeInsets.all(8),
                  child: TextFormField(
                      controller: nombreController,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]")),
                      ],
                      keyboardType: TextInputType.text,
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
                  //! DNI
                  padding: const EdgeInsets.all(8),
                  child: TextFormField(
                      controller: dniController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "DNI",
                      ),
                      validator: (value) {
                        return ValidateDNI(value!);
                      })),
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
              const Divider(
                height: 20,
                thickness: 1,
                color: Color.fromARGB(255, 199, 199, 199),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  child: ElevatedButton(
                    onPressed: () => {
                      if (_keyForm.currentState!.validate())
                        {
                          Navigator.pushNamed(context, '/vitalSignsGestante',
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
