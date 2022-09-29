// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gest_app/data/model/gestante.dart';
import 'package:gest_app/layout/authentication/linkobs_gest.dart';
import 'package:gest_app/layout/gestante/home/metric_detail.dart';
import 'package:gest_app/service/gestante_service.dart';
import 'package:gest_app/utilities/designs.dart';

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
    final user = FirebaseAuth.instance.currentUser!;

    final hora = DateTime.now().hour;

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
                return SizedBox(
                  height: MediaQuery.of(context).size.height / 1.3,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              case (ConnectionState.done):
                if (!snapshot.hasData) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20.0, horizontal: 10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Por favor, continue con el ',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 18.0),
                              ),
                              TextSpan(
                                text: 'registro de su perfil.',
                                style: TextStyle(
                                  color: colorPrincipal,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute<void>(
                                          builder: (BuildContext context) {
                                        return LinkObsGest();
                                      }),
                                    );
                                  },
                              ),
                            ],
                          ),
                        ),
                        // TextButton(
                        //   child: const Text("Reintentar"),
                        //   style: TextButton.styleFrom(
                        //     textStyle: Theme.of(context).textTheme.labelLarge,
                        //   ),
                        //   onPressed: () => setState(() {}),
                        // ),
                      ],
                    ),
                  );
                }
                actFisicaController.text = snapshot.data!.vitals!["actFisica"];
                freCardiController.text = snapshot.data!.vitals!["freCardi"];
                presArtController.text = snapshot.data!.vitals!["presArt"];
                satOxigController.text = snapshot.data!.vitals!["satOxig"];
                pesoController.text = snapshot.data!.vitals!["peso"];
                glucoController.text = snapshot.data!.vitals!["gluco"];
                return Scaffold(
                  body: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20.0, horizontal: 10.0),
                    child: ListView(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  (hora < 12)
                                      ? 'Buenos días,'
                                      : ((hora > 12 && hora < 18)
                                          ? 'Buenas tardes,'
                                          : 'Buenas noches,'),
                                  style: TextStyle(
                                      color: colorSecundario, fontSize: 13.0),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 10.0),
                                  child: Text(
                                    user.displayName!,
                                    style: TextStyle(
                                      fontSize: 17.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        (actFisicaController.text == "true")
                            ? Container(
                                child: VitalCard(
                                userType: "gestante",
                                title: "Actividad Física",
                                iconPath:
                                    "assets/IconsVitals/act_fisica_icon.png",
                                vitalSign: "actFisica",
                                unit: "Pasos",
                                rtoken: snapshot.data!.rtoken!,
                              ))
                            : Container(),
                        (freCardiController.text == "true")
                            ? Container(
                                child: VitalCard(
                                userType: "gestante",
                                title: "Frecuencia Cardíaca",
                                iconPath: "assets/IconsVitals/fre_car_icon.png",
                                vitalSign: "freCardi",
                                unit: "bpm",
                                rtoken: snapshot.data!.rtoken!,
                              ))
                            : Container(),
                        (glucoController.text == "true")
                            ? Container(
                                child: VitalCard(
                                userType: "gestante",
                                title: "Glucosa",
                                iconPath: "assets/IconsVitals/gluco_icon.png",
                                vitalSign: "gluco",
                                unit: "mmol/L",
                                rtoken: snapshot.data!.rtoken!,
                              ))
                            : Container(),
                        (pesoController.text == "true")
                            ? Container(
                                child: VitalCard(
                                userType: "gestante",
                                title: "Peso",
                                iconPath: "assets/IconsVitals/peso_icon.png",
                                vitalSign: "peso",
                                unit: "kg",
                                rtoken: snapshot.data!.rtoken!,
                              ))
                            : Container(),
                        (presArtController.text == "true")
                            ? Container(
                                child: VitalCard(
                                userType: "gestante",
                                title: "Presión Arterial",
                                iconPath:
                                    "assets/IconsVitals/pres_art_icon.png",
                                vitalSign: "presArt",
                                unit: "mmHg",
                                rtoken: snapshot.data!.rtoken!,
                              ))
                            : Container(),
                        (satOxigController.text == "true")
                            ? Container(
                                child: VitalCard(
                                userType: "gestante",
                                title: "Saturación de Oxígeno",
                                iconPath:
                                    "assets/IconsVitals/sat_oxig_icon.png",
                                vitalSign: "satOxig",
                                unit: "%",
                                rtoken: snapshot.data!.rtoken!,
                              ))
                            : Container(),
                        (suenioController.text == "true")
                            ? Container(
                                child: VitalCard(
                                userType: "gestante",
                                title: "Sueño",
                                iconPath: "assets/IconsVitals/suenio_icon.png",
                                vitalSign: "suenio",
                                unit: "h",
                                rtoken: snapshot.data!.rtoken!,
                              ))
                            : Container(),
                      ],
                    ),
                  ),
                );
              default:
                return Center(
                  child: Text("No se encontraron metas registradas"),
                );
            }
          },
        ),
      ),
    );
  }
}

// class VitalCard extends StatefulWidget {
//   VitalCard(
//       {required this.userType,
//       required this.title,
//       required this.iconPath,
//       required this.vitalSign,
//       required this.unit,
//       required this.rtoken});

//   final String userType;
//   final String title;
//   final String iconPath;
//   final String vitalSign;
//   final String unit;
//   final String rtoken;

//   @override
//   State<VitalCard> createState() => _VitalCardState();
// }

// class _VitalCardState extends State<VitalCard> {
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.all(5.0),
//       child: InkWell(
//         child: Container(
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(15.0),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.grey,
//                 blurRadius: 6.0,
//               )
//             ],
//             color: Colors.white,
//           ),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Container(
//                 height: 70.0,
//                 width: 70.0,
//                 decoration: BoxDecoration(
//                   image: DecorationImage(
//                     image: AssetImage(widget.iconPath),
//                     fit: BoxFit.contain,
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(10.0),
//                 child: Text(
//                   widget.title,
//                   style: kTituloGrafico,
//                   textAlign: TextAlign.center,
//                 ),
//               )
//             ],
//           ),
//         ),
//         onTap: () {
//           Navigator.of(context).push(
//             MaterialPageRoute<void>(builder: (BuildContext context) {
//               return MetricDetailPage(
//                 userType: widget.userType,
//                 vitalSignName: widget.title,
//                 vitalSign: widget.vitalSign,
//                 unit: widget.unit,
//                 rtoken: widget.rtoken,
//               ); //! GuideId
//             }),
//           );
//         },
//       ),
//     );
//   }
// }

Future<Gestante> getGestante(String id) {
  GestanteService _gestanteService = GestanteService();

  return _gestanteService.getGestante(id);
}

class VitalCard extends StatefulWidget {
  VitalCard({
    required this.userType,
    required this.title,
    required this.iconPath,
    required this.vitalSign,
    required this.unit,
    required this.rtoken,
  });

  final String userType;
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
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute<void>(builder: (BuildContext context) {
              return MetricDetailPage(
                userType: widget.userType,
                vitalSignName: widget.title,
                vitalSign: widget.vitalSign,
                unit: widget.unit,
                rtoken: widget.rtoken,
              ); //! GuideId
            }),
          );
        },
        child: Card(
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Center(
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
                  ),
                ),
              ),
              Expanded(
                flex: 8,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(widget.title, style: kTitulo3),
                      Text('Ver evolución',
                          style: kSubTitulo1.copyWith(color: colorSecundario))
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
