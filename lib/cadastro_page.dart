import 'package:celulas_vide/Controller/cadastrar_usuario.dart';
import 'package:celulas_vide/Lider/home_lider.dart';
import 'package:celulas_vide/Model/celula.dart';
import 'package:celulas_vide/widgets/margin.dart';
import 'package:celulas_vide/widgets/margin_setup.dart';
import 'package:flutter/material.dart';

class CadastroPage extends StatefulWidget {
  @override
  _CadastroPageState createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  CadastroUsuarioBloc cadastro = new CadastroUsuarioBloc();

  Usuario _user = new Usuario();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  List<String> _encargo = [
    'Lider',
    'Discipulador',
    'Pastor de Rede',
    'Pastor de Igreja',
    'Pastor Supervisor',
    'Presidente',
    'Denominação'
  ];
  String _encargoSelecionado;
  TextEditingController _controllerNome = TextEditingController();
  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerSenha = TextEditingController();
  TextEditingController _controllerConfirmarSenha = TextEditingController();
  bool _obscureText = true;
  int circularProgress = 0;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Cadastre-se"),
        backgroundColor: Color.fromRGBO(81, 37, 103, 1),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          children: <Widget>[
            Image.asset(
              "images/logo-01.png",
              width: 200,
              height: 150,
            ),
            Container(
              margin: marginStart,
              child: TextFormField(
                keyboardType: TextInputType.text,
                controller: _controllerNome,
                validator: (String text) =>
                    text.trim().isEmpty ? 'Informe o nome' : null,
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.person,
                    color: Colors.black26,
                  ),
                  hintText: "Digite seu nome",
                  labelText: 'Nome',
                  labelStyle: TextStyle(color: Theme.of(context).primaryColor),
                ),
              ),
            ),
            Container(
              margin: marginStart,
              child: TextFormField(
                validator: (String text) =>
                    text.trim().isEmpty ? 'Informe o e-mail' : null,
                controller: _controllerEmail,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.email,
                    color: Colors.black26,
                  ),
                  hintText: "Digite seu e-mail",
                  labelText: 'E-mail',
                  labelStyle: TextStyle(color: Theme.of(context).primaryColor),
                ),
              ),
            ),
            Container(
              margin: marginStart,
              child: TextFormField(
                controller: _controllerSenha,
                keyboardType: TextInputType.text,
                obscureText: _obscureText,
                validator: (String text) {
                  if (text.isEmpty)
                    return 'Informe a senha';
                  else if (text.length < 6)
                    return 'Informe no mínimo 6 caracteres';

                  return null;
                },
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.lock,
                    color: Colors.black26,
                  ),
                  suffixIcon: GestureDetector(
                    onTap: () {
                      if (_obscureText == true) {
                        setState(() {
                          _obscureText = false;
                        });
                      } else {
                        setState(() {
                          _obscureText = true;
                        });
                      }
                    },
                    child: _obscureText == true
                        ? Icon(
                            Icons.visibility_off,
                            color: Color.fromRGBO(81, 37, 103, 1),
                          )
                        : Icon(
                            Icons.visibility,
                            color: Color.fromRGBO(81, 37, 103, 1),
                          ),
                  ),
                  hintText: "Digite sua senha",
                  labelStyle: TextStyle(color: Theme.of(context).primaryColor),
                  labelText: 'Senha',
                ),
              ),
            ),
            Container(
              margin: marginStart,
              child: TextFormField(
                controller: _controllerConfirmarSenha,
                keyboardType: TextInputType.text,
                obscureText: _obscureText,
                validator: (String text) {
                  if (text.isEmpty)
                    return 'Confirme sua senha';
                  else if (text != _controllerSenha.text)
                    return 'A senhas não são iguais';

                  return null;
                },
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.lock,
                    color: Colors.black26,
                  ),
                  suffixIcon: GestureDetector(
                    onTap: () {
                      if (_obscureText == true) {
                        setState(() {
                          _obscureText = false;
                        });
                      } else {
                        setState(() {
                          _obscureText = true;
                        });
                      }
                    },
                    child: _obscureText == true
                        ? Icon(
                            Icons.visibility_off,
                            color: Color.fromRGBO(81, 37, 103, 1),
                          )
                        : Icon(
                            Icons.visibility,
                            color: Color.fromRGBO(81, 37, 103, 1),
                          ),
                  ),
                  hintText: "Confirme a sua senha",
                  labelStyle: TextStyle(color: Theme.of(context).primaryColor),
                  labelText: 'Confirmar senha',
                ),
              ),
            ),
            Container(
              margin: marginFieldStart,
              child: DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Selecione o encargo',
                  labelStyle: TextStyle(color: Theme.of(context).primaryColor),
                  isDense: true,
                ),
                validator: (value) =>
                    value == null ? 'Informe o encargo' : null,
                isExpanded: true,
                items: _encargo.map((String dropDownItem) {
                  return DropdownMenuItem<String>(
                    value: dropDownItem,
                    child: Text(dropDownItem),
                  );
                }).toList(),
                onChanged: (String valor) {
                  setState(() {
                    _encargoSelecionado = valor;
                  });
                },
                value: _encargoSelecionado,
              ),
            ),
            Container(
              margin: marginFieldStart,
              child: RaisedButton(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                color: Colors.pink,
                onPressed: _onClickCadastro,
                elevation: 11,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(40.0))),
                child: circularProgress == 0
                    ? Text("Cadastrar", style: TextStyle(color: Colors.white70))
                    : SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white70),
                          strokeWidth: 3.0,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _onClickCadastro() {
    if (_formKey.currentState.validate()) {
      setState(() {
        circularProgress = 1;
      });

      _user.nome = _controllerNome.text;
      _user.email = _controllerEmail.text;
      _user.encargo = _encargoSelecionado;

      cadastro
          .novoUsuario(
              _user, _controllerSenha.text, _controllerConfirmarSenha.text)
          .then((valor) {
        setState(() {
          circularProgress = 0;
        });
        if (valor == "cadastrado") {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => HomeLider()));
        } else {
          var snackBar = SnackBar(
            duration: Duration(seconds: 5),
            content: Text(valor),
          );

          _scaffoldKey.currentState.showSnackBar(snackBar);
        }
      });
    }
  }

  @override
  void dispose() {
    _controllerNome.dispose();
    _controllerEmail.dispose();
    _controllerSenha.dispose();
    _controllerConfirmarSenha.dispose();
    super.dispose();
  }
}
