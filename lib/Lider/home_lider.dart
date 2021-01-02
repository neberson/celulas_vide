import 'package:celulas_vide/Controller/login_usuario.dart';
import 'package:celulas_vide/Model/categoria_menu.dart';
import 'package:celulas_vide/relatorios/relatorio_home.dart';
import 'package:celulas_vide/widgets/dialog_decision.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeLider extends StatefulWidget {
  final String encargo;

  HomeLider({this.encargo});

  @override
  _HomeLiderState createState() => _HomeLiderState();
}

class _HomeLiderState extends State<HomeLider> {
  final _loginUsuario = LoginUsuario();

  final List<Categoria> categoriasLider = [
    Categoria("Perfil do Lider", "/PerfilLider", icone: FontAwesomeIcons.user),
    Categoria("Dados da Célula", "/DadosCelula", icone: FontAwesomeIcons.info),
    Categoria("Membros", "/TabMembro", icone: FontAwesomeIcons.userFriends),
    Categoria("Convites", "/VinculoDiscipulado",
        icone: FontAwesomeIcons.envelope),
    Categoria("Presença", "/frequenciaMembros",
        icone: FontAwesomeIcons.bookmark),
    Categoria("Relatórios", "/ReportsHome", icone: FontAwesomeIcons.calculator),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color.fromRGBO(81, 37, 103, 1),
        title: Row(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 16),
              child: Image.asset(
                'images/logo_branco_sem_texto.png',
                fit: BoxFit.contain,
                height: 50,
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              child: Text('CÉLULAS VIDE'),
            )
          ],
        ),
        elevation: 0,
        actions: <Widget>[
          IconButton(
            icon: FaIcon(FontAwesomeIcons.signOutAlt),
            onPressed: _onClickLogout,
          )
        ],
      ),
      body: OrientationBuilder(
        builder: (context, orientation) {
          return Stack(
            children: <Widget>[
              ClipPath(
                clipper: WaveClipperTwo(),
                child: Container(
                  decoration:
                      BoxDecoration(color: Color.fromRGBO(81, 37, 103, 1)),
                  height: 200,
                ),
              ),
              CustomScrollView(
                physics: BouncingScrollPhysics(),
                slivers: <Widget>[
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8.0),
                      child: Text(
                        "Bem vindo ao App CélulasVide, o seu Administrador de Células!",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 16.0),
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.all(16.0),
                    sliver: SliverGrid(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount:
                              orientation == Orientation.portrait ? 2 : 3,
                          childAspectRatio: 1.2,
                          crossAxisSpacing: 10.0,
                          mainAxisSpacing: 10.0),
                      delegate: SliverChildBuilderDelegate(
                          (context, index) =>
                              _buildCategoriaItem(categoriasLider[index]),
                          childCount: categoriasLider.length),
                    ),
                  )
                ],
              )
            ],
          );
        },
      ),
    );
  }

  _onClickLogout() async {
    var result = await showDialogDecision(context,
        message: 'Deseja realmente sair do aplicativo ?',
        icon: Icons.info,
        title: 'Sair');

    if (result != null) {
      _loginUsuario.logoff();
      Navigator.pushReplacementNamed(context, '/');
    }
  }

  _buildCategoriaItem(Categoria categoria) {
    return MaterialButton(
      elevation: 1.0,
      highlightElevation: 1.0,
      onPressed: () => _onClickCategoria(categoria),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      color: Colors.grey.shade800,
      textColor: Colors.white70,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(categoria.icone),
          SizedBox(height: 5.0),
          Text(
            categoria.nome,
            textAlign: TextAlign.center,
            maxLines: 3,
          ),
        ],
      ),
    );
  }

  _onClickCategoria(Categoria categoria) {
    if (categoria.rota == '/ReportsHome')
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => RelatorioHome(
                    encargo: 'Lider',
                  )));
    else
      Navigator.pushNamed(context, categoria.rota);
  }
}
