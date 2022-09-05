import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:gest_app/firebase_options.dart';
import 'package:gest_app/layout/authentication/login_gest.dart';
import 'package:gest_app/layout/authentication/login_obs.dart';
import 'package:gest_app/layout/authentication/register_gest.dart';
import 'package:gest_app/layout/authentication/register_obs.dart';
import 'package:gest_app/layout/authentication/linkobs_gest.dart';
import 'package:gest_app/layout/authentication/vitalsigns_gest.dart';
import 'package:gest_app/layout/gest/tabs.dart';
import 'package:gest_app/layout/profiles/profile_gest.dart';
import 'package:gest_app/layout/profiles/profile_obs.dart';
import 'package:gest_app/layout/start/start_page.dart';
import 'package:gest_app/layout/monitoring/monitoring_obstetra.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> main() async {
  //! Pa web
  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

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
      initialRoute: '/',
      routes: {
        '/': (context) => const MyHomePage(),
        '/tabs': (context) => const Tabs(),
        '/registerObstetra': (context) => const RegisterObs(),
        '/loginObstetra': (context) => const LoginObsWidget(),
        '/registerGestante': (context) => const RegisterGest(),
        '/loginGestante': (context) => const LoginGest(),
        '/linkObstetraGestante': (context) => const LinkObsGest(),
        '/vitalSignsGestante': (context) => const VitalSignsGest(),
        '/profileGest': (context) => const ProfileGest(),
        '/profileObs': (context) => const ProfileObs(),
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
              //emailVerified permite reconocer que el inicio de sesión no es por una cuenta de Google (Gestante)
              return const ScreenObs();
            } else if (snapshot.hasData && snapshot.data!.emailVerified == true) {
              return const Tabs();
            } else {
              return const Start();
            }
          },
        ),
      );
}
