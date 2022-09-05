import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gest_app/data/model/gestante.dart';
import 'package:gest_app/service/gestante_service.dart';
import 'package:gest_app/shared/date_input.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gest_app/shared/textfield_date.dart';

class ProfileGest extends StatelessWidget {
  const ProfileGest({Key? key}) : super(key: key);

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

  registerGestArguments(this.nombre, this.apellido, this.correo, this.telefono, this.dni, this.fechaNacimiento,
      this.fechaRegla, this.fechaEco, this.fechaCita);
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
        title: const Text("Perfil"),
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
                          padding: EdgeInsets.only(left: 8, right: 8, bottom: 10),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text('Actualice sus datos personales'),
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
                        Padding(
                          padding: const EdgeInsets.only(top: 40),
                          child: ElevatedButton(
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
          }),
    );
  }
}

Future<Gestante> getGestante(String id) {
  GestanteService _gestanteService = GestanteService();

  return _gestanteService.getGestante(id);
}

void updateGestante(String id, String nombre, String apellido, String telefono, String dni, String fechaNacimiento,
    String fechaRegla, String fechaEco, String fechaCita, BuildContext context) {
  GestanteService _gestanteService = GestanteService();

  _gestanteService.updateGestante(
      id, nombre, apellido, telefono, dni, fechaNacimiento, fechaRegla, fechaEco, fechaCita, context);
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
