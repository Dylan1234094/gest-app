import 'package:flutter/material.dart';
import 'package:gest_app/service/obstetra_service.dart';

import 'package:intl/intl.dart' as intl;

class LinkObsGest extends StatelessWidget {
  const LinkObsGest({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const LinkObs();
  }
}

class LinkObs extends StatefulWidget {
  const LinkObs({Key? key}) : super(key: key);

  @override
  State<LinkObs> createState() => _LinkObsState();
}

class linkObsArguments {
  final String codigoObs;

  linkObsArguments(this.codigoObs);
}

class _LinkObsState extends State<LinkObs> {
  final obsCodeController = TextEditingController();

  @override
  void dispose() {
    obsCodeController.dispose();
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
                  'Código de obstetra',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 8, right: 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Ingresa el código de una Obstetra para enviar los resultados del monitoreo a su cuenta',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16, left: 8, right: 8),
              child: TextFormField(
                controller: obsCodeController,
                decoration: const InputDecoration(labelText: 'Codigo'),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: ElevatedButton(
                  onPressed: () => {Navigator.pushNamed(context, '/registerGestante', arguments: linkObsArguments(obsCodeController.text))},
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

ObstetraService _obstetraService = ObstetraService();

//TO-DO Metodo para validar que exista codigo de obstetra
