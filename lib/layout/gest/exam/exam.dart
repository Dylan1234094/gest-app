// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class RegisterExamPage extends StatefulWidget {
  const RegisterExamPage({Key? key}) : super(key: key);

  @override
  State<RegisterExamPage> createState() => _RegisterExamPageState();
}

class _RegisterExamPageState extends State<RegisterExamPage> {
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
          title: Text("EXAMEN DE LABORATORIO"),
          actions: [],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text(
                  "Luego de realizar este examen en un centro especializado, registre el resultado a continuación"),
              SizedBox(height: 20),
              Text("Examen de laboratorio"),
              TextField(
                enabled: false,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Nombre de examen"',
                ),
              ),
              SizedBox(height: 20),
              Text("Resultado"),
              TextField(
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: '150',
                ),
              ),
              SizedBox(height: 20),
              Text("Fecha de entrega"),
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Date picker',
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(onPressed: () {}, child: Text("ACEPTAR"))
            ],
          ),
        ),
      ),
    );
  }
}
