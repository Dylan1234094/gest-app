import 'package:flutter/material.dart';

import '../../utilities/designs.dart';
import '../authentication/login_gest.dart';
import '../authentication/login_obs.dart';

class Start extends StatelessWidget {
  const Start({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const StartPage();
  }
}

class StartPage extends StatefulWidget {
  const StartPage({Key? key}) : super(key: key);

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          margin: const EdgeInsets.symmetric(vertical: 41, horizontal: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(50.0),
                child: Hero(
                  tag: 'logo',
                  child: Image.asset('assets/Gest_Icon.png'),
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    child: const Text('SOY GESTANTE'),
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(colorPrincipal),
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                      fixedSize:
                          MaterialStateProperty.all(const Size(250.0, 50.0)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, LoginGest.id);
                    },
                  ),
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(colorPrincipal),
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                      fixedSize:
                          MaterialStateProperty.all(const Size(250.0, 55.0)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, LoginObsWidget.id);
                    },
                    child: const Text('SOY PROFESIONAL DE SALUD',
                        textAlign: TextAlign.center),
                  ),
                ),
              ),
            ],
          ),
        ),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              colorPrincipal,
              Color.fromRGBO(6, 155, 240, 0.44),
            ],
          ),
        ),
      ),
    );
  }
}
