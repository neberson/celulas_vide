import 'package:celulas_vide/Controller/loginUsuario.dart';
import 'package:celulas_vide/Model/CategoriaMenu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeLider extends StatefulWidget {
  @override
  _HomeLiderState createState() => _HomeLiderState();
}

class _HomeLiderState extends State<HomeLider> {

  final List<Categoria> categorias = [
    Categoria(9,"Perfil do Lider","/PerfilLider", icon: FontAwesomeIcons.user),
    Categoria(10,"Dados da Célula","/DadosCelula", icon: FontAwesomeIcons.globeAsia),
    Categoria(11,"Membros","/TabMembro", icon: FontAwesomeIcons.userFriends),
    Categoria(12,"Notificações","/VinculoDiscipulado", icon: FontAwesomeIcons.solidNewspaper),
    Categoria(13,"Presença","/frequenciaMembros", icon: FontAwesomeIcons.bookmark),
    Categoria(14,"Números da célula","/ReportsHome", icon: FontAwesomeIcons.calculator),
    //Categoria(14,"Eventos","/PerfilLider", icon: FontAwesomeIcons.list),
    //Categoria(14,"Sair","/logoff", icon: Icons.close)
  ];

  loginUsuario login = new loginUsuario();

  List<String> _itensMenu = ["Sair"];

  _escolhaMenuItem(String item){
    switch (item){
      case "Sair":
        login.logoff(context: context);
        break;
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              return _itensMenu.map((String item){
                return PopupMenuItem<String>(
                  value: item,
                  child: Text(item),
                );
              }).toList();
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
                        _buildCategoriaItem,
                        childCount: categorias.length,
                      ),
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

  Widget _buildCategoriaItem(BuildContext context, int index){
    Categoria categoria = categorias[index];

    return MaterialButton(
      elevation: 1.0,
      highlightElevation: 1.0,
      onPressed: (){
        if(categoria.nome == "Sair") {
          login.logoff(context: context);
        }else{
          Navigator.pushNamed(context, categoria.tela);
        }
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      color: categoria.nome == "Sair"? Color.fromRGBO(81, 37, 103, 1) : Colors.grey.shade800,
      textColor: Colors.white70,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          categoria.icon != null ? Icon(categoria.icon) : "",
          categoria.icon != null ? SizedBox(height: 5.0) : "",
          Text(
            categoria.nome,
            textAlign: TextAlign.center,
            maxLines: 3,),
        ],
      ),
    );
  }




}
