import 'package:flutter/material.dart';

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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 120.0,
              width: 120.0,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/Gest_Icon.png'),
                  fit: BoxFit.fill,
                ),
                shape: BoxShape.rectangle,
              ),
            ),
            ElevatedButton(
                style: ButtonStyle(foregroundColor: MaterialStateProperty.all<Color>(Colors.white)),
                onPressed: () {
                  Navigator.pushNamed(context, '/loginGestante');
                },
                child: const Text('Soy Gestante')),
            ElevatedButton(
                style: ButtonStyle(foregroundColor: MaterialStateProperty.all<Color>(Colors.white)),
                onPressed: () {
                  Navigator.pushNamed(context, '/loginObstetra');
                },
                child: const Text('Soy Obstetra'))
          ],
        ),
      ),
    );
  }
}
