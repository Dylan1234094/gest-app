import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gest_app/service/gestante_service.dart';

import '../../../data/model/gestante.dart';
import '../../../utilities/designs.dart';

class UpdateVitalSigns extends StatefulWidget {
  const UpdateVitalSigns({Key? key}) : super(key: key);

  static String id = '/UpdatevitalSigns';

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
          title: const Text("Configuración", style: kTituloCabezera)),
      body: FutureBuilder<Gestante>(
          future: getGestante(uid),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case (ConnectionState.waiting):
                return SizedBox(
                  height: MediaQuery.of(context).size.height / 1.3,
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              case (ConnectionState.done):
                if (!snapshot.hasData) {
                  return const Center(
                    child: Text("Algo salió mal..."),
                  );
                }
                actFisicaController.text = snapshot.data!.vitals!["actFisica"];
                freCardiController.text = snapshot.data!.vitals!["freCardi"];
                presArtController.text = snapshot.data!.vitals!["presArt"];
                satOxigController.text = snapshot.data!.vitals!["satOxig"];
                pesoController.text = snapshot.data!.vitals!["peso"];
                glucoController.text = snapshot.data!.vitals!["gluco"];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        const Text(
                          'Actualice los datos que desee compartir con su obstetra asignada.',
                          style: kDescripcion,
                          textAlign: TextAlign.justify,
                        ),
                        VitalSignWidget(
                          vitalSignController: actFisicaController,
                          title: 'Actividad Física',
                          infoMonitoreo: 'Se monitorea el número de pasos de la aplicación Google Fit.',
                          switchState: actFisicaController.text == "true" ? true : false,
                          instrumento: '\u2022 Contador de Pasos',
                          infoMedicion:
                              'La actividad física ayuda a mejorar la condición física de las mujeres, se obtiene un peso más adecuado de la embarazada y se proporciona un mayor bienestar feta.',
                          imagen: 'assets/IconsVitals/act_fisica_icon.png',
                        ),
                        VitalSignWidget(
                          vitalSignController: freCardiController,
                          title: 'Frecuencia Cardíaca',
                          infoMonitoreo:
                              'Se monitorea la frecuencia cardíaca (bpm) registrada en la aplicación Google Fit.',
                          switchState: freCardiController.text == "true" ? true : false,
                          instrumento: '\u2022 Pulsómetro',
                          infoMedicion:
                              'El control de la frecuencia cardíaca fetal es un procedimiento que se utiliza para evaluar el bienestar del feto mediante la determinación de la frecuencia y el ritmo de los latidos del corazón del feto.',
                          imagen: 'assets/IconsVitals/fre_car_icon.png',
                        ),
                        // VitalSignWidget(
                        //   vitalSignController: suenioController,
                        //   title: 'Sueño',
                        //   infoMonitoreo:
                        //       'Se monitorea la duración del sueño (horas) registrada en la aplicación Google Fit.',
                        //   switchState:
                        //       suenioController.text == "true" ? true : false,
                        //   instrumento: '',
                        //   infoMedicion: '',
                        //   imagen: '',
                        // ),
                        VitalSignWidget(
                          vitalSignController: presArtController,
                          title: 'Presión Arterial',
                          infoMonitoreo:
                              'Se monitorea la presión arterial (mmHg) registrada en la aplicación Google Fit.',
                          switchState: presArtController.text == "true" ? true : false,
                          instrumento: '\u2022 Tensiómetro',
                          infoMedicion:
                              'La presión arterial ayuda a controlar a que el feto reciba suficiente oxígeno y nutrientes. La presión alta indica la falta de cantidad suficiente de sangre.',
                          imagen: 'assets/IconsVitals/pres_art_icon.png',
                        ),
                        VitalSignWidget(
                          vitalSignController: satOxigController,
                          title: 'Saturación de Oxígeno',
                          infoMonitoreo:
                              'Se monitorea la saturación de oxígeno (%) registrada en la aplicación Google Fit.',
                          switchState: satOxigController.text == "true" ? true : false,
                          instrumento: '\u2022 Pulsioxímetro',
                          infoMedicion:
                              'Se debe controlar el nivel de oxígeno en el cuerpo (%) para evitar problemas de desarrollo en el feto que puede afectar a sus órganos como su cerebro',
                          imagen: 'assets/IconsVitals/sat_oxig_icon.png',
                        ),
                        VitalSignWidget(
                          vitalSignController: pesoController,
                          title: 'Peso',
                          infoMonitoreo:
                              'Se monitorea el peso gestacional (kg) registrada en la aplicación Google Fit.',
                          switchState: pesoController.text == "true" ? true : false,
                          instrumento: '\u2022 Báscula',
                          infoMedicion:
                              'El monitoreo del peso (kg) durante la gestación sirve para identificar una ganancia excesiva de peso y retención de peso postparto.',
                          imagen: 'assets/IconsVitals/peso_icon.png',
                        ),
                        VitalSignWidget(
                          vitalSignController: glucoController,
                          title: 'Glucosa',
                          infoMonitoreo:
                              'Se monitorea el nivel de glucosa (g/dL) registrada en la aplicación Google Fit.',
                          switchState: glucoController.text == "true" ? true : false,
                          instrumento: '\u2022 Glucómetro',
                          infoMedicion:
                              'Los niveles altos de glucosa en la sangre pueden dar indicio a la diabetes gestacional y problemas en el desarollo feto como en el nacimiento del mismo.',
                          imagen: 'assets/IconsVitals/gluco_icon.png',
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Center(
                              child: ElevatedButton(
                                onPressed: () => {
                                  updateGestanteVitals(
                                          uid,
                                          actFisicaController.text,
                                          freCardiController.text,
                                          //suenioController.text,
                                          presArtController.text,
                                          satOxigController.text,
                                          pesoController.text,
                                          glucoController.text,
                                          context)
                                      .then((value) => updateVitalsSuccess(context))
                                      .onError((error, stackTrace) => updateVitalsFailed(context))
                                },
                                child: const Text('GUARDAR'),
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all<Color>(colorPrincipal),
                                  foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                  fixedSize: MaterialStateProperty.all(const Size(160.0, 46.0)),
                                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  ),
                                ),
                              ),
                            ),
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

class VitalSignWidget extends StatefulWidget {
  VitalSignWidget({
    Key? key,
    required this.vitalSignController,
    required this.title,
    required this.infoMonitoreo,
    this.switchState,
    required this.instrumento,
    required this.infoMedicion,
    required this.imagen,
  }) : super(key: key);

  final TextEditingController vitalSignController;
  final String title;
  final String infoMonitoreo;
  bool? switchState;
  final String instrumento;
  final String infoMedicion;
  final String imagen;

  @override
  State<VitalSignWidget> createState() => _VitalSignState();
}

class _VitalSignState extends State<VitalSignWidget> {
  bool _switch = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 4,
            child: Column(
              children: <Widget>[
                Row(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(widget.title, style: kTituloSignoConfig),
                    ),
                    SizedBox(
                      height: 30.0,
                      width: 30.0,
                      child: IconButton(
                        onPressed: () => infoSigno(context),
                        icon: const Icon(
                          Icons.info_outline_rounded,
                          color: colorSecundario,
                        ),
                        iconSize: 15.0,
                      ),
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    widget.infoMonitoreo,
                    style: kInfoSignoConfig,
                    textAlign: TextAlign.justify,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: Switch(
                activeColor: colorPrincipal,
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

  Future<void> infoSigno(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text(
            widget.title,
            style: kTituloSignoConfig,
            textAlign: TextAlign.center,
          ),
          children: [
            SimpleDialogOption(
              child: Text(
                widget.infoMedicion,
                textAlign: TextAlign.justify,
                style: kInfoSignoConfig,
              ),
            ),
            SimpleDialogOption(
              child: Image.asset(widget.imagen, height: 80.0, width: 80.0),
            ),
            SimpleDialogOption(
              padding: const EdgeInsets.only(left: 25, right: 25, top: 10),
              child: Text(
                'Instrumento de medición',
                style: kTituloSignoConfig.copyWith(fontSize: 10.0),
                textAlign: TextAlign.start,
              ),
            ),
            SimpleDialogOption(child: Text(widget.instrumento, style: kInfoSignoConfig))
          ],
        );
      },
    );
  }
}

Future<void> updateGestanteVitals(
    String uid,
    String actFisica,
    String freCardi,
    //String suenio,
    String presArt,
    String satOxig,
    String peso,
    String gluco,
    BuildContext context) {
  GestanteService _gestanteService = GestanteService();

  final vitals = VitalSign(
      actFisica: actFisica,
      freCardi: freCardi,
      //suenio: suenio,
      presArt: presArt,
      satOxig: satOxig,
      peso: peso,
      gluco: gluco);

  return _gestanteService.updateGestanteSigns(uid, vitals, context);
}

Future<Gestante> getGestante(String id) {
  GestanteService _gestanteService = GestanteService();

  return _gestanteService.getGestante(id);
}

Future<void> updateVitalsSuccess(BuildContext context) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        contentPadding: const EdgeInsets.only(right: 20, left: 20, top: 20, bottom: 10),
        actionsPadding: const EdgeInsets.only(bottom: 10),
        title: const Text(
          'Configuración Actualizada',
          style: TextStyle(fontSize: 13),
        ),
        content: RichText(
          text: TextSpan(
            text: 'La configuración de sus signos vitales se ha actualizado correctamente',
            style: DefaultTextStyle.of(context).style,
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text("ACEPTAR", style: TextStyle(fontSize: 10)),
            onPressed: () {
              Navigator.of(context).popUntil(ModalRoute.withName("/"));
            },
          )
        ],
      );
    },
  );
}

Future<void> updateVitalsFailed(BuildContext context) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        contentPadding: const EdgeInsets.only(right: 20, left: 20, top: 20, bottom: 10),
        actionsPadding: const EdgeInsets.only(bottom: 10),
        title: const Text(
          'Algo salió mal...',
          style: TextStyle(fontSize: 13),
        ),
        content: RichText(
          text: TextSpan(
            text: 'La configuración de sus signos vitales no fue actualizado. Por favor, inténtelo más tarde',
            style: DefaultTextStyle.of(context).style,
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text("ACEPTAR", style: TextStyle(fontSize: 10)),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ],
      );
    },
  );
}
