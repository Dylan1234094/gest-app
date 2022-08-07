import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gest_app/data/model/gestante.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/cupertino.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn = GoogleSignIn();

class GestanteService {
  final db = FirebaseFirestore.instance;

  void signInGestante(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount!.authentication;
      final AuthCredential credential =
          GoogleAuthProvider.credential(accessToken: googleSignInAuthentication.accessToken, idToken: googleSignInAuthentication.idToken);
      await _auth.signInWithCredential(credential).then((value) async {
        try {
          final docRef = db.collection("gestantes").doc(value.user!.uid);
          await docRef.get().then(
            (DocumentSnapshot doc) {
              if (doc.exists) {
                print("Usuario ya se encuentra registrado");
              } else {
                Navigator.pushNamed(context, '/registerGestante');
              }
            },
            onError: (e) => print("Error al intentar obtener doc ${value.user!.uid}"),
          );
        } catch (e) {
          print(e);
        }
      });
    } on FirebaseAuthException catch (e) {
      print(e.message);
    }
  }

  void signOutGestante() async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
    } on FirebaseAuthException catch (e) {
      print(e.message);
    }
  }

  void createGestante(String nombre, String apellido, String correo, String telefono, String dni, String fechaNacimiento, String fechaRegla,
      String fechaEco, String fechaCita) async {
    final gestante = Gestante(
        nombre: nombre,
        apellido: apellido,
        correo: correo,
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
        .doc(dni);
    await docRef.set(gestante);
  }
}
