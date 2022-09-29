import 'package:flutter/material.dart';

const Color colorPrincipal = Color(0xFF0479BD);

const Color colorSecundario = Color(0xFF9A9A9A);

const kTitulo1 = TextStyle(
  fontWeight: FontWeight.w500,
  fontSize: 20.0,
);

const kTitulo2 = TextStyle(
  fontWeight: FontWeight.w500,
  fontSize: 16.0,
);

const kTitulo3 = TextStyle(
  fontWeight: FontWeight.w500,
  fontSize: 14.0,
);

const kTituloCabezera = TextStyle(
  color: Colors.white,
  fontWeight: FontWeight.bold,
  fontSize: 15.0,
);

const kSubTitulo1 = TextStyle(
  fontWeight: FontWeight.w500,
  fontSize: 12.0,
);

const kSubTitulo2 = TextStyle(
  fontWeight: FontWeight.w500,
  fontSize: 10.0,
);

const kDescripcion = TextStyle(
  fontWeight: FontWeight.w300,
  fontSize: 12.0,
);

const kInfoPopUp = TextStyle(
  fontSize: 11.0,
);

const kTituloSignoConfig = TextStyle(
  fontWeight: FontWeight.w500,
  fontSize: 15.0,
  color: colorPrincipal,
);

const kInfoSignoConfig = TextStyle(
  fontWeight: FontWeight.w300,
  fontSize: 10.0,
  color: colorPrincipal,
);

const kTituloPerfilGestante = TextStyle(
  letterSpacing: 1.5,
  fontWeight: FontWeight.bold,
  fontSize: 10.0,
  color: colorSecundario,
);

const kLineaDivisora = Divider(color: colorSecundario);

ButtonStyle estiloBoton = ButtonStyle(
  backgroundColor: MaterialStateProperty.all<Color>(colorPrincipal),
  foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
  fixedSize: MaterialStateProperty.all(const Size(160.0, 46.0)),
  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
    RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
    ),
  ),
);
