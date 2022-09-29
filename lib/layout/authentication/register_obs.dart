import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gest_app/service/obstetra_service.dart';

import 'package:intl/intl.dart' as intl;

import '../../utilities/designs.dart';

class RegisterObs extends StatelessWidget {
  const RegisterObs({Key? key}) : super(key: key);

  static String id = '/registerObstetra';

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
                    'Registre sus datos personales',
                    style: kDescripcion,
                  ),
                ),
                InputTextWidget(
                  //! Nombre
                  controlador: nombreController,
                  inputType: TextInputType.text,
                  formatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp("[a-z A-Z á-ú]")),
                  ],
                  label: 'Nombre',
                  validacion: (value) {
                    return ValidateText("Nombre", value!);
                  },
                ),
                InputTextWidget(
                  //! Apellido
                  controlador: apellidoController,
                  inputType: TextInputType.text,
                  formatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp("[a-z A-Z á-ú]")),
                  ],
                  label: 'Apellido',
                  validacion: (value) {
                    return ValidateText("Apellido", value!);
                  },
                ),
                InputTextWidget(
                  //! Correo
                  controlador: correoController,
                  inputType: TextInputType.emailAddress,
                  formatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.deny(RegExp("[ ]")),
                  ],
                  label: 'Correo',
                  validacion: (value) {
                    return ValidateEmail(value!);
                  },
                ),
                InputTextWidget(
                  //! Telefono
                  controlador: telefonoController,
                  inputType: TextInputType.number,
                  formatters: [FilteringTextInputFormatter.digitsOnly],
                  label: 'Celular',
                  validacion: (value) {
                    return ValidatePhoneNumber(value!);
                  },
                ),
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
                          labelStyle: kSubTitulo1,
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _passwordVisible = !_passwordVisible;
                              });
                            },
                            icon: Icon(_passwordVisible
                                ? Icons.visibility
                                : Icons.visibility_off),
                          ),
                        ),
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
                          labelStyle: kSubTitulo1,
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _passwordVisible = !_passwordVisible;
                              });
                            },
                            icon: Icon(_passwordVisible
                                ? Icons.visibility
                                : Icons.visibility_off),
                          ),
                        ),
                        validator: (value) {
                          if (ValidatePassword(value!) == null) {
                            if (contraseniaController.text !=
                                contraseniaRepeController.text) {
                              return 'Las Contraseñas no son iguales';
                            }
                          }
                          return ValidatePassword(value);
                        })),
                Center(
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(colorPrincipal),
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                        fixedSize:
                            MaterialStateProperty.all(const Size(190.0, 46.0)),
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
                      child: const Text('REGISTRARSE'),
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
  const InputTextWidget(
      {required this.controlador,
      required this.inputType,
      required this.formatters,
      required this.label,
      required this.validacion});

  final TextEditingController controlador;
  final TextInputType inputType;
  final List<TextInputFormatter> formatters;
  final String label;
  final FormFieldValidator<String>? validacion;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: TextFormField(
          style: TextStyle(fontSize: 13.0),
          controller: controlador,
          inputFormatters: formatters,
          keyboardType: inputType,
          decoration: InputDecoration(
            contentPadding:
                EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
            border: OutlineInputBorder(),
            labelText: label,
            labelStyle: kSubTitulo1,
          ),
          validator: validacion),
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
