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
  String _textSearch = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: const Text("Conversaciones")),
      body: Column(
        children: [
          buildSearchBar(),
          Expanded(
            child: FutureBuilder<Obstetra>(
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
                          child:
                              Text("No se encontraron gestantes registrados"));
                    }

                    return ListView.builder(
                        itemCount: snapshotGests.data!.length,
                        itemBuilder: ((context, index) => ItemCard(
                            context, index, snapshotGests, snapshotObs)));
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget ItemCard(BuildContext context, int index, AsyncSnapshot snapshotGests,
      AsyncSnapshot snapshotObs) {
    Gestante gestante = snapshotGests.data![index];
    String nombrecompleto = gestante.nombre! + gestante.apellido!;
    if (nombrecompleto.toLowerCase().contains(_textSearch.toLowerCase())) {
      return Container(
        margin: const EdgeInsets.only(bottom: 5, left: 15, right: 15),
        child: TextButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (BuildContext context) {
                return Chat(
                  nombreSender: snapshotObs.data!.nombre!,
                  apellidoSender: snapshotObs.data!.apellido!,
                  anotherUserName: gestante.nombre!,
                  anotherUserSurname: gestante.apellido!,
                  anotherUserUid: gestante.id!,
                  anotherUserFCMToken: gestante.fcmToken!,
                );
              }),
            );
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
            shape: MaterialStateProperty.all<OutlinedBorder>(
              const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
            ),
          ),
          child: Row(
            children: <Widget>[
              //! Foto
              Material(
                child: gestante.photoUrl!.isNotEmpty
                    ? Image.network(
                        gestante.photoUrl!,
                        fit: BoxFit.cover,
                        width: 50,
                        height: 50,
                        loadingBuilder: (BuildContext context, Widget child,
                            ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            width: 50,
                            height: 50,
                            child: Center(
                              child: CircularProgressIndicator(
                                color: Colors.blue,
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            ),
                          );
                        },
                        errorBuilder: (context, object, stackTrace) {
                          return const Icon(
                            Icons.account_circle,
                            size: 50,
                            color: Colors.grey,
                          );
                        },
                      )
                    : const Icon(
                        Icons.account_circle,
                        size: 50,
                        color: Colors.grey,
                      ),
                borderRadius: const BorderRadius.all(Radius.circular(25)),
                clipBehavior: Clip.hardEdge,
              ),
              //! Nombre
              Flexible(
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: Text(
                          "${gestante.nombre!} ${gestante.apellido}",
                          maxLines: 1,
                          style:
                              const TextStyle(color: Colors.blue, fontSize: 20),
                        ),
                        alignment: Alignment.centerLeft,
                        margin: const EdgeInsets.fromLTRB(10, 0, 0, 5),
                      ),
                    ],
                  ),
                  margin: const EdgeInsets.only(left: 20),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
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

ObstetraService _obstetraService = ObstetraService();

Future<Obstetra> getObstetra(String id) {
  return _obstetraService.getObstetra(id);
}

Future<List<Gestante>> getListaGestantes(String codigoObstetra) async {
  return _obstetraService.getListaGestantes(codigoObstetra);
}
