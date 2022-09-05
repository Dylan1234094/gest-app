import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gest_app/data/model/gestante.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gest_app/data/model/obstetra.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/cupertino.dart';
import 'package:googleapis/fitness/v1.dart';
import 'package:health/health.dart';
import 'package:permission_handler/permission_handler.dart';

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
          final docRef = db.collection("gestantes").doc(value.user!.uid);
          await docRef.get().then(
            (DocumentSnapshot doc) {
              if (doc.exists) {
                Navigator.pushNamed(context, '/tabs');
              } else {
                Navigator.pushNamed(context, '/linkObstetraGestante');
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
      await _googleSignIn.signOut();
      await _auth.signOut();
      Navigator.popUntil(context, ModalRoute.withName('/'));
    } on FirebaseAuthException catch (e) {
      print(e.message);
    }
  }

  void createGestante(
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
        vitals: vitals.toJson());

    final docRef = db
        .collection("gestantes")
        .withConverter(
          fromFirestore: Gestante.fromFirestore,
          toFirestore: (Gestante gestante, options) => gestante.toFirestore(),
        )
        .doc(id);
    await docRef.set(gestante).then((value) => Navigator.pushNamed(context, '/tabs'));
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

  Future<Gestante> getGestante(String uid) async {
    Gestante gestante;
    var nombre = "";
    var apellido = "";
    var correo = "";
    var telefono = "";
    var dni = "";
    var fechaNacimiento = "";
    var fechaRegla = "";
    var fechaEco = "";
    var fechaCita = "";

    try {
      final docRef = db.collection("gestantes").doc(uid);
      await docRef.get().then(
        (DocumentSnapshot doc) {
          final data = doc.data() as Map<String, dynamic>;
          nombre = data["nombre"];
          apellido = data["apellido"];
          correo = data["correo"];
          telefono = data["telefono"];
          dni = data["dni"];
          fechaNacimiento = data["fechaNacimiento"];
          fechaRegla = data["fechaRegla"];
          fechaEco = data["fechaEco"];
          fechaCita = data["fechaCita"];
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
        telefono: telefono,
        dni: dni,
        fechaNacimiento: fechaNacimiento,
        fechaRegla: fechaRegla,
        fechaEco: fechaEco,
        fechaCita: fechaCita);
  }

  Future<Obstetra> validateCodeObstetra(String codeObstetra) async {
    Obstetra obstetra;
    var uid = "";
    var nombre = "";
    var apellido = "";
    var codigoObstetra = "";

    try {
      final docRef =
          await db.collection("obstetras").where("codigoObstetra", isEqualTo: codeObstetra).get().then((event) {
        if (event.docs.isNotEmpty) {
          uid = event.docs.first.data()["id"];
          nombre = event.docs.first.data()["nombre"];
          apellido = event.docs.first.data()["apellido"];
          codigoObstetra = event.docs.first.data()["codigoObstetra"];
        }
      });
    } catch (e) {
      print(e);
    }
    return obstetra = Obstetra(id: uid, nombre: nombre, apellido: apellido, codigoObstetra: codigoObstetra);
  }

  void testFit() async {
    // print(_googleSignIn.currentUser);
    DateTime startDate = DateTime.now().add(const Duration(days: -1));
    DateTime endDate = DateTime.now();
    HealthFactory health = HealthFactory();

    List<HealthDataType> types = [
      HealthDataType.STEPS,
    ];

    bool accessWasGranted = await health.requestAuthorization(types);
    int steps = 0;

    if (Platform.isAndroid) {
      final permissionStatus = Permission.activityRecognition.request();
      if (await permissionStatus.isDenied || await permissionStatus.isPermanentlyDenied) {
        return;
      } else if (await permissionStatus.isGranted) {
        if (accessWasGranted) {
          try {
            List<HealthDataPoint> healthData = await health.getHealthDataFromTypes(startDate, endDate, types);

            print("Obteniendo data del ${startDate} al ${endDate}");
            healthData.forEach((element) {
              print("Data point: ${element}");
            });
          } catch (e) {
            print("FIT ERROR: ${e}");
          }
        } else {
          print("No Authorization given");
        }
      }
    }
  }
}
