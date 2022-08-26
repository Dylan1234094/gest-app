// ignore_for_file: prefer_const_constructors, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gest_app/shared/textfield_date.dart';

class RegisterExamPage extends StatefulWidget {
  final String examId;
  const RegisterExamPage({Key? key, required this.examId}) : super(key: key);

  @override
  State<RegisterExamPage> createState() => _RegisterExamPageState();
}

class _RegisterExamPageState extends State<RegisterExamPage> {
  final _keyForm = GlobalKey<FormState>();
  final dateController = TextEditingController();

  void ConfirmDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: const Text('Confirmación'),
            content: const Text('¿Desea enviar los datos?'),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('No')),
              TextButton(
                  onPressed: () {
                    //! Actualizar exam

                    Navigator.of(context).pop();
                  },
                  child: const Text('Si'))
            ],
          );
        });
  }

  @override
  void dispose() {
    dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Text("Nombre del examen")),
        body: StreamBuilder<Object>(
            stream: null,
            builder: (context, snapshot) {
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: _keyForm,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 30, bottom: 20),
                          child: Text("Registro de Examen",
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold)),
                        ),
                        Text(
                            "Luego de realizar este examen en un centro especializado, registre el resultado a continuación",
                            textAlign: TextAlign.justify),
                        Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                decoration: InputDecoration(
                                  border: const OutlineInputBorder(),
                                  labelText: "Resultado (g/dL)",
                                ),
                                validator: (result) {
                                  return ValidateResult(result!);
                                })),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: MyTextFormDate(
                            label: "Fecha de entrega de resultados",
                            dateController: dateController,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 32),
                          child: ElevatedButton(
                            onPressed: () {
                              if (_keyForm.currentState!.validate()) {
                                print("Válido");
                                ConfirmDialog(context);
                              } else {
                                print("Invalido");
                              }
                            },
                            child: Text("GUARDAR"),
                            style: ButtonStyle(
                                fixedSize:
                                    MaterialStateProperty.all(Size(100, 40))),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            }),
      ),
    );
  }
}

String? ValidateResult(String result) {
  if (result.isEmpty) {
    return 'Resultado no puede estar vacio';
  }
  if (result[0] == '0') {
    return 'Resultado no puede ser cero';
  }
  return null;
}
