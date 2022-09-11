import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gest_app/service/gestante_service.dart';

import '../../../data/model/gestante.dart';

class GestConfig extends StatefulWidget {
  const GestConfig({Key? key}) : super(key: key);

  @override
  State<GestConfig> createState() => _GestConfigState();
}

class _GestConfigState extends State<GestConfig> {
  var uid = FirebaseAuth.instance.currentUser!.uid;

  void ConfirmDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: const Text('Confirmación'),
          content: const Text(
            '¿Desea desvincular su cuenta de la obstetra actual? La obstetra actualmente asociada dejará de recibir sus datos',
            textAlign: TextAlign.justify,
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('No')),
            TextButton(
                onPressed: () {
                  desvincularObstetra(uid, context);
                },
                child: const Text('Si'))
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text("")),
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
                return SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      const Padding(
                        padding: EdgeInsets.only(top: 10, left: 8, right: 8, bottom: 3),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Código de Obstetra Vinculada',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      snapshot.data!.codigoObstetra! != ""
                          ? Text("Obstetra con código: ${snapshot.data!.codigoObstetra!}")
                          : const Padding(
                              padding: EdgeInsets.only(left: 8, right: 8),
                              child: Text(
                                'No presenta una obstetra vinculada a su cuenta\n',
                                textAlign: TextAlign.left,
                              ),
                            ),
                      snapshot.data!.codigoObstetra! != ""
                          ? Align(
                              alignment: Alignment.centerRight,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                child: ElevatedButton(
                                  onPressed: () => {ConfirmDialog(context)},
                                  child: const Text('DESVINCULAR'),
                                ),
                              ),
                            )
                          : Align(
                              alignment: Alignment.centerRight,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                child: ElevatedButton(
                                  onPressed: () => {Navigator.pushNamed(context, '/UpdatelinkObstetra')},
                                  child: const Text('VINCULAR'),
                                ),
                              ),
                            ),
                      const Padding(
                        padding: EdgeInsets.only(top: 10, left: 8, right: 8, bottom: 3),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Constantes Vitales',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      snapshot.data!.vitals!["actFisica"] == "true" ? Text("Actividad Física") : Container(),
                      snapshot.data!.vitals!["freCardi"] == "true" ? Text("Frecuencia Cardíaca") : Container(),
                      snapshot.data!.vitals!["suenio"] == "true" ? Text("Sueño") : Container(),
                      snapshot.data!.vitals!["presArt"] == "true" ? Text("Presión Arterial") : Container(),
                      snapshot.data!.vitals!["freResp"] == "true" ? Text("Frecuencia Respiratoria") : Container(),
                      snapshot.data!.vitals!["satOxig"] == "true" ? Text("Saturación de oxígeno") : Container(),
                      snapshot.data!.vitals!["peso"] == "true" ? Text("Peso") : Container(),
                      snapshot.data!.vitals!["gluco"] == "true" ? Text("Glucosa") : Container(),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                          child: ElevatedButton(
                            onPressed: () => {Navigator.pushNamed(context, '/UpdatevitalSigns')},
                            child: const Text('EDITAR'),
                          ),
                        ),
                      ),
                    ],
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

void desvincularObstetra(String id, BuildContext context) {
  GestanteService _gestanteService = GestanteService();

  return _gestanteService.desvincularObstetra(id, context);
}
