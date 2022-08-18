// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:gest_app/layout/gest/exam/exams.dart';
import 'package:gest_app/layout/gest/guide/guides.dart';
import 'package:gest_app/layout/gest/home/home.dart';

class Tabs extends StatefulWidget {

  @override
  _TabsState createState() => _TabsState();
}

class _TabsState extends State<Tabs> {
  int _currentIndex=0;

  List _pageList = [
    HomePage(),
    GuidePage(),
    ExamPage()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: this._pageList[this._currentIndex],   // De acuerdo con el subíndice para obtener la configuración de página correspondiente en el cuerpo
      bottomNavigationBar: BottomNavigationBar(     // Personaliza la barra de navegación inferior

          currentIndex: this._currentIndex,   // Configure el valor de índice correspondiente para seleccionar
          onTap: (int index){
            setState(() {     //Cambian de estado
              this._currentIndex=index;      // Cambiar las coordenadas de la pestaña seleccionada
            });
          },
          iconSize: 45.0,   // Tamaño del icono, el valor predeterminado es 20
          backgroundColor: Colors.blue,
          fixedColor: Colors.white, // El color seleccionado, el predeterminado es azul
          type: BottomNavigationBarType.fixed,    // Las pestañas inferiores de la configuración pueden tener varios botones. El valor predeterminado es poner como máximo tres botones. Cuando hay más de tres, debe agregar este código
          items:[
            BottomNavigationBarItem(      // Establecer elementos de navegación
                icon:Icon(Icons.home),
                label: "INICIO"
            ),
            BottomNavigationBarItem(      // Establecer elementos de navegación
                icon:Icon(Icons.feed_outlined),
                label: "GUÍAS"
            ),
            BottomNavigationBarItem(      // Establecer elementos de navegación
                icon:Icon(Icons.health_and_safety_outlined),
                label: "EXÁMENES"
            ),
          ]
      ),
    );
  }
}