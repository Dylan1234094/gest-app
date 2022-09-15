import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gest_app/service/gestante_service.dart';

import '../../../data/model/gestante.dart';

class UpdateVitalSigns extends StatefulWidget {
  const UpdateVitalSigns({Key? key}) : super(key: key);

  @override
  State<UpdateVitalSigns> createState() => _UpdateVitalSignsState();
}

class _UpdateVitalSignsState extends State<UpdateVitalSigns> {
  final actFisicaController = TextEditingController();
  final freCardiController = TextEditingController();
  final suenioController = TextEditingController();
  final presArtController = TextEditingController();
  final satOxigController = TextEditingController();
  final pesoController = TextEditingController();
  final glucoController = TextEditingController();

  @override
  void dispose() {
    actFisicaController.dispose();
    freCardiController.dispose();
    suenioController.dispose();
    presArtController.dispose();
    satOxigController.dispose();
    pesoController.dispose();
    glucoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var uid = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text("Constantes Vitales")),
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
                actFisicaController.text = snapshot.data!.vitals!["actFisica"];
                freCardiController.text = snapshot.data!.vitals!["freCardi"];
                suenioController.text = snapshot.data!.vitals!["suenio"];
                presArtController.text = snapshot.data!.vitals!["presArt"];
                satOxigController.text = snapshot.data!.vitals!["satOxig"];
                pesoController.text = snapshot.data!.vitals!["peso"];
                glucoController.text = snapshot.data!.vitals!["gluco"];
                return SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
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
                      const Padding(
                        padding: EdgeInsets.only(left: 8, right: 8),
                        child: Text(
                          'Los datos serán recopilados a través de la aplicación Google Fit. ',
                        ),
                      ),
                      VitalSignWidget(
                        vitalSignController: actFisicaController,
                        title: 'Actividad Física',
                        content: 'Se monitorea el número de pasos de la aplicación Google Fit.',
                        switchState: actFisicaController.text == "true" ? true : false,
                      ),
                      VitalSignWidget(
                        vitalSignController: freCardiController,
                        title: 'Frecuencia Cardíaca',
                        content: 'Se monitorea la frecuencia cardíaca (bpm) registrada en la aplicación Google Fit.',
                        switchState: freCardiController.text == "true" ? true : false,
                      ),
                      VitalSignWidget(
                        vitalSignController: suenioController,
                        title: 'Sueño',
                        content: 'Se monitorea la duración del sueño (horas) registrada en la aplicación Google Fit.',
                        switchState: suenioController.text == "true" ? true : false,
                      ),
                      VitalSignWidget(
                        vitalSignController: presArtController,
                        title: 'Presión Arterial',
                        content: 'Se monitorea la presión arterial (mmHg) registrada en la aplicación Google Fit.',
                        switchState: presArtController.text == "true" ? true : false,
                      ),
                      VitalSignWidget(
                        vitalSignController: satOxigController,
                        title: 'Saturación de Oxígeno',
                        content: 'Se monitorea la saturación de oxígeno (%) registrada en la aplicación Google Fit.',
                        switchState: satOxigController.text == "true" ? true : false,
                      ),
                      VitalSignWidget(
                        vitalSignController: pesoController,
                        title: 'Peso',
                        content: 'Se monitorea el peso gestacional (kg) registrada en la aplicación Google Fit.',
                        switchState: pesoController.text == "true" ? true : false,
                      ),
                      VitalSignWidget(
                        vitalSignController: glucoController,
                        title: 'Glucosa',
                        content: 'Se monitorea el nivel de glucosa (g/dL) registrada en la aplicación Google Fit.',
                        switchState: glucoController.text == "true" ? true : false,
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                          child: ElevatedButton(
                            onPressed: () => {
                              updateGestanteVitals(
                                  uid,
                                  actFisicaController.text,
                                  freCardiController.text,
                                  suenioController.text,
                                  presArtController.text,
                                  satOxigController.text,
                                  pesoController.text,
                                  glucoController.text,
                                  context)
                            },
                            child: const Text('GUARDAR'),
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

class VitalSignWidget extends StatefulWidget {
  VitalSignWidget(
      {Key? key, required this.vitalSignController, required this.title, required this.content, this.switchState})
      : super(key: key);
  final TextEditingController vitalSignController;
  final String title;
  final String content;
  bool? switchState;

  @override
  State<VitalSignWidget> createState() => _VitalSignState();
}

class _VitalSignState extends State<VitalSignWidget> {
  bool _switch = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8, top: 14),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 8,
            child: Column(
              children: <Widget>[
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    widget.title,
                    style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    widget.content,
                    style: const TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.centerRight,
              child: Switch(
                value: widget.switchState != null ? widget.switchState! : _switch,
                onChanged: (value) {
                  setState(() {
                    widget.switchState = value;
                    _switch = value;
                    widget.vitalSignController.text = value.toString();
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void updateGestanteVitals(String uid, String actFisica, String freCardi, String suenio, String presArt, String satOxig,
    String peso, String gluco, BuildContext context) {
  GestanteService _gestanteService = GestanteService();

  final vitals = VitalSign(
      actFisica: actFisica,
      freCardi: freCardi,
      suenio: suenio,
      presArt: presArt,
      satOxig: satOxig,
      peso: peso,
      gluco: gluco);

  _gestanteService.updateGestanteSigns(uid, vitals, context);
}

Future<Gestante> getGestante(String id) {
  GestanteService _gestanteService = GestanteService();

  return _gestanteService.getGestante(id);
}

void desvincularObstetra(String id, BuildContext context) {
  GestanteService _gestanteService = GestanteService();

  return _gestanteService.desvincularObstetra(id, context);
}
