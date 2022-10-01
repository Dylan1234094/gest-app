// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gest_app/data/model/gestante.dart';
import 'package:gest_app/service/gestante_service.dart';

import 'acc_config/mi_obstetra.dart';
import 'acc_config/update_vitalsign.dart';
import '../profiles/profile_gest.dart';
import '../../utilities/designs.dart';

import 'package:intl/intl.dart' as intl;

class DrawerGest extends StatelessWidget {
  const DrawerGest({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.85,
      child: ListView(
        children: [
          FutureBuilder<Gestante>(
            future: getGestante(user.uid), //! getObstetra(user.id)
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
                        "${snapshot.data!.nombre!} ${snapshot.data!.apellido}",
                        style: TextStyle(
                            fontSize: 13.0, fontWeight: FontWeight.bold),
                      ),
                      accountEmail: Text(
                        "${(DateTime.now().difference(intl.DateFormat("dd/MM/yyyy hh:mm:ss").parse(snapshot.data!.fechaRegla! + " 00:00:00")).inDays / 4).round()} semanas de embarazo",
                        style: TextStyle(fontSize: 12.0),
                      ),
                      currentAccountPicture: CircleAvatar(
                        backgroundImage: NetworkImage(user.photoURL!),
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
              Navigator.pushNamed(context, ProfileGest.id);
            },
          ),
          ListTile(
            title: Text('Mi Obstetra', style: TextStyle(color: Colors.black54)),
            leading: Icon(Icons.medical_information, color: Colors.black54),
            onTap: () {
              Navigator.pushNamed(context, DatosObstetra.id);
            },
          ),
          ListTile(
            title: Text(
              'Configuración',
              style: TextStyle(color: Colors.black54),
            ),
            leading: Icon(Icons.settings, color: Colors.black54),
            onTap: () {
              Navigator.pushNamed(context, UpdateVitalSigns.id);
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
              logOutGestante(context);
            },
          )
        ],
      ),
    );
  }
}

Future<Gestante> getGestante(String id) {
  GestanteService _gestanteService = GestanteService();

  return _gestanteService.getGestante(id);
}

void logOutGestante(BuildContext context) {
  GestanteService _gestanteService = GestanteService();

  return _gestanteService.signOutGestante(context);
}
