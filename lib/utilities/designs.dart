import 'package:flutter/material.dart';

const Color colorPrincipal = Color(0xFF0479BD);

const Color colorSecundario = Color(0xFF9A9A9A);

const kTitulo = TextStyle(
  fontWeight: FontWeight.bold,
  fontSize: 20.0,
);

const kInfo = TextStyle(
  fontWeight: FontWeight.w300,
  fontSize: 13.0,
);

const kTituloCabezera = TextStyle(
  color: Colors.white,
  fontWeight: FontWeight.bold,
  fontSize: 15.0,
);

const kGestHomeTitGrafic = TextStyle(
  fontWeight: FontWeight.bold,
  fontSize: 14.0,
);

const kGestHomeDescGrafic = TextStyle(
  color: colorSecundario,
  fontWeight: FontWeight.w300,
  fontSize: 12.0,
);

const kTextoBoton = TextStyle(
  fontSize: 14.0,
);

const kFechaDato = TextStyle(
  color: colorSecundario,
  fontSize: 13.0,
);

const kDato = TextStyle(
  fontSize: 17.0,
);

const kTituloSignoConfig = TextStyle(
  fontWeight: FontWeight.bold,
  fontSize: 15.0,
  color: colorPrincipal,
);

const kInfoSignoConfig = TextStyle(
  fontWeight: FontWeight.w300,
  fontSize: 10.0,
  color: colorPrincipal,
);

const kPopUpInfo = TextStyle(
  fontSize: 11.0,
);

const kTituloGuia = TextStyle(
  fontWeight: FontWeight.bold,
  fontSize: 12.0,
);

const kInfoGuia = TextStyle(
  fontSize: 10.0,
  color: colorSecundario,
);

const kDescGuia = TextStyle(
  fontSize: 12,
  height: 1.5,
);

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
