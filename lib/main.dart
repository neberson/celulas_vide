
import 'package:celulas_vide/Discipulador/perfil_discipulador.dart';
import 'package:celulas_vide/Lider/DadosCelula.dart';
import 'package:celulas_vide/Lider/DadosMembro.dart';
import 'package:celulas_vide/Lider/HomeLider.dart';
import 'package:celulas_vide/Lider/ListaMembros.dart';
import 'package:celulas_vide/Lider/PerfilLider.dart';
import 'package:celulas_vide/Lider/TabMembros.dart';
import 'package:celulas_vide/Lider/VinculoComDiscipuladoPage.dart';
import 'package:celulas_vide/Lider/frequenciaMembros.dart';
import 'package:celulas_vide/Tela_login.dart';
import 'package:celulas_vide/reports/report_home.dart';
import 'package:celulas_vide/splashScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';


void main()  {

  WidgetsFlutterBinding.ensureInitialized();

  runApp(
      MaterialApp(
        theme: ThemeData(
          primaryColor: Color.fromRGBO(81, 37, 0, 1),
          accentColor: Color.fromRGBO(81, 37, 103, 1),
          backgroundColor: Color.fromRGBO(81, 37, 103, 1),
          primarySwatch: createMaterialColor (Color.fromRGBO(81, 37, 103, 1)),
          appBarTheme: AppBarTheme(
            color: Color.fromRGBO(81, 37, 103, 1)
          )
        ),
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale('pt', 'BR')
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
          '/ReportsHome': (context) => ReportHome(),
          '/VinculoDiscipulado': (context) => VinculoComDiscipuladoPage(),
          '/PerfilDiscipulador': (context) => PerfilDiscipulador(),
        },

        debugShowCheckedModeBanner: false,
      )
  );
}

MaterialColor createMaterialColor(Color color) {
  List strengths = <double>[.05];
  Map swatch = <int, Color>{};
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  strengths.forEach((strength) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  });
  return MaterialColor(color.value, swatch);
}