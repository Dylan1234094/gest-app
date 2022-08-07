import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
                    return const Text("DATA_NAME");
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
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: ElevatedButton(
                  onPressed: () {
                    final val = 12;
                    final val2 = 000120;
                    intl.NumberFormat formatNumber = new intl.NumberFormat("000000");
                    intl.NumberFormat formatNumber2 = new intl.NumberFormat("0");
                    print(1.toString().padLeft(6, '0'));
                    print(formatNumber.format(val));
                    print(formatNumber2.format(val2));
                  },
                  child: const Text('test'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<Obstetra> getObstetra(String id) {
  ObstetraService _obstetraService = ObstetraService();

  return _obstetraService.getObstetra(id);
}
