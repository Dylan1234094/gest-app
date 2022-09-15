import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gest_app/layout/authentication/register_gest.dart';
import 'package:gest_app/service/gestante_service.dart';

import '../../data/model/gestante.dart';

class VitalSignsGest extends StatelessWidget {
  const VitalSignsGest({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const FormVitalGest();
  }
}

class FormVitalGest extends StatefulWidget {
  const FormVitalGest({Key? key}) : super(key: key);

  @override
  State<FormVitalGest> createState() => _FormVitalGestState();
}

class _FormVitalGestState extends State<FormVitalGest> {
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
    final user = FirebaseAuth.instance.currentUser!;
    final args = ModalRoute.of(context)!.settings.arguments as registerGestArguments;
    actFisicaController.text = "true";
    freCardiController.text = "true";
    suenioController.text = "true";
    presArtController.text = "true";
    satOxigController.text = "true";
    pesoController.text = "true";
    glucoController.text = "true";

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
                  'Constantes Vitales',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 8, right: 8),
              child: Text(
                'Para finalizar el registro seleccione los signos vitales que desea compartir con su obstetra asignada, podrá modificar los signos vitales elegidos en la pantalla de configuración\n\nLos datos serán recopilados a través de la aplicación Google Fit. ',
              ),
            ),
            VitalSignWidget(
              vitalSignController: actFisicaController,
              title: 'Actividad Física',
              content: 'Se monitorea el número de pasos de la aplicación Google Fit.',
            ),
            VitalSignWidget(
              vitalSignController: freCardiController,
              title: 'Frecuencia Cardíaca',
              content: 'Se monitorea la frecuencia cardíaca (bpm) registrada en la aplicación Google Fit.',
            ),
            VitalSignWidget(
              vitalSignController: suenioController,
              title: 'Sueño',
              content: 'Se monitorea la duración del sueño (horas) registrada en la aplicación Google Fit.',
            ),
            VitalSignWidget(
              vitalSignController: presArtController,
              title: 'Presión Arterial',
              content: 'Se monitorea la presión arterial (mmHg) registrada en la aplicación Google Fit.',
            ),
            VitalSignWidget(
              vitalSignController: satOxigController,
              title: 'Saturación de Oxígeno',
              content: 'Se monitorea la saturación de oxígeno (%) registrada en la aplicación Google Fit.',
            ),
            VitalSignWidget(
              vitalSignController: pesoController,
              title: 'Peso',
              content: 'Se monitorea el peso gestacional (kg) registrada en la aplicación Google Fit.',
            ),
            VitalSignWidget(
              vitalSignController: glucoController,
              title: 'Glucosa',
              content: 'Se monitorea el nivel de glucosa (g/dL) registrada en la aplicación Google Fit.',
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: ElevatedButton(
                  onPressed: () => {
                    insertDataGestante(
                        user.uid,
                        args.nombre,
                        args.apellido,
                        args.correo,
                        args.telefono,
                        args.dni,
                        args.fechaNacimiento,
                        args.fechaRegla,
                        args.fechaEco,
                        args.fechaCita,
                        args.codigoObs,
                        actFisicaController.text,
                        freCardiController.text,
                        suenioController.text,
                        presArtController.text,
                        satOxigController.text,
                        pesoController.text,
                        glucoController.text,
                        context)
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

class VitalSignWidget extends StatefulWidget {
  const VitalSignWidget({Key? key, required this.vitalSignController, required this.title, required this.content})
      : super(key: key);
  final TextEditingController vitalSignController;
  final String title;
  final String content;

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
                value: _switch,
                onChanged: (value) {
                  setState(() {
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

void insertDataGestante(
    String id,
    String nombre,
    String apellido,
    String correo,
    String telefono,
    String dni,
    String fechaNacimiento,
    String fechaRegla,
    String fechaEco,
    String fechaCita,
    String codeObs,
    String actFisica,
    String freCardi,
    String suenio,
    String presArt,
    String satOxig,
    String peso,
    String gluco,
    BuildContext context) {
  GestanteService _gestanteService = GestanteService();

  final vitals = VitalSign(
      actFisica: actFisica,
      freCardi: freCardi,
      suenio: suenio,
      presArt: presArt,
      satOxig: satOxig,
      peso: peso,
      gluco: gluco);

  _gestanteService.createGestante(id, nombre, apellido, correo, telefono, dni, fechaNacimiento, fechaRegla, fechaEco,
      fechaCita, codeObs, vitals, context);
}
