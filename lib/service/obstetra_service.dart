import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:gest_app/data/model/gestante.dart';
import 'package:gest_app/data/model/obstetra.dart';

final db = FirebaseFirestore.instance;

class ObstetraService {
  Future<int> obtenerMaxCodigo() async {
    int codigo = 0;
    try {
      final docRef = db.collection("obstetras");
      await docRef.orderBy("codigoObstetra", descending: true).limit(1).get().then((querySnapshot) {
        if (querySnapshot.size == 1) {
          var querydocumentSnapshot = querySnapshot.docs[0];
          codigo = int.parse(querydocumentSnapshot["codigoObstetra"]);
        }
      });
    } catch (e) {
      print(e);
    }
    return codigo;
  }

  bool registerObstetra(String nombre, String apellido, String correo, String telefono, String contrasenia,
      String codigoObstetra, BuildContext context) {
    try {
      FirebaseAuth.instance.createUserWithEmailAndPassword(email: correo, password: contrasenia).then((data) async {
        final fcmtoken = await FirebaseMessaging.instance.getToken();
        final obstetra = Obstetra(
            id: data.user?.uid,
            nombre: nombre,
            apellido: apellido,
            correo: correo,
            telefono: telefono,
            contrasenia: contrasenia,
            codigoObstetra: codigoObstetra,
            fcmToken: fcmtoken);
        final docRef = db
            .collection("obstetras")
            .withConverter(
              fromFirestore: Obstetra.fromFirestore,
              toFirestore: (Obstetra obstetra, options) => obstetra.toFirestore(),
            )
            .doc(data.user?.uid);
        await docRef.set(obstetra).then((data) => Navigator.popUntil(context, ModalRoute.withName('/')));
      }, onError: (e) => print("Algo salió mal al registrar a la Obstetra"));
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print("contrasenia muy debil");
      } else if (e.code == "email-already-in-use") {
        print("ya existe una cuenta con correo " + correo);
      }
      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  void updateObstetra(String id, String nombre, String apellido, String telefono, BuildContext context) async {
    final obstetra = Obstetra(id: id, nombre: nombre, apellido: apellido, telefono: telefono);

    final docRef = db
        .collection("obstetras")
        .withConverter(
          fromFirestore: Obstetra.fromFirestore,
          toFirestore: (Obstetra obstetra, options) => obstetra.toFirestore(),
        )
        .doc(id);
    await docRef
        .set(obstetra, SetOptions(merge: true))
        .then((value) => Navigator.of(context).popUntil(ModalRoute.withName("/")));
  }

  Future loginObstetra(String email, String contrasenia, BuildContext context) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: contrasenia).then((data) async {
        final fcmtoken = await FirebaseMessaging.instance.getToken();
        final obstetra = Obstetra(fcmToken: fcmtoken);

        final docRef = db
            .collection("obstetras")
            .withConverter(
              fromFirestore: Obstetra.fromFirestore,
              toFirestore: (Obstetra obstetra, options) => obstetra.toFirestore(),
            )
            .doc(data.user!.uid);
        await docRef
            .set(obstetra, SetOptions(merge: true))
            .then((value) => Navigator.of(context).popUntil(ModalRoute.withName("/")));
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print("no se encontró usuario");
      } else if (e.code == "wrong-password") {
        print("contrasenia incorrecta");
      }
    } catch (e) {
      print(e);
    }
  }

  Future logoutObstetra() async {
    try {
      var uid = FirebaseAuth.instance.currentUser!.uid;
      await FirebaseAuth.instance.signOut().then((data) async {
        final obstetra = Obstetra(fcmToken: "");

        final docRef = db
            .collection("obstetras")
            .withConverter(
              fromFirestore: Obstetra.fromFirestore,
              toFirestore: (Obstetra obstetra, options) => obstetra.toFirestore(),
            )
            .doc(uid);
        await docRef.set(obstetra, SetOptions(merge: true));
      });
    } catch (e) {
      print(e);
    }
  }

  Future<Obstetra> getObstetra(String uid) async {
    Obstetra obstetra;
    var nombre = "";
    var apellido = "";
    var codigoObstetra = "";
    var correo = "";
    var telefono = "";

    try {
      final docRef = db.collection("obstetras").doc(uid);
      await docRef.get().then(
        (DocumentSnapshot doc) {
          final data = doc.data() as Map<String, dynamic>;
          nombre = data["nombre"];
          apellido = data["apellido"];
          codigoObstetra = data["codigoObstetra"];
          correo = data["correo"];
          telefono = data["telefono"];
        },
        onError: (e) => print("Error al intentar obtener doc $uid"),
      );
    } catch (e) {
      print(e);
    }
    return obstetra = Obstetra(
        id: uid,
        nombre: nombre,
        apellido: apellido,
        codigoObstetra: codigoObstetra,
        correo: correo,
        telefono: telefono);
  }

  Future<List<Gestante>> getListaGestantes(String codigoObstetra) async {
    List<Gestante> listaGestantes = [];
    Gestante gestante;

    try {
      await db.collection("gestantes").where("codigoObstetra", isEqualTo: codigoObstetra).get().then((event) {
        for (var doc in event.docs) {
          gestante = Gestante(
              id: doc.data()["id"],
              nombre: doc.data()["nombre"],
              apellido: doc.data()["apellido"],
              fechaRegla: doc.data()["fechaRegla"],
              photoUrl: doc.data()["photoUrl"],
              fcmToken: doc.data()["fcmToken"],
              vitals: doc.data()["vitals"]);
          listaGestantes.add(gestante);
        }
      });
    } catch (e) {
      print(e);
    }

    return listaGestantes;
  }
}
