import 'dart:io';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:gest_app/data/model/gestante.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gest_app/data/model/obstetra.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/cupertino.dart';
import 'package:googleapis/fitness/v1.dart';

import 'package:http/http.dart' as http;

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn = GoogleSignIn(
  signInOption: SignInOption.standard,
  scopes: <String>[
    FitnessApi.fitnessActivityReadScope,
    FitnessApi.fitnessActivityWriteScope,
    FitnessApi.fitnessBloodGlucoseReadScope,
    FitnessApi.fitnessBloodGlucoseWriteScope,
    FitnessApi.fitnessBloodPressureReadScope,
    FitnessApi.fitnessBloodPressureWriteScope,
    FitnessApi.fitnessBodyReadScope,
    FitnessApi.fitnessBodyWriteScope,
    FitnessApi.fitnessHeartRateReadScope,
    FitnessApi.fitnessHeartRateWriteScope,
    FitnessApi.fitnessOxygenSaturationReadScope,
    FitnessApi.fitnessOxygenSaturationWriteScope,
    FitnessApi.fitnessSleepReadScope,
    FitnessApi.fitnessSleepWriteScope,
  ],
);

class GestanteService {
  final db = FirebaseFirestore.instance;

  void signInGestante(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken, idToken: googleSignInAuthentication.idToken);
      await _auth.signInWithCredential(credential).then((value) async {
        try {
          print(_googleSignIn.currentUser);
          final docRef = db.collection("gestantes").doc(value.user!.uid);
          await docRef.get().then(
            (DocumentSnapshot doc) async {
              if (doc.exists) {
                //get fcmToken and update it on firestore
                final fcmtoken = await FirebaseMessaging.instance.getToken();
                final gestante = Gestante(fcmToken: fcmtoken);

                final docRef = db
                    .collection("gestantes")
                    .withConverter(
                      fromFirestore: Gestante.fromFirestore,
                      toFirestore: (Gestante gestante, options) => gestante.toFirestore(),
                    )
                    .doc(value.user!.uid);
                await docRef.set(gestante, SetOptions(merge: true)).then((value) => Navigator.pop(context, '/'));
              } else {
                //request rtoken, create gest with rtoken then update
                var rtoken = "";
                var url = 'https://upc-cloud-test.azurewebsites.net/api/getVitalData';
                Map data = {
                  'email': _googleSignIn.currentUser!.email,
                  'serverToken': _googleSignIn.currentUser!.serverAuthCode,
                };
                var body = json.encode(data);
                try {
                  var response =
                      await http.post(Uri.parse(url), headers: {"Content-Type": "application/json"}, body: body);
                  rtoken = response.body;
                } catch (e) {
                  print(e);
                }
                createGestante(value.user!.uid, rtoken, context);
              }
            },
            onError: (e) => print("Error al intentar obtener doc ${value.user!.uid} en gestante"),
          );
        } catch (e) {
          print(e);
        }
      });
    } on FirebaseAuthException catch (e) {
      print(e.message);
    }
  }

  void signOutGestante(BuildContext context) async {
    try {
      var uid = _auth.currentUser!.uid;
      await _googleSignIn.signOut();
      await _auth.signOut().then((data) async {
        final gestante = Gestante(fcmToken: "");

        final docRef = db
            .collection("gestantes")
            .withConverter(
              fromFirestore: Gestante.fromFirestore,
              toFirestore: (Gestante gestante, options) => gestante.toFirestore(),
            )
            .doc(uid);
        await docRef
            .set(gestante, SetOptions(merge: true))
            .then((value) => Navigator.popUntil(context, ModalRoute.withName('/')));
      });
    } on FirebaseAuthException catch (e) {
      print(e.message);
    }
  }

  void createGestante(String id, String rtoken, BuildContext context) async {
    final fcmtoken = await FirebaseMessaging.instance.getToken();
    final gestante = Gestante(
      id: id,
      rtoken: rtoken,
      fcmToken: fcmtoken,
    );

    final docRef = db
        .collection("gestantes")
        .withConverter(
          fromFirestore: Gestante.fromFirestore,
          toFirestore: (Gestante gestante, options) => gestante.toFirestore(),
        )
        .doc(id);
    await docRef.set(gestante).then((value) => Navigator.pushNamed(context, '/linkObstetraGestante'));
  }

  void createDataGestante(
      String id,
      String nombre,
      String apellido,
      String correo,
      String telefono,
      String dni,
      String fechaNacimiento,
      String fechaRegla,
      String fechaEco,
      String fechaCita,
      String codigoObs,
      String fcmTokenObs,
      VitalSign vitals,
      BuildContext context) async {
    final gestante = Gestante(
        id: id,
        nombre: nombre,
        apellido: apellido,
        correo: correo,
        dni: dni,
        telefono: telefono,
        fechaNacimiento: fechaNacimiento,
        fechaRegla: fechaRegla,
        fechaEco: fechaEco,
        fechaCita: fechaCita,
        codigoObstetra: codigoObs,
        photoUrl: _auth.currentUser!.photoURL,
        vitals: vitals.toJson());

    final docRef = db
        .collection("gestantes")
        .withConverter(
          fromFirestore: Gestante.fromFirestore,
          toFirestore: (Gestante gestante, options) => gestante.toFirestore(),
        )
        .doc(id);
    await docRef.set(gestante, SetOptions(merge: true)).then((value) async {
      Navigator.of(context).popUntil(ModalRoute.withName("/"));

      var url = 'https://upc-cloud-test.azurewebsites.net/api/sendLinkNotification';
      Map data = {'nameGest': nombre, 'surnameGest': apellido, 'idGest': id, 'fcmReceiverToken': "fcmtoken"};
      var body = json.encode(data);
      try {
        var response = await http.post(Uri.parse(url), headers: {"Content-Type": "application/json"}, body: body);
        print(response.body);
      } catch (e) {
        print(e);
      }
    });
  }

  void updateGestante(String id, String nombre, String apellido, String telefono, String dni, String fechaNacimiento,
      String fechaRegla, String fechaEco, String fechaCita, BuildContext context) async {
    final gestante = Gestante(
        nombre: nombre,
        apellido: apellido,
        dni: dni,
        telefono: telefono,
        fechaNacimiento: fechaNacimiento,
        fechaRegla: fechaRegla,
        fechaEco: fechaEco,
        fechaCita: fechaCita);

    final docRef = db
        .collection("gestantes")
        .withConverter(
          fromFirestore: Gestante.fromFirestore,
          toFirestore: (Gestante gestante, options) => gestante.toFirestore(),
        )
        .doc(id);
    await docRef
        .set(gestante, SetOptions(merge: true))
        .then((value) => Navigator.of(context).popUntil(ModalRoute.withName("/")));
  }

  void updateGestanteSigns(String id, VitalSign vitals, BuildContext context) async {
    final gestante = Gestante(vitals: vitals.toJson());

    final docRef = db
        .collection("gestantes")
        .withConverter(
          fromFirestore: Gestante.fromFirestore,
          toFirestore: (Gestante gestante, options) => gestante.toFirestore(),
        )
        .doc(id);
    await docRef
        .set(gestante, SetOptions(merge: true))
        .then((value) => Navigator.of(context).popUntil(ModalRoute.withName("/")));
  }

  void desvincularObstetra(String id, BuildContext context) async {
    var gestante = const Gestante(codigoObstetra: "");

    final docRef = db
        .collection("gestantes")
        .withConverter(
          fromFirestore: Gestante.fromFirestore,
          toFirestore: (Gestante gestante, options) => gestante.toFirestore(),
        )
        .doc(id);
    await docRef
        .set(gestante, SetOptions(merge: true))
        .then((value) => Navigator.of(context).popUntil(ModalRoute.withName("/")));
  }

  Future<Gestante> getGestante(String uid) async {
    Gestante gestante;
    var nombre = "";
    var apellido = "";
    var correo = "";
    var codigoObs = "";
    var telefono = "";
    var dni = "";
    var fechaNacimiento = "";
    var fechaRegla = "";
    var fechaEco = "";
    var fechaCita = "";
    var photoUrl = "";
    var rtoken = "";
    VitalSign vitals = const VitalSign(actFisica: "", freCardi: "", gluco: "", peso: "", presArt: "", satOxig: "");

    try {
      print(uid);
      final docRef = db.collection("gestantes").doc(uid);
      await docRef.get().then(
        (DocumentSnapshot doc) {
          final data = doc.data() as Map<String, dynamic>;
          nombre = data["nombre"];
          apellido = data["apellido"];
          correo = data["correo"];
          codigoObs = data["codigoObstetra"];
          telefono = data["telefono"];
          dni = data["dni"];
          fechaNacimiento = data["fechaNacimiento"];
          fechaRegla = data["fechaRegla"];
          fechaEco = data["fechaEco"];
          fechaCita = data["fechaCita"];
          photoUrl = data["photoUrl"];
          rtoken = data["rtoken"];
          vitals = VitalSign(
              actFisica: data["vitals"]["actFisica"],
              freCardi: data["vitals"]["freCardi"],
              gluco: data["vitals"]["gluco"],
              peso: data["vitals"]["peso"],
              presArt: data["vitals"]["presArt"],
              satOxig: data["vitals"]["satOxig"]);
        },
        onError: (e) => print("Error al intentar obtener doc $uid en gestante"),
      );
    } catch (e) {
      print(e);
      throw e;
    }
    return gestante = Gestante(
        id: uid,
        nombre: nombre,
        apellido: apellido,
        codigoObstetra: codigoObs,
        telefono: telefono,
        dni: dni,
        fechaNacimiento: fechaNacimiento,
        fechaRegla: fechaRegla,
        fechaEco: fechaEco,
        fechaCita: fechaCita,
        photoUrl: photoUrl,
        rtoken: rtoken,
        vitals: vitals.toJson());
  }

  Future<Obstetra> validateCodeObstetra(String codeObstetra) async {
    Obstetra obstetra;
    var uid = "";
    var nombre = "";
    var apellido = "";
    var correo = "";
    var fcmToken = "";
    var codigoObstetra = "";

    try {
      final docRef =
          await db.collection("obstetras").where("codigoObstetra", isEqualTo: codeObstetra).get().then((event) {
        if (event.docs.isNotEmpty) {
          uid = event.docs.first.data()["id"];
          nombre = event.docs.first.data()["nombre"];
          apellido = event.docs.first.data()["apellido"];
          correo = event.docs.first.data()["correo"];
          fcmToken = event.docs.first.data()["fcmToken"];
          codigoObstetra = event.docs.first.data()["codigoObstetra"];
        }
      });
    } catch (e) {
      print(e);
    }
    return obstetra = Obstetra(
        id: uid,
        nombre: nombre,
        apellido: apellido,
        correo: correo,
        fcmToken: fcmToken,
        codigoObstetra: codigoObstetra);
  }

  void updateCodeObstetra(String id, String codigoObs, String fcmToken, BuildContext context) async {
    final gestante = Gestante(codigoObstetra: codigoObs);
    var nombreGest = "";
    var apellidoGest = "";

    final docRef = db
        .collection("gestantes")
        .withConverter(
          fromFirestore: Gestante.fromFirestore,
          toFirestore: (Gestante gestante, options) => gestante.toFirestore(),
        )
        .doc(id);
    await docRef.set(gestante, SetOptions(merge: true)).then((value) async {
      final docRef = db.collection("gestantes").doc(id);
      await docRef.get().then(
        (DocumentSnapshot doc) {
          final data = doc.data() as Map<String, dynamic>;
          nombreGest = data["nombre"];
          apellidoGest = data["apellido"];
        },
        onError: (e) => print("Error al intentar obtener doc $id en gestante"),
      );
      Navigator.of(context).popUntil(ModalRoute.withName("/"));

      var url = 'https://upc-cloud-test.azurewebsites.net/api/sendLinkNotification';
      Map data = {'nameGest': nombreGest, 'surnameGest': apellidoGest, 'idGest': id, 'fcmReceiverToken': fcmToken};
      var body = json.encode(data);
      try {
        var response = await http.post(Uri.parse(url), headers: {"Content-Type": "application/json"}, body: body);
        print(response.body);
      } catch (e) {
        print(e);
      }
    });
  }

  Future<Obstetra> getObstetraChat(String gestID) async {
    Obstetra obstetra;
    var uid = "";
    var nombre = "";
    var apellido = "";
    var codigoObstetra = "";
    var fcmToken = "";

    try {
      final gestRef = await db.collection("gestantes").doc(gestID).get().then((DocumentSnapshot doc) async {
        final data = doc.data() as Map<String, dynamic>;
        final docRef = await db
            .collection("obstetras")
            .where("codigoObstetra", isEqualTo: data["codigoObstetra"])
            .get()
            .then((event) {
          if (event.docs.isNotEmpty) {
            uid = event.docs.first.data()["id"];
            nombre = event.docs.first.data()["nombre"];
            apellido = event.docs.first.data()["apellido"];
            codigoObstetra = event.docs.first.data()["codigoObstetra"];
            fcmToken = event.docs.first.data()["fcmToken"];
          }
        });
      });
    } catch (e) {
      print(e);
    }
    return obstetra =
        Obstetra(id: uid, nombre: nombre, apellido: apellido, codigoObstetra: codigoObstetra, fcmToken: fcmToken);
  }
}
