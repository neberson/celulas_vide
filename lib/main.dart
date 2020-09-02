
import 'package:celulas_vide/Controller/loginUsuario.dart';
import 'package:celulas_vide/Lider/DadosCelula.dart';
import 'package:celulas_vide/Lider/DadosMembro.dart';
import 'package:celulas_vide/Lider/HomeLider.dart';
import 'package:celulas_vide/Lider/ListaMembros.dart';
import 'package:celulas_vide/Lider/PerfilLider.dart';
import 'package:celulas_vide/Lider/TabMembros.dart';
import 'package:celulas_vide/Lider/frequenciaMembros.dart';
import 'package:celulas_vide/Tela_login.dart';
import 'package:celulas_vide/reports/reports_home.dart';
import 'package:celulas_vide/splashScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';


void main()  {

  WidgetsFlutterBinding.ensureInitialized();


  loginUsuario login = new loginUsuario();


  runApp(
      MaterialApp(
        theme: ThemeData(
          primaryColor: Color.fromRGBO(81, 37, 0, 1),
          accentColor: Color.fromRGBO(81, 37, 103, 1),
          backgroundColor: Color.fromRGBO(81, 37, 103, 1),
        ),
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: [
          Locale("pt")
        ],
        initialRoute: '/',
        routes: {
          '/': (context) => splash(),
          '/Login': (context) => Tela_login(),
          '/HomeLider': (context) => HomeLider(),
          '/PerfilLider': (context) => PerfilLider(),
          '/ListaMembros': (context) => ListaMembros(),
          '/DadosMembro':(context) => DadosMembro(),
          '/DadosCelula': (context) => DadosCelula(),
          '/frequenciaMembros': (context) => frequenciaMembros(),
          '/TabMembro': (context) => TabMembro(),
          '/ReportsHome': (context) => ReportsHome()
        },

        debugShowCheckedModeBanner: false,
      )
  );
}