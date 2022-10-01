import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gest_app/data/model/gestante.dart';
import 'package:gest_app/data/model/obstetra.dart';
import 'package:gest_app/service/obstetra_service.dart';

import '../../shared/chat.dart';
import '../../utilities/designs.dart';

class GestanteList extends StatefulWidget {
  const GestanteList({Key? key}) : super(key: key);

  @override
  State<GestanteList> createState() => _GestanteListState();
}

class _GestanteListState extends State<GestanteList> {
  final user = FirebaseAuth.instance.currentUser!;
  String _textSearch = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () {
          return Future(() {
            setState(() {});
          });
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: TextFormField(
                  style: const TextStyle(fontSize: 13.0),
                  onChanged: (value) {
                    setState(
                      () {
                        _textSearch = value;
                      },
                    );
                  },
                  decoration: const InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.search),
                    hintText: 'Buscar paciente',
                    labelStyle: kSubTitulo1,
                  ),
                ),
              ),
              Flexible(
                child: FutureBuilder<Obstetra>(
                  future: getObstetra(user.uid),
                  builder: (context, snapshotObs) {
                    if (!snapshotObs.hasData) {
                      return SizedBox(
                        height: MediaQuery.of(context).size.height / 1.3,
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                    return FutureBuilder<List<Gestante>>(
                      future:
                          getListaGestantes(snapshotObs.data!.codigoObstetra!),
                      builder: (context, snapshotGests) {
                        if (!snapshotGests.hasData) {
                          return SizedBox(
                            height: MediaQuery.of(context).size.height / 1.3,
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }
                        if (snapshotGests.data!.isEmpty) {
                          return const Center(
                            child:
                                Text("No se encontraron gestantes registrados"),
                          );
                        }
                        return ListView.builder(
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemCount: snapshotGests.data!.length,
                          itemBuilder: ((context, index) {
                            Gestante gestante = snapshotGests.data![index];
                            String nombrecompleto =
                                gestante.nombre! + gestante.apellido!;
                            if (nombrecompleto
                                .toLowerCase()
                                .contains(_textSearch.toLowerCase())) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute<void>(
                                        builder: (BuildContext context) {
                                      return Chat(
                                        nombreSender: snapshotObs.data!.nombre!,
                                        apellidoSender:
                                            snapshotObs.data!.apellido!,
                                        anotherUserName: gestante.nombre!,
                                        anotherUserSurname: gestante.apellido!,
                                        anotherUserUid: gestante.id!,
                                        anotherUserFCMToken: gestante.fcmToken!,
                                      );
                                    }),
                                  );
                                },
                                child: InfoGestante(gestante: gestante),
                              );
                            } else {
                              return const SizedBox.shrink();
                            }
                          }),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSearchBar() {
    return Container(
      height: 60,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(1),
              child: TextField(
                onChanged: (value) {
                  setState(
                    () {
                      _textSearch = value;
                    },
                  );
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.search),
                  hintText: 'Buscar paciente',
                ),
              ),
            ),
          )
        ],
      ),
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
    );
  }
}

class InfoGestante extends StatelessWidget {
  const InfoGestante({Key? key, required this.gestante}) : super(key: key);

  final Gestante gestante;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        kLineaDivisora,
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: Row(
            children: <Widget>[
              //! Foto
              Column(
                children: <Widget>[
                  CircleAvatar(
                    radius: 22,
                    backgroundImage: gestante.photoUrl! != ""
                        ? NetworkImage(gestante.photoUrl!)
                        : Image.asset("assets/mini_default_profile_icon.png")
                            .image,
                  ),
                ],
              ),
              const SizedBox(width: 15.0),
              //! Nombre
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${gestante.nombre!} ${gestante.apellido}",
                    maxLines: 1,
                    style: kSubTitulo1,
                  ),
                  Text('Conversar',
                      style: kSubTitulo1.copyWith(color: colorSecundario))
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

ObstetraService _obstetraService = ObstetraService();

Future<Obstetra> getObstetra(String id) {
  return _obstetraService.getObstetra(id);
}

Future<List<Gestante>> getListaGestantes(String codigoObstetra) async {
  return _obstetraService.getListaGestantes(codigoObstetra);
}
