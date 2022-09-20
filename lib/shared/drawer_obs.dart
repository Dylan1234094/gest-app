// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gest_app/data/model/obstetra.dart';
import 'package:gest_app/service/obstetra_service.dart';

class DrawerObs extends StatelessWidget {
  const DrawerObs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    return Drawer(
      child: ListView(
        children: [
          FutureBuilder<Obstetra>(
              future: getObstetra(user.uid), //! getObstetra(user.id)
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return UserAccountsDrawerHeader(
                      accountName: CircularProgressIndicator(color: Colors.white),
                      accountEmail: CircularProgressIndicator(color: Colors.white),
                      currentAccountPicture: CircularProgressIndicator(color: Colors.white),
                    );
                  case ConnectionState.done:
                    if (snapshot.hasData) {
                      return UserAccountsDrawerHeader(
                        accountName: Text(
                          "${snapshot.data!.nombre} ${snapshot.data!.apellido}",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        accountEmail: Text(
                          "Código: ${snapshot.data!.codigoObstetra}",
                        ),
                        currentAccountPicture: CircleAvatar(
                          // backgroundImage: NetworkImage(user.photoURL!),
                          backgroundColor: Color(0xFF245470),
                          child:
                              Text(snapshot.data!.nombre!.substring(0, 1) + snapshot.data!.apellido!.substring(0, 1)),
                        ),
                      );
                    } else {
                      return UserAccountsDrawerHeader(
                        accountName: Text("accountFirstName + accountLastName"),
                        accountEmail: Text("accountEmail"),
                        currentAccountPicture: CircleAvatar(
                          //!backgroundImage: NetworkImage("Image"),
                          backgroundColor: Color(0xFF245470),
                          child: const Text('AH'),
                        ),
                      );
                    }
                  default:
                    return UserAccountsDrawerHeader(
                      accountName: Text("accountFirstName + accountLastName"),
                      accountEmail: Text("accountEmail"),
                      currentAccountPicture: CircleAvatar(
                        //!backgroundImage: NetworkImage("Image"),
                        backgroundColor: Color(0xFF245470),
                        child: const Text('AH'),
                      ),
                    );
                }
              }),
          ListTile(
            title: Text('Mi Perfil'),
            leading: Icon(Icons.person),
            onTap: () {
              Navigator.pushNamed(context, '/profileObs');
            },
          ),
          // ListTile(
          //   title: Text('Configuración'),
          //   leading: Icon(Icons.settings),
          //   onTap: () {},
          // ),
          ListTile(
            title: Text('Cerrar sesión'),
            leading: Icon(Icons.logout),
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
