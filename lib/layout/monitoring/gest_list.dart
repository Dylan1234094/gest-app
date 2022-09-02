import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gest_app/data/model/gestante.dart';
import 'package:gest_app/data/model/obstetra.dart';
import 'package:gest_app/service/obstetra_service.dart';
import 'package:gest_app/shared/chat.dart';

class GestanteList extends StatefulWidget {
  const GestanteList({Key? key}) : super(key: key);

  @override
  State<GestanteList> createState() => _GestanteListState();
}

class _GestanteListState extends State<GestanteList> {
  final user = FirebaseAuth.instance.currentUser!;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: const Text("Conversaciones")),
      body: FutureBuilder<Obstetra>(
        future: getObstetra(user.uid),
        builder: (context, snapshotObs) {
          if (!snapshotObs.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          return FutureBuilder<List<Gestante>>(
            future: getListaGestantes(snapshotObs.data!.codigoObstetra!),
            builder: (context, snapshotGests) {
              if (!snapshotGests.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshotGests.data!.isEmpty) {
                return const Center(
                    child: Text("No se encontraron gestantes registrados"));
              }

              return ListView.builder(
                  itemCount: snapshotGests.data!.length,
                  itemBuilder: ((context, index) {
                    Gestante gestante = snapshotGests.data![index];
                    return Card(
                      margin: const EdgeInsets.all(8),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: Center(
                              child: Container(
                                height: 45.0,
                                width: 45.0,
                                decoration: const BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(
                                        'assets/mini_default_profile_icon.png'),
                                    fit: BoxFit.fill,
                                  ),
                                  shape: BoxShape.rectangle,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 4,
                            child: Text(
                              "${gestante.nombre!} ${gestante.apellido}",
                              textAlign: TextAlign.left,
                              style: const TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Expanded(
                              child: IconButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute<void>(
                                    builder: (BuildContext context) {
                                  return Chat(
                                    anotherUserName: gestante.nombre,
                                    anotherUserUid:
                                        '8JeF7qmuhQgecJHSjjbNI5Ck1Q32',
                                  );
                                  // Gestante Deyvid        8JeF7qmuhQgecJHSjjbNI5Ck1Q32
                                  // Gestante testcursotdp  5bY1aMCjqXaFzpfWh2dLTm88Oe32
                                }),
                              );
                            },
                            icon: const Icon(Icons.message),
                          ))
                        ],
                      ),
                    );
                  }));
            },
          );
        },
      ),
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
