// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gest_app/data/model/obstetra.dart';
import 'package:gest_app/service/obstetra_service.dart';

class DrawerGest extends StatelessWidget {
  const DrawerGest({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    return Drawer(
      child: ListView(
        children: [
          FutureBuilder<Obstetra>(
              future: null, //! getObstetra(user.id)
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  //! invertir !
                  return UserAccountsDrawerHeader(
                      accountName: Text(
                        "snapshot.data!.nombre! + snapshot.data!.apellido!",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      accountEmail: Text("snapshot.data!.correo!"),
                      currentAccountPicture: CircleAvatar(
                        //!backgroundImage: NetworkImage("Image"),
                        backgroundColor: Color(0xFF245470),
                        child: const Text('AH'),
                      ));
                } else {
                  return UserAccountsDrawerHeader(
                      accountName: Text("accountFirstName + accountLastName"),
                      accountEmail: Text("accountEmail"),
                      currentAccountPicture: CircleAvatar(
                        //!backgroundImage: NetworkImage("Image"),
                        backgroundColor: Color(0xFF245470),
                        child: const Text('AH'),
                      ));
                }
              }),
          ListTile(
            title: Text('Mi Perfil'),
            leading: Icon(Icons.person),
            onTap: () {},
          ),
          ListTile(
            title: Text('Configuración'),
            leading: Icon(Icons.settings),
            onTap: () {},
          ),
          ListTile(
            title: Text('Cerrar sesión'),
            leading: Icon(Icons.logout),
            onTap: () {},
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
