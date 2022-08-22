import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gest_app/data/model/gestante.dart';
import 'package:gest_app/data/model/obstetra.dart';
import 'package:gest_app/service/obstetra_service.dart';

import 'package:intl/intl.dart' as intl;

Obstetra _obstetra = Obstetra();

class MonitorObs extends StatelessWidget {
  const MonitorObs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const ScreenObs();
  }
}

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
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.blue,
              ),
              child: FutureBuilder<Obstetra>(
                future: getObstetra(user.uid),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      children: <Widget>[
                        Text(snapshot.data!.nombre! + " " + snapshot.data!.apellido!),
                        Text("Código de obstetra: " + snapshot.data!.codigoObstetra!)
                      ],
                    );
                  } else {
                    //GET ERROR DRAWER
                    return const Text("ERROR DRAWER");
                  }
                },
              ),
            ),
            const ListTile(
              title: Text("Inicio"),
            ),
            const ListTile(
              title: Text("Mi perfil"),
            ),
            ListTile(
              title: const Text("Cerrar sesión"),
              onTap: () => {FirebaseAuth.instance.signOut()},
            )
          ],
        ),
      ),
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
                child: Padding(padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8), child: CircularProgressIndicator()),
              );
            case ConnectionState.done:
              if (snapshotObs.hasData) {
                return FutureBuilder<List<Gestante>>(
                  future: getListaGestantes(snapshotObs.data!.codigoObstetra!),
                  builder: (context, snapshotGests) {
                    switch (snapshotGests.connectionState) {
                      case ConnectionState.waiting:
                        return const Align(
                          alignment: Alignment.center,
                          child: Padding(padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8), child: CircularProgressIndicator()),
                        );
                      case ConnectionState.done:
                        if (snapshotGests.hasData) {
                          if (snapshotGests.data!.isNotEmpty) {
                            return ListView.builder(
                                itemCount: snapshotGests.data!.length,
                                itemBuilder: ((context, index) {
                                  VitalSign vitals = VitalSign.fromJson(snapshotGests.data![index].vitals!);
                                  Gestante gestante = snapshotGests.data![index];
                                  return Padding(
                                    padding: const EdgeInsets.only(left: 0, right: 0, top: 0),
                                    child: Container(
                                      decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
                                      child: Row(
                                        children: <Widget>[
                                          Expanded(
                                            flex: 2,
                                            child: Column(
                                              children: <Widget>[
                                                Align(
                                                  alignment: Alignment.center,
                                                  child: Container(
                                                    height: 45.0,
                                                    width: 45.0,
                                                    decoration: const BoxDecoration(
                                                      image: DecorationImage(
                                                        image: AssetImage('assets/mini_default_profile_icon.png'),
                                                        fit: BoxFit.fill,
                                                      ),
                                                      shape: BoxShape.rectangle,
                                                    ),
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
                                                  padding: const EdgeInsets.only(bottom: 5, top: 5),
                                                  child: Align(
                                                    alignment: Alignment.centerLeft,
                                                    child: Text(
                                                      "${gestante.nombre!} ${gestante.apellido}",
                                                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                                                    ),
                                                  ),
                                                ),
                                                Align(
                                                  alignment: Alignment.centerLeft,
                                                  child: Text(
                                                      "${DateTime.now().difference(intl.DateFormat("dd/MM/yyyy hh:mm:ss").parse(gestante.fechaRegla! + " 00:00:00")).inDays} días de embarazo"),
                                                ),
                                                Row(
                                                  children: [
                                                    vitals.actFisica == "true"
                                                        ? const VitalIconWidget(iconPath: 'assets/IconsVitals/act_fisica_icon.png')
                                                        : const Text(""),
                                                    vitals.freCardi == "true"
                                                        ? const VitalIconWidget(iconPath: 'assets/IconsVitals/fre_car_icon.png')
                                                        : const Text(""),
                                                    vitals.freResp == "true"
                                                        ? const VitalIconWidget(iconPath: 'assets/IconsVitals/fre_resp_icon.png')
                                                        : const Text(""),
                                                    vitals.gluco == "true"
                                                        ? const VitalIconWidget(iconPath: 'assets/IconsVitals/gluco_icon.png')
                                                        : const Text(""),
                                                    vitals.peso == "true"
                                                        ? const VitalIconWidget(iconPath: 'assets/IconsVitals/peso_icon.png')
                                                        : const Text(""),
                                                    vitals.presArt == "true"
                                                        ? const VitalIconWidget(iconPath: 'assets/IconsVitals/pres_art_icon.png')
                                                        : const Text(""),
                                                    vitals.satOxig == "true"
                                                        ? const VitalIconWidget(iconPath: 'assets/IconsVitals/sat_oxig_icon.png')
                                                        : const Text(""),
                                                    vitals.suenio == "true"
                                                        ? const VitalIconWidget(iconPath: 'assets/IconsVitals/suenio_icon.png')
                                                        : const Text(""),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }));
                          } else {
                            return const Align(
                              alignment: Alignment.center,
                              child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8), child: Text("No se encontraron gestantes registradas")),
                            );
                          }
                        } else {
                          return const Align(
                            alignment: Alignment.center,
                            child: Padding(padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8), child: Text("Algo salió mal")),
                          );
                        }
                      default:
                        return const Align(
                          alignment: Alignment.center,
                          child: Padding(padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8), child: Text("Esperando")),
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
