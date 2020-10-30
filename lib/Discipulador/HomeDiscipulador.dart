import 'package:celulas_vide/Controller/loginUsuario.dart';
import 'package:celulas_vide/Model/CategoriaMenu.dart';
import 'package:celulas_vide/reports/report_home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeDiscipulador extends StatefulWidget {
  @override
  _HomeDiscipuladorState createState() => _HomeDiscipuladorState();
}

class _HomeDiscipuladorState extends State<HomeDiscipulador> {

  final _loginUsuario = LoginUsuario();

  final List<Categoria> categoriasDiscipulador = [
    Categoria("Perfil do Discipulador","/PerfilDiscipulador", icone: FontAwesomeIcons.user),
    Categoria("Dados das Células","/PerfilDiscipulador", icone: FontAwesomeIcons.globeAsia),
    Categoria("Membros","/MembrosDiscipulador", icone: FontAwesomeIcons.users),
    Categoria("Convites","/ConvitesDiscipulador", icone: FontAwesomeIcons.envelope),
    Categoria("Números da célula","/ReportsHome", icone: FontAwesomeIcons.calculator),
  ];

  _escolhaMenuItem(String item) {
    _loginUsuario.logoff();
    Navigator.pushReplacementNamed(context, '/');
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Color.fromRGBO(81, 37, 103, 1),
          title: Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 1),
                child: Image.asset(
                  'images/logo_branco_sem_texto.png',
                  fit: BoxFit.contain,
                  height: 50,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8.0),
                child: Text('CÉLULAS VIDE'),
              )
            ],
          ),
          elevation: 0,
          actions: <Widget>[
            PopupMenuButton<String>(
              onSelected: _escolhaMenuItem,
              itemBuilder: (context){
                return [
                  PopupMenuItem<String>(
                    value: 'Sair',
                    child: Text('Sair'),
                  )
                ];
              },
            )
          ],
        ),
        body: OrientationBuilder(
          builder: (context, orientation){
            return Stack(
              children: <Widget>[
                ClipPath(
                  clipper: WaveClipperTwo(),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(81, 37, 103, 1)
                    ),
                    height: 200,
                  ),
                ),
                CustomScrollView(
                  physics: BouncingScrollPhysics(),
                  slivers: <Widget>[
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0,vertical: 8.0),
                        child: Text("Bem vindo ao App CélulasVide, o seu Administrador de Células!", style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 16.0
                        ),),
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.all(16.0),
                      sliver: SliverGrid(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: orientation == Orientation.portrait? 2 : 3,
                            childAspectRatio: 1.2,
                            crossAxisSpacing: 10.0,
                            mainAxisSpacing: 10.0
                        ),
                        delegate: SliverChildBuilderDelegate(
                              (context, index) =>
                              _buildCategoriaItem(categoriasDiscipulador[index]),
                          childCount: categoriasDiscipulador.length,
                        ),
                      ),
                    )
                  ],
                )
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildCategoriaItem(Categoria categoria){

    return MaterialButton(
      elevation: 1.0,
      highlightElevation: 1.0,
      onPressed: () => _onClickCategoria(categoria),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      color: categoria.nome == "Sair"? Color.fromRGBO(81, 37, 103, 1) : Colors.grey.shade800,
      textColor: Colors.white70,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          categoria.icone != null ? Icon(categoria.icone) : "",
          categoria.icone != null ? SizedBox(height: 5.0) : "",
          Text(
            categoria.nome,
            textAlign: TextAlign.center,
            maxLines: 3,),
        ],
      ),
    );
  }

  _onClickCategoria(Categoria categoria){

    if(categoria.rota == '/ReportsHome')
      Navigator.push(context, MaterialPageRoute(builder: (context) => ReportHome(encargo: 'Lider',)));
    else
      Navigator.pushNamed(context, categoria.rota);

  }



}
