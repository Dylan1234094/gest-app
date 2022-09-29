// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gest_app/data/model/obstetra.dart';
import 'package:gest_app/service/obstetra_service.dart';
import 'package:gest_app/utilities/designs.dart';

class DrawerObs extends StatelessWidget {
  const DrawerObs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.85,
      child: ListView(
        children: [
          FutureBuilder<Obstetra>(
            future: getObstetra(user.uid), //! getObstetra(user.id)
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return UserAccountsDrawerHeader(
                    accountName: CircularProgressIndicator(color: Colors.white),
                    accountEmail:
                        CircularProgressIndicator(color: Colors.white),
                    currentAccountPicture:
                        CircularProgressIndicator(color: Colors.white),
                  );
                case ConnectionState.done:
                  if (snapshot.hasData) {
                    return UserAccountsDrawerHeader(
                      accountName: Text(
                        "${snapshot.data!.nombre} ${snapshot.data!.apellido}",
                        style: TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      accountEmail: Text(
                        "Código: ${snapshot.data!.codigoObstetra}",
                        style: TextStyle(fontSize: 12.0),
                      ),
                      currentAccountPicture: CircleAvatar(
                        child: Text(
                          snapshot.data!.nombre!.substring(0, 1) +
                              snapshot.data!.apellido!.substring(0, 1),
                          style: TextStyle(color: Colors.white),
                        ),
                        backgroundColor: Colors.lightBlue[900],
                      ),
                    );
                  } else {
                    return UserAccountsDrawerHeader(
                      accountName: Text("accountFirstName + accountLastName"),
                      accountEmail: Text("accountEmail"),
                      currentAccountPicture: CircleAvatar(
                        backgroundColor: Colors.lightBlue[900],
                      ),
                    );
                  }
                default:
                  return UserAccountsDrawerHeader(
                    accountName: Text("accountFirstName + accountLastName"),
                    accountEmail: Text("accountEmail"),
                    currentAccountPicture: CircleAvatar(
                      backgroundColor: Colors.lightBlue[900],
                    ),
                  );
              }
            },
          ),
          ListTile(
            title: Text('Perfil', style: TextStyle(color: Colors.black54)),
            leading: Icon(Icons.account_circle, color: Colors.black54),
            onTap: () {
              Navigator.pushNamed(context, '/profileObs');
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: kLineaDivisora,
          ),
          ListTile(
            title: Text(
              'Cerrar Sesión',
              style: TextStyle(color: Colors.black54),
            ),
            leading: Icon(Icons.logout, color: Colors.black54),
            onTap: () {
              logOutObstetra();
            },
          )
        ],
      ),
    );
  }
}

Future<Obstetra> getObstetra(String id) {
  ObstetraService _obstetraService = ObstetraService();

  return _obstetraService.getObstetra(id);
}

void logOutObstetra() {
  ObstetraService _obstetraService = ObstetraService();
  _obstetraService.logoutObstetra();
}
