import 'package:cloud_firestore/cloud_firestore.dart';

class VitalSign {
  final String? actFisica;
  final String? freCardi;
  final String? presArt;
  final String? satOxig;
  final String? peso;
  final String? gluco;

  const VitalSign({this.actFisica, this.freCardi, this.presArt, this.satOxig, this.peso, this.gluco});

  VitalSign.fromJson(Map<String, dynamic> json)
      : actFisica = json['actFisica'],
        freCardi = json['freCardi'],
        presArt = json['presArt'],
        satOxig = json['satOxig'],
        peso = json['peso'],
        gluco = json['gluco'];

  Map<String, dynamic> toJson() => {
        'actFisica': actFisica,
        'freCardi': freCardi,
        'presArt': presArt,
        'satOxig': satOxig,
        'peso': peso,
        'gluco': gluco
      };
}

class Gestante {
  final String? id;
  final String? nombre;
  final String? apellido;
  final String? correo;
  final String? telefono;
  final String? dni;
  final String? fechaNacimiento;
  final String? fechaRegla;
  final String? fechaEco;
  final String? fechaCita;
  final String? codigoObstetra;
  final String? photoUrl;
  final String? rtoken;
  final String? fcmToken;
  final Map<String, dynamic>? vitals;

  const Gestante(
      {this.id,
      this.nombre,
      this.apellido,
      this.correo,
      this.telefono,
      this.dni,
      this.fechaNacimiento,
      this.fechaRegla,
      this.fechaEco,
      this.fechaCita,
      this.codigoObstetra,
      this.photoUrl,
      this.rtoken,
      this.fcmToken,
      this.vitals});

  factory Gestante.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Gestante(
      id: data?['id'],
      nombre: data?['nombre'],
      apellido: data?['apellido'],
      correo: data?['correo'],
      telefono: data?['telefono'],
      dni: data?['dni'],
      fechaNacimiento: data?['fechaNacimiento'],
      fechaRegla: data?['fechaRegla'],
      fechaEco: data?['fechaEco'],
      fechaCita: data?['fechaCita'],
      codigoObstetra: data?['codigoObstetra'],
      photoUrl: data?['photoUrl'],
      rtoken: data?['rtoken'],
      fcmToken: data?['fcmToken'],
      vitals: data?['vitals'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (id != null) "id": id,
      if (nombre != null) "nombre": nombre,
      if (apellido != null) "apellido": apellido,
      if (correo != null) "correo": correo,
      if (telefono != null) "telefono": telefono,
      if (dni != null) "dni": dni,
      if (fechaNacimiento != null) "fechaNacimiento": fechaNacimiento,
      if (fechaRegla != null) "fechaRegla": fechaRegla,
      if (fechaEco != null) "fechaEco": fechaEco,
      if (fechaCita != null) "fechaCita": fechaCita,
      if (codigoObstetra != null) "codigoObstetra": codigoObstetra,
      if (photoUrl != null) "photoUrl": photoUrl,
      if (rtoken != null) "rtoken": rtoken,
      if (fcmToken != null) "fcmToken": fcmToken,
      if (vitals != null) "vitals": vitals,
    };
  }
}
