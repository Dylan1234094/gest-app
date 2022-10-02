import 'package:flutter/material.dart';
import 'package:gest_app/data/model/gestante.dart';
import 'package:gest_app/layout/gestante/home/metric_detail.dart';
import 'package:gest_app/service/gestante_service.dart';
import 'package:intl/intl.dart' as intl;

import '../../utilities/designs.dart';

class PerfilGest extends StatefulWidget {
  final String gestId;
  const PerfilGest({Key? key, required this.gestId}) : super(key: key);

  @override
  State<PerfilGest> createState() => _DetailMonitorGestState();
}

class _DetailMonitorGestState extends State<PerfilGest> {
  late TabController tabController;
  final actFisicaController = TextEditingController();
  final freCardiController = TextEditingController();
  // final suenioController = TextEditingController();
  final presArtController = TextEditingController();
  final satOxigController = TextEditingController();
  final pesoController = TextEditingController();
  final glucoController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    actFisicaController.dispose();
    freCardiController.dispose();
    // suenioController.dispose();
    presArtController.dispose();
    satOxigController.dispose();
    pesoController.dispose();
    glucoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () {
          return Future(() {
            setState(() {});
          });
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: FutureBuilder<Gestante>(
            future: getGestante(widget.gestId),
            builder: (context, snapshotGest) {
              switch (snapshotGest.connectionState) {
                case ConnectionState.waiting:
                  return const Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                      child: CircularProgressIndicator(),
                    ),
                  );
                case ConnectionState.done:
                  actFisicaController.text = snapshotGest.data!.vitals!["actFisica"];
                  freCardiController.text = snapshotGest.data!.vitals!["freCardi"];
                  presArtController.text = snapshotGest.data!.vitals!["presArt"];
                  satOxigController.text = snapshotGest.data!.vitals!["satOxig"];
                  pesoController.text = snapshotGest.data!.vitals!["peso"];
                  glucoController.text = snapshotGest.data!.vitals!["gluco"];
                  if (snapshotGest.hasData) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.only(bottom: 20.0),
                            alignment: Alignment.center,
                            child: CircleAvatar(
                              radius: MediaQuery.of(context).size.height / 11,
                              backgroundImage: snapshotGest.data!.photoUrl! != ""
                                  ? NetworkImage(snapshotGest.data!.photoUrl!)
                                  : Image.asset("assets/default_profile_icon.png").image,
                              backgroundColor: Colors.lightBlue[900],
                            ),
                          ),
                          PerfilData(
                            titleData: 'NOMBRE COMPLETO',
                            data: '${snapshotGest.data!.nombre!} ${snapshotGest.data!.apellido!}',
                          ),
                          PerfilData(
                            titleData: 'FECHA DE NACIMIENTO',
                            data: snapshotGest.data!.fechaNacimiento!,
                          ),
                          PerfilData(
                            titleData: 'EDAD GESTACIONAL',
                            data:
                                "${(DateTime.now().difference(intl.DateFormat("dd/MM/yyyy hh:mm:ss").parse(snapshotGest.data!.fechaRegla! + " 00:00:00")).inDays / 4).round()} semanas de embarazo",
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 10.0),
                            child: Text(
                              'GRÁFICOS EVOLUTIVOS',
                              textAlign: TextAlign.center,
                              style: kTitulo1,
                            ),
                          ),
                          Container(
                              child: (actFisicaController.text == "true")
                                  ? VitalCardObs(
                                      userType: "obs",
                                      title: "Actividad Física",
                                      iconPath: "assets/IconsVitals/act_fisica_icon.png",
                                      vitalSign: "actFisica",
                                      unit: "Pasos",
                                      rtoken: snapshotGest.data!.rtoken!,
                                    )
                                  : null),
                          Container(
                              child: (freCardiController.text == "true")
                                  ? VitalCardObs(
                                      userType: "obs",
                                      title: "Frecuencia Cardíaca",
                                      iconPath: "assets/IconsVitals/fre_car_icon.png",
                                      vitalSign: "freCardi",
                                      unit: "bpm",
                                      rtoken: snapshotGest.data!.rtoken!,
                                    )
                                  : null),
                          Container(
                              child: (glucoController.text == "true")
                                  ? VitalCardObs(
                                      userType: "obs",
                                      title: "Glucosa",
                                      iconPath: "assets/IconsVitals/gluco_icon.png",
                                      vitalSign: "gluco",
                                      unit: "mmol/L",
                                      rtoken: snapshotGest.data!.rtoken!,
                                    )
                                  : null),
                          Container(
                              child: (pesoController.text == "true")
                                  ? VitalCardObs(
                                      userType: "obs",
                                      title: "Peso",
                                      iconPath: "assets/IconsVitals/peso_icon.png",
                                      vitalSign: "peso",
                                      unit: "kg",
                                      rtoken: snapshotGest.data!.rtoken!,
                                    )
                                  : null),
                          Container(
                              child: (presArtController.text == "true")
                                  ? VitalCardObs(
                                      userType: "obs",
                                      title: "Presión Arterial",
                                      iconPath: "assets/IconsVitals/pres_art_icon.png",
                                      vitalSign: "presArt",
                                      unit: "mmHg",
                                      rtoken: snapshotGest.data!.rtoken!,
                                    )
                                  : null),
                          Container(
                              child: (satOxigController.text == "true")
                                  ? VitalCardObs(
                                      userType: "obs",
                                      title: "Saturación de Oxígeno",
                                      iconPath: "assets/IconsVitals/sat_oxig_icon.png",
                                      vitalSign: "satOxig",
                                      unit: "%",
                                      rtoken: snapshotGest.data!.rtoken!,
                                    )
                                  : null),
                          // Container(
                          //     child: (suenioController.text == "true")
                          //         ? VitalCardObs(
                          //             userType: "obs",
                          //             title: "Sueño",
                          //             iconPath: "assets/IconsVitals/suenio_icon.png",
                          //             vitalSign: "suenio",
                          //             unit: "h",
                          //             rtoken: snapshotGest.data!.rtoken!,
                          //           )
                          //         : null),
                        ],
                      ),
                    );
                  } else {
                    //GET ERROR BODY
                    return const Text("ERROR BODY");
                  }
                default:
                  return const Text("data");
              }
            },
          ),
        ),
      ),
    );
  }
}

class PerfilData extends StatelessWidget {
  const PerfilData({
    Key? key,
    required this.data,
    required this.titleData,
  }) : super(key: key);

  final String titleData;
  final String data;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(titleData, style: kTituloPerfilGestante),
        const SizedBox(height: 2.0),
        Text(data, textAlign: TextAlign.left, style: kTitulo2),
        kLineaDivisora,
      ],
    );
  }
}

Future<Gestante> getGestante(String id) {
  GestanteService _gestanteService = GestanteService();

  return _gestanteService.getGestante(id);
}

class VitalCardObs extends StatefulWidget {
  const VitalCardObs({
    Key? key,
    required this.userType,
    required this.title,
    required this.iconPath,
    required this.vitalSign,
    required this.unit,
    required this.rtoken,
  }) : super(key: key);

  final String userType;
  final String title;
  final String iconPath;
  final String vitalSign;
  final String unit;
  final String rtoken;
  @override
  State<VitalCardObs> createState() => _VitalCardObsState();
}

class _VitalCardObsState extends State<VitalCardObs> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
        child: Row(children: <Widget>[
          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.center,
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
          ),
          Expanded(
            flex: 8,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(widget.title, textAlign: TextAlign.end, style: kTitulo3),
                  Text('Ver evolución', style: kSubTitulo1.copyWith(color: colorSecundario))
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
