import 'package:flutter/material.dart';
import 'package:gest_app/utilities/designs.dart';

class VitalsPage extends StatelessWidget {
  const VitalsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          SizedBox(
            height: 15.0,
          ),
          Container(
            padding: EdgeInsets.all(10.0),
            width: MediaQuery.of(context).size.width - 30,
            height: MediaQuery.of(context).size.height - 50,
            child: GridView.count(
              crossAxisCount: 2,
              primary: false,
              crossAxisSpacing: 5.0,
              mainAxisSpacing: 5.0,
              childAspectRatio: 0.8,
              children: [
                _buildCard('Actividad Fisica',
                    'assets/IconsVitals/act_fisica_icon.png', context),
                _buildCard('Frecuencia Cardiaca',
                    'assets/IconsVitals/fre_car_icon.png', context),
                _buildCard(
                    'Glucosa', 'assets/IconsVitals/gluco_icon.png', context),
                _buildCard('Peso', 'assets/IconsVitals/peso_icon.png', context),
                _buildCard('Presión Arterial',
                    'assets/IconsVitals/pres_art_icon.png', context),
                _buildCard('Saturación de Oxígeno',
                    'assets/IconsVitals/sat_oxig_icon.png', context)
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildCard(String name, String imgPath, context) {
    return Padding(
      padding: EdgeInsets.all(5.0),
      child: InkWell(
        onTap: () {},
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 3.0,
                blurRadius: 5.0,
              )
            ],
            color: Colors.white,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 70.0,
                width: 70.0,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(imgPath),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  name,
                  style: kTituloGrafico,
                  textAlign: TextAlign.center,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
