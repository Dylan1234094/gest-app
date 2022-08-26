import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  final _keyForm = GlobalKey<FormState>();
  late bool _passwordVisible;
  final nombreController = TextEditingController();
  final apellidoController = TextEditingController();
  final correoController = TextEditingController();
  final telefonoController = TextEditingController();
  final contraseniaController = TextEditingController();
  final contraseniaRepeController = TextEditingController();

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
    contraseniaController.dispose();
    contraseniaRepeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Registro de Obstetra"),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _keyForm,
          child: Column(
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 25),
                child: Center(
                  child: Text(
                    'Registro de datos',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 8, right: 8),
                child: Center(
                  child: Text(
                    'Registre sus datos personales',
                    style: TextStyle(fontSize: 16),
                  ),
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
                  //! Contraseña
                  padding: const EdgeInsets.all(8),
                  child: TextFormField(
                      obscureText: !_passwordVisible,
                      enableSuggestions: false,
                      autocorrect: false,
                      controller: contraseniaController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: "Contraseña",
                          suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _passwordVisible = !_passwordVisible;
                                });
                              },
                              icon: Icon(_passwordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off))),
                      validator: (value) {
                        if (ValidatePassword(value!) == null) {
                          if (contraseniaController.text !=
                              contraseniaRepeController.text) {
                            return 'Las Contraseñas no son iguales';
                          }
                        }
                        return ValidatePassword(value);
                      })),
              Padding(
                  //! Contraseña
                  padding: const EdgeInsets.all(8),
                  child: TextFormField(
                      obscureText: !_passwordVisible,
                      enableSuggestions: false,
                      autocorrect: false,
                      controller: contraseniaRepeController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: "Repetir contraseña",
                          suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _passwordVisible = !_passwordVisible;
                                });
                              },
                              icon: Icon(_passwordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off))),
                      validator: (value) {
                        if (ValidatePassword(value!) == null) {
                          if (contraseniaController.text !=
                              contraseniaRepeController.text) {
                            return 'Las Contraseñas no son iguales';
                          }
                        }
                        return ValidatePassword(value);
                      })),
              Padding(
                padding: const EdgeInsets.only(top: 40),
                child: ElevatedButton(
                  onPressed: () => {
                    if (_keyForm.currentState!.validate())
                      {
                        insertDataObstetra(
                            nombreController.text,
                            apellidoController.text,
                            correoController.text,
                            telefonoController.text,
                            contraseniaController.text,
                            contraseniaRepeController.text,
                            context)
                      }
                  },
                  child: const Text('Registrarse'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

ObstetraService _obstetraService = ObstetraService();

void insertDataObstetra(
    String nombre,
    String apellido,
    String correo,
    String telefono,
    String contrasenia,
    String contraseniaRepe,
    BuildContext context) {
  if (contrasenia == contraseniaRepe) {
    String codigoObstetra = "";

    _obstetraService.obtenerMaxCodigo().then((value) {
      intl.NumberFormat formatNumber = new intl.NumberFormat("000000");
      codigoObstetra = (formatNumber.format(value + 1).toString());
      _obstetraService.registerObstetra(nombre, apellido, correo, telefono,
          contrasenia, codigoObstetra, context);
    });
  } else {
    print("las contrasenias no son iguales");
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
