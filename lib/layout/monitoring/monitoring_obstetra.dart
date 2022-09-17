import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gest_app/chats/pages/home_page.dart';
import 'package:gest_app/data/model/gestante.dart';
import 'package:gest_app/data/model/obstetra.dart';
import 'package:gest_app/layout/monitoring/tabs_monitor.dart';
import 'package:gest_app/service/obstetra_service.dart';
import 'package:gest_app/shared/drawer_obs.dart';

import 'package:intl/intl.dart' as intl;

class ScreenObs extends StatefulWidget {
  const ScreenObs({Key? key}) : super(key: key);

  @override
  State<ScreenObs> createState() => _MonitorObsState();
}

class _MonitorObsState extends State<ScreenObs> {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute<void>(builder: (BuildContext context) {
            return GestListChat();
          }));
        },
        backgroundColor: Color(0xFF245470),
        child: Icon(Icons.sms_outlined),
      ),
      drawer: const DrawerObs(),
      appBar: AppBar(
        title: const Text(""),
      ),
      body: FutureBuilder<Obstetra>(
        future: getObstetra(user.uid),
        builder: (context, snapshotObs) {
          switch (snapshotObs.connectionState) {
            case ConnectionState.waiting:
              return const Align(
                alignment: Alignment.center,
                child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    child: CircularProgressIndicator()),
              );
            case ConnectionState.done:
              if (snapshotObs.hasData) {
                return FutureBuilder<List<Gestante>>(
                  future: getListaGestantes(snapshotObs.data!.id!),
                  builder: (context, snapshotGests) {
                    switch (snapshotGests.connectionState) {
                      case ConnectionState.waiting:
                        return const Align(
                          alignment: Alignment.center,
                          child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 8),
                              child: CircularProgressIndicator()),
                        );
                      case ConnectionState.done:
                        if (snapshotGests.hasData) {
                          if (snapshotGests.data!.isNotEmpty) {
                            return ListView.builder(
                              itemCount: snapshotGests.data!.length,
                              itemBuilder: ((context, index) {
                                VitalSign vitals = VitalSign.fromJson(
                                    snapshotGests.data![index].vitals!);
                                Gestante gestante = snapshotGests.data![index];
                                return Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8, right: 8, top: 5),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute<void>(
                                            builder: (BuildContext context) {
                                          return TabsMonitor(
                                              gestId: gestante.id!); //! id
                                        }),
                                      );
                                    },
                                    child: Card(
                                      child: Row(
                                        children: <Widget>[
                                          Expanded(
                                            flex: 2,
                                            child: Column(
                                              children: <Widget>[
                                                Align(
                                                  alignment: Alignment.center,
                                                  child: CircleAvatar(
                                                    radius: 22,
                                                    backgroundImage: gestante
                                                                .photoUrl! !=
                                                            ""
                                                        ? NetworkImage(
                                                            gestante.photoUrl!)
                                                        : Image.asset(
                                                                "assets/mini_default_profile_icon.png")
                                                            .image,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            flex: 8,
                                            child: Column(
                                              children: <Widget>[
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 5, top: 5),
                                                  child: Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                      "${gestante.nombre!} ${gestante.apellido}",
                                                      style: const TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                ),
                                                Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                      "${DateTime.now().difference(intl.DateFormat("dd/MM/yyyy hh:mm:ss").parse(gestante.fechaRegla! + " 00:00:00")).inDays} días de embarazo"),
                                                ),
                                                Row(
                                                  children: [
                                                    vitals.actFisica == "true"
                                                        ? const VitalIconWidget(
                                                            iconPath:
                                                                'assets/IconsVitals/act_fisica_icon.png')
                                                        : const Text(""),
                                                    vitals.freCardi == "true"
                                                        ? const VitalIconWidget(
                                                            iconPath:
                                                                'assets/IconsVitals/fre_car_icon.png')
                                                        : const Text(""),
                                                    vitals.freResp == "true"
                                                        ? const VitalIconWidget(
                                                            iconPath:
                                                                'assets/IconsVitals/fre_resp_icon.png')
                                                        : const Text(""),
                                                    vitals.gluco == "true"
                                                        ? const VitalIconWidget(
                                                            iconPath:
                                                                'assets/IconsVitals/gluco_icon.png')
                                                        : const Text(""),
                                                    vitals.peso == "true"
                                                        ? const VitalIconWidget(
                                                            iconPath:
                                                                'assets/IconsVitals/peso_icon.png')
                                                        : const Text(""),
                                                    vitals.presArt == "true"
                                                        ? const VitalIconWidget(
                                                            iconPath:
                                                                'assets/IconsVitals/pres_art_icon.png')
                                                        : const Text(""),
                                                    vitals.satOxig == "true"
                                                        ? const VitalIconWidget(
                                                            iconPath:
                                                                'assets/IconsVitals/sat_oxig_icon.png')
                                                        : const Text(""),
                                                    vitals.suenio == "true"
                                                        ? const VitalIconWidget(
                                                            iconPath:
                                                                'assets/IconsVitals/suenio_icon.png')
                                                        : const Text(""),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            );
                          } else {
                            return const Align(
                              alignment: Alignment.center,
                              child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 8),
                                  child: Text(
                                      "No se encontraron gestantes registradas")),
                            );
                          }
                        } else {
                          return const Align(
                            alignment: Alignment.center,
                            child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 8),
                                child: Text("Algo salió mal")),
                          );
                        }
                      default:
                        return const Align(
                          alignment: Alignment.center,
                          child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 8),
                              child: Text("Esperando")),
                        );
                    }
                  },
                );
              } else {
                //GET ERROR BODY
                return const Text("ERROR BODY");
              }
            default:
              return Text("data");
          }
        },
      ),
    );
  }
}

class VitalIconWidget extends StatelessWidget {
  const VitalIconWidget({Key? key, required this.iconPath}) : super(key: key);
  final String iconPath;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Padding(
          padding: const EdgeInsets.only(right: 4, top: 3, bottom: 6),
          child: Container(
            height: 15.0,
            width: 15.0,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(iconPath),
                fit: BoxFit.fill,
              ),
              shape: BoxShape.rectangle,
            ),
          )),
    );
  }
}

ObstetraService _obstetraService = ObstetraService();

Future<Obstetra> getObstetra(String id) {
  return _obstetraService.getObstetra(id);
}

Future<List<Gestante>> getListaGestantes(String codigoObstetra) {
  return _obstetraService.getListaGestantes(codigoObstetra);
}
