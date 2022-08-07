import 'package:flutter/material.dart';
import 'package:gest_app/service/obstetra_service.dart';

import 'package:intl/intl.dart' as intl;

class RegisterObs extends StatelessWidget {
  const RegisterObs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const FormObs();
  }
}

class FormObs extends StatefulWidget {
  const FormObs({Key? key}) : super(key: key);

  @override
  State<FormObs> createState() => _FormObsState();
}

class _FormObsState extends State<FormObs> {
  final nombreController = TextEditingController();
  final apellidoController = TextEditingController();
  final correoController = TextEditingController();
  final telefonoController = TextEditingController();
  final contraseniaController = TextEditingController();
  final contraseniaRepeController = TextEditingController();

  @override
  void dispose() {
    nombreController.dispose();
    apellidoController.dispose();
    correoController.dispose();
    telefonoController.dispose();
    contraseniaController.dispose();
    contraseniaRepeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Registre sus datos personales',
                ),
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
                controller: correoController,
                decoration: const InputDecoration(labelText: 'Correo'),
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
                controller: contraseniaController,
                decoration: const InputDecoration(labelText: 'Contraseña'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16, left: 8, right: 8),
              child: TextFormField(
                controller: contraseniaRepeController,
                decoration: const InputDecoration(labelText: 'Repita su Contraseña'),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: ElevatedButton(
                  onPressed: () => {
                    insertDataObstetra(nombreController.text, apellidoController.text, correoController.text, telefonoController.text,
                        contraseniaController.text, contraseniaRepeController.text, context)
                  },
                  child: const Text('FINALIZAR'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

ObstetraService _obstetraService = ObstetraService();

void insertDataObstetra(
    String nombre, String apellido, String correo, String telefono, String contrasenia, String contraseniaRepe, BuildContext context) {
  if (contrasenia == contraseniaRepe) {
    String codigoObstetra = "";

    _obstetraService.obtenerMaxCodigo().then((value) {
      intl.NumberFormat formatNumber = new intl.NumberFormat("000000");
      codigoObstetra = (formatNumber.format(value + 1).toString());
      _obstetraService.registerObstetra(nombre, apellido, correo, telefono, contrasenia, codigoObstetra, context);
    });
  } else {
    print("las contrasenias no son iguales");
  }
}
