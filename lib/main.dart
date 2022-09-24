import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:gest_app/layout/authentication/login_gest.dart';
import 'package:gest_app/layout/authentication/login_obs.dart';
import 'package:gest_app/layout/authentication/register_gest.dart';
import 'package:gest_app/layout/authentication/register_obs.dart';
import 'package:gest_app/layout/authentication/linkobs_gest.dart';
import 'package:gest_app/layout/authentication/vitalsigns_gest.dart';
import 'package:gest_app/layout/gest/tabs.dart';
import 'package:gest_app/layout/gest/acc_config/update_vitalsign.dart';
import 'package:gest_app/layout/profiles/profile_gest.dart';
import 'package:gest_app/layout/profiles/profile_obs.dart';
import 'package:gest_app/layout/start/start_page.dart';
import 'package:gest_app/layout/monitoring/monitoring_obstetra.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gest_app/utilities/designs.dart';

import 'layout/gest/acc_config/mi_obstetra.dart';

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
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: colorPrincipal,
          secondary: colorSecundario,
        ),
        textTheme: const TextTheme(
          bodyText2: TextStyle(color: Colors.black),
        ),
      ),
      initialRoute: MyHomePage.id,
      routes: {
        MyHomePage.id: (context) => const MyHomePage(),
        Tabs.id: (context) => const Tabs(),
        RegisterObs.id: (context) => const RegisterObs(),
        LoginObsWidget.id: (context) => const LoginObsWidget(),
        RegisterGest.id: (context) => const RegisterGest(),
        LoginGest.id: (context) => const LoginGest(),
        LinkObsGest.id: (context) => const LinkObsGest(),
        VitalSignsGest.id: (context) => const VitalSignsGest(),
        UpdateVitalSigns.id: (context) => const UpdateVitalSigns(),
        ProfileGest.id: (context) => const ProfileGest(),
        ProfileObs.id: (context) => const ProfileObs(),
        DatosObstetra.id: (context) => const DatosObstetra()
      },
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  static String id = '/';

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
