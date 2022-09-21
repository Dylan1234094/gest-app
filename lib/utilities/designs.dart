import 'package:flutter/material.dart';

const Color colorPrincipal = Color(0xFF0479BD);

const Color colorSecundario = Color(0xFF9A9A9A);

const kTitulo = TextStyle(
  fontWeight: FontWeight.bold,
  fontSize: 20.0,
);

const kInfo = TextStyle(
  fontWeight: FontWeight.w300,
  fontSize: 14.0,
);

const kTituloCabezera = TextStyle(
  color: Colors.white,
  fontWeight: FontWeight.bold,
  fontSize: 15.0,
);

const kTituloGrafico = TextStyle(
  fontWeight: FontWeight.bold,
  fontSize: 10.0,
);

const kTextoBoton = TextStyle(
  fontSize: 18.0,
);

const kFechaDato = TextStyle(
  color: colorSecundario,
  fontSize: 14.0,
);

const kDato = TextStyle(
  fontSize: 20.0,
);

ButtonStyle estiloBoton = ButtonStyle(
  backgroundColor: MaterialStateProperty.all<Color>(colorPrincipal),
  foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
  fixedSize: MaterialStateProperty.all(const Size(250.0, 46.0)),
  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
    RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
    ),
  ),
);
