import 'package:flutter/material.dart';
import 'package:gest_app/layout/authentication/linkobs_gest.dart';
import 'package:gest_app/shared/date_input.dart';
import 'package:gest_app/service/gestante_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterGest extends StatelessWidget {
  const RegisterGest({Key? key}) : super(key: key);

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
  final String codigoObs;

  registerGestArguments(
      this.nombre,
      this.apellido,
      this.correo,
      this.telefono,
      this.dni,
      this.fechaNacimiento,
      this.fechaRegla,
      this.fechaEco,
      this.fechaCita,
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as linkObsArguments;
    var correo = FirebaseAuth.instance.currentUser!.email;

    linkObsController.text = args.codigoObs;
    correoController.text = correo!;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Perfil"),
      ),
      body: SingleChildScrollView(
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
              padding: EdgeInsets.only(left: 8, right: 8),
              child: Text(
                'Registre sus datos que permitan a usted y al obstetra brindar un mejor monitoreo de su estado de salud gestacional. ',
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
              child: TextFormField(
                enabled: false,
                controller: correoController,
                decoration: const InputDecoration(labelText: 'Correo'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
              child: TextFormField(
                controller: nombreController,
                decoration: const InputDecoration(labelText: 'Nombre'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
              child: TextFormField(
                controller: apellidoController,
                decoration: const InputDecoration(labelText: 'Apellido'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
              child: TextFormField(
                controller: telefonoController,
                decoration: const InputDecoration(labelText: 'Teléfono'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16, left: 8, right: 8),
              child: TextFormField(
                controller: dniController,
                decoration: const InputDecoration(labelText: 'DNI'),
              ),
            ),
            MyDateInput(
              label: 'Fecha de nacimiento',
              dateController: fechaNacimientoController,
            ),
            MyDateInput(
              label: 'Fecha de última regla',
              dateController: fechaReglaController,
            ),
            MyDateInput(
              label: 'Fecha de primera ecografía',
              dateController: fechaEcoController,
            ),
            MyDateInput(
              label: 'Fecha de primera cita',
              dateController: fechaCitaController,
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
                            linkObsController.text))
                  },
                  child: const Text('SIGUIENTE'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
