// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gest_app/shared/textfield_date.dart';

class UpdateExamPage extends StatefulWidget {
  final String examId;
  const UpdateExamPage({Key? key, required this.examId}) : super(key: key);

  @override
  State<UpdateExamPage> createState() => _UpdateExamPageState();
}

class _UpdateExamPageState extends State<UpdateExamPage> {
  final dateController = TextEditingController();

  void ConfirmDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: const Text('Confirmación'),
            content: const Text('¿Desea actualizar los datos?'),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('No')),
              TextButton(
                  onPressed: () {
                    //! Crear el examen

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
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 30, bottom: 20),
                        child: Text("Actualizar examen",
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold)),
                      ),
                      Text("Edite el resultado a continuación",
                          textAlign: TextAlign.justify),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Resultado (g/dL)',
                          ),
                        ),
                      ),
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
                            ConfirmDialog(context);
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
              );
            }),
      ),
    );
  }
}
