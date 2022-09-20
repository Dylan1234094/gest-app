import 'package:cloud_firestore/cloud_firestore.dart';

class Obstetra {
  final String? id;
  final String? nombre;
  final String? apellido;
  final String? correo;
  final String? telefono;
  final String? contrasenia;
  final String? codigoObstetra;
  final String? fcmToken;

  const Obstetra(
      {this.id,
      this.nombre,
      this.apellido,
      this.correo,
      this.telefono,
      this.contrasenia,
      this.codigoObstetra,
      this.fcmToken});

  factory Obstetra.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Obstetra(
        id: data?['id'],
        nombre: data?['nombre'],
        apellido: data?['apellido'],
        correo: data?['correo'],
        telefono: data?['telefono'],
        contrasenia: data?['contrasenia'],
        codigoObstetra: data?['codigoObstetra'],
        fcmToken: data?['fcmToken']);
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (id != null) "id": id,
      if (nombre != null) "nombre": nombre,
      if (apellido != null) "apellido": apellido,
      if (correo != null) "correo": correo,
      if (telefono != null) "telefono": telefono,
      if (contrasenia != null) "contrasenia": contrasenia,
      if (codigoObstetra != null) "codigoObstetra": codigoObstetra,
      if (fcmToken != null) "fcmToken": fcmToken,
    };
  }
}
