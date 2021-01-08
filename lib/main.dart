
import 'package:celulas_vide/Discipulador/membros_discipulador.dart';
import 'package:celulas_vide/Discipulador/convites_page.dart';
import 'package:celulas_vide/Discipulador/perfil_discipulador.dart';
import 'package:celulas_vide/Lider/dados_celula.dart';
import 'package:celulas_vide/Lider/dados_membro.dart';
import 'package:celulas_vide/Lider/frequencia/frequencias_tabview.dart';
import 'package:celulas_vide/Lider/gerenciar_convites.dart';
import 'package:celulas_vide/Lider/lista_membros.dart';
import 'package:celulas_vide/Lider/perfil_lider.dart';
import 'package:celulas_vide/Lider/tab_membros.dart';
import 'package:celulas_vide/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';


void main()  {

  WidgetsFlutterBinding.ensureInitialized();

  runApp(
      MaterialApp(
        theme: ThemeData(
          primaryColor: Color.fromRGBO(81, 37, 103, 1),
          accentColor: Colors.pink,
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
          Locale('pt', 'BR')
        ],
        initialRoute: '/',
        routes: {
          '/': (context) => LoginPage(),
          '/PerfilLider': (context) => PerfilLider(),
          '/ListaMembros': (context) => ListaMembros(),
          '/DadosMembro':(context) => DadosMembro(),
          '/DadosCelula': (context) => DadosCelula(),
          '/frequenciasTabView': (context) => FrequenciasTabView(),
          '/TabMembro': (context) => TabMembro(),
          '/VinculoDiscipulado': (context) => GerenciarConvitePage(),
          '/PerfilDiscipulador': (context) => PerfilDiscipulador(),
          '/ConvitesDiscipulador': (context) => ConvitesDiscipulador(),
          '/MembrosDiscipulador': (context) => MembrosDiscipulador(),
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