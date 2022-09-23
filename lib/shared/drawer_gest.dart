// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gest_app/data/model/obstetra.dart';
import 'package:gest_app/service/gestante_service.dart';
import 'package:gest_app/service/obstetra_service.dart';

import '../layout/gest/acc_config/mi_obstetra.dart';
import '../layout/gest/acc_config/update_vitalsign.dart';
import '../layout/profiles/profile_gest.dart';
import '../utilities/designs.dart';

class DrawerGest extends StatelessWidget {
  const DrawerGest({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.85,
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(
              user.displayName!,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            accountEmail: Text(user.email!),
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage(user.photoURL!),
            ),
          ),
          ListTile(
            title: Text('Perfil'),
            leading: Icon(Icons.account_circle),
            onTap: () {
              Navigator.pushNamed(context, ProfileGest.id);
            },
          ),
          ListTile(
            title: Text('Mi Obstetra'),
            leading: Icon(Icons.medical_information),
            onTap: () {
              Navigator.pushNamed(context, DatosObstetra.id);
            },
          ),
          ListTile(
            title: Text('Configuración'),
            leading: Icon(Icons.settings),
            onTap: () {
              Navigator.pushNamed(context, UpdateVitalSigns.id);
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Divider(color: colorSecundario),
          ),
          ListTile(
            title: Text('Cerrar Sesión'),
            leading: Icon(Icons.logout),
            onTap: () {
              logOutGestante(context);
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

void logOutGestante(BuildContext context) {
  GestanteService _gestanteService = GestanteService();

  return _gestanteService.signOutGestante(context);
}
