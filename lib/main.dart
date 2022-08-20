import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:gest_app/layout/authentication/login_gest.dart';
import 'package:gest_app/layout/authentication/login_obs.dart';
import 'package:gest_app/layout/authentication/register_gest.dart';
import 'package:gest_app/layout/authentication/register_obs.dart';
import 'package:gest_app/layout/gest/tabs.dart';
import 'package:gest_app/layout/start/start_page.dart';
import 'package:gest_app/layout/monitoring/monitoring_obstetra.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gest_app/shared/drawer_gest.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gest App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/tabs',
      routes: {
        '/tabs': (context) => Tabs(),
        '/': (context) => MyHomePage(),
        '/registerObstetra': (context) => const RegisterObs(),
        '/loginObstetra': (context) => const LoginObsWidget(),
        '/registerGestante': (context) => const RegisterGest(),
        '/loginGestante': (context) => const LoginGest(),
      },
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data!.emailVerified == false) {
              //emailVerified permite reconocer que el inicio de sesión no es una por una cuenta de Google (Gestante)
              return const MonitorObs();
            } else {
              return const Start();
            }
          },
        ),
      );
}
