// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gest_app/data/model/gestante.dart';
import 'package:gest_app/layout/authentication/linkobs_gest.dart';
import 'package:gest_app/layout/gest/home/metric_detail.dart';
import 'package:gest_app/service/gestante_service.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
      body: RefreshIndicator(
        onRefresh: () {
          return Future(() {
            setState(() {});
          });
        },
        child: FutureBuilder<Gestante>(
            future: getGestante(uid),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case (ConnectionState.waiting):
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                case (ConnectionState.done):
                  if (!snapshot.hasData) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text("Si no completó el registro de su perfil\nseleccione la siguiente opción\n",
                              textAlign: TextAlign.center),
                          ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute<void>(builder: (BuildContext context) {
                                    return LinkObsGest();
                                  }),
                                );
                              },
                              child: Text("Continuar Registro")),
                          TextButton(
                            child: const Text("Reintentar"),
                            style: TextButton.styleFrom(textStyle: Theme.of(context).textTheme.labelLarge),
                            onPressed: () => setState(() {}),
                          ),
                        ],
                      ),
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
                        Container(
                            child: (actFisicaController.text == "true")
                                ? VitalCard(
                                    title: "Actividad Física",
                                    iconPath: "assets/IconsVitals/act_fisica_icon.png",
                                    vitalSign: "actFisica",
                                    unit: "Pasos",
                                    rtoken: snapshot.data!.rtoken!,
                                  )
                                : null),
                        Container(
                            child: (freCardiController.text == "true")
                                ? VitalCard(
                                    title: "Frecuencia Cardíaca",
                                    iconPath: "assets/IconsVitals/fre_car_icon.png",
                                    vitalSign: "freCardi",
                                    unit: "bpm",
                                    rtoken: snapshot.data!.rtoken!,
                                  )
                                : null),
                        Container(
                            child: (glucoController.text == "true")
                                ? VitalCard(
                                    title: "Glucosa",
                                    iconPath: "assets/IconsVitals/gluco_icon.png",
                                    vitalSign: "gluco",
                                    unit: "mmol/L",
                                    rtoken: snapshot.data!.rtoken!,
                                  )
                                : null),
                        Container(
                            child: (pesoController.text == "true")
                                ? VitalCard(
                                    title: "Peso",
                                    iconPath: "assets/IconsVitals/peso_icon.png",
                                    vitalSign: "peso",
                                    unit: "kg",
                                    rtoken: snapshot.data!.rtoken!,
                                  )
                                : null),
                        Container(
                            child: (presArtController.text == "true")
                                ? VitalCard(
                                    title: "Presión Arterial",
                                    iconPath: "assets/IconsVitals/pres_art_icon.png",
                                    vitalSign: "presArt",
                                    unit: "mmHg",
                                    rtoken: snapshot.data!.rtoken!,
                                  )
                                : null),
                        Container(
                            child: (satOxigController.text == "true")
                                ? VitalCard(
                                    title: "Saturación de Oxígeno",
                                    iconPath: "assets/IconsVitals/sat_oxig_icon.png",
                                    vitalSign: "satOxig",
                                    unit: "%",
                                    rtoken: snapshot.data!.rtoken!,
                                  )
                                : null),
                        Container(
                            child: (suenioController.text == "true")
                                ? VitalCard(
                                    title: "Sueño",
                                    iconPath: "assets/IconsVitals/suenio_icon.png",
                                    vitalSign: "suenio",
                                    unit: "h",
                                    rtoken: snapshot.data!.rtoken!,
                                  )
                                : null),
                      ],
                    ),
                  );
                default:
                  return const Text("Algo salió mal");
              }
            }),
      ),
    );
  }
}

class VitalCard extends StatefulWidget {
  VitalCard(
      {Key? key,
      required this.title,
      required this.iconPath,
      required this.vitalSign,
      required this.unit,
      required this.rtoken})
      : super(key: key);
  final String title;
  final String iconPath;
  final String vitalSign;
  final String unit;
  final String rtoken;

  @override
  State<VitalCard> createState() => _VitalCardState();
}

class _VitalCardState extends State<VitalCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 700,
      padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute<void>(builder: (BuildContext context) {
              return MetricDetailPage(
                vitalSign: widget.vitalSign,
                unit: widget.unit,
                rtoken: widget.rtoken,
              ); //! GuideId
            }),
          );
        },
        child: Card(
          child: Row(children: <Widget>[
            Expanded(
              flex: 2,
              child: Align(
                alignment: Alignment.center,
                child: Padding(
                    padding: const EdgeInsets.only(right: 4, top: 3, bottom: 6),
                    child: Container(
                      height: 35.0,
                      width: 35.0,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(widget.iconPath),
                          fit: BoxFit.fill,
                        ),
                        shape: BoxShape.rectangle,
                      ),
                    )),
              ),
            ),
            Expanded(
              flex: 8,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    Text(
                      widget.title,
                      textAlign: TextAlign.end,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                    ),
                    Text('Gráfico evolutivo',
                        textAlign: TextAlign.left, style: TextStyle(fontStyle: FontStyle.italic, fontSize: 18))
                  ],
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

Future<Gestante> getGestante(String id) {
  GestanteService _gestanteService = GestanteService();

  return _gestanteService.getGestante(id);
}
