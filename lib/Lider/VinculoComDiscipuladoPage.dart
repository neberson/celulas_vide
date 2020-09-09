
import 'package:flutter/material.dart';

class VinculoComDiscipuladoPage extends StatefulWidget {
  @override
  _VinculoComDiscipuladoPageState createState() =>
      _VinculoComDiscipuladoPageState();
}

class _VinculoComDiscipuladoPageState extends State<VinculoComDiscipuladoPage> {
  var _cEmail = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).accentColor,
      appBar: AppBar(
        title: Text('Solicitar acesso ao discipulado'),
        backgroundColor: Theme.of(context).accentColor,
      ),
      body: _body(),
    );
  }

  _body() {
    return Column(
      children: [
        Center(
          child: Container(
            margin: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 16),
            child: Text(
              'Olá, Informe o e-mail do discipulador para se conectar ao discipulado',
              style: TextStyle(color: Colors.white, fontSize: 18),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 15, right: 15, bottom: 15),
          child: TextFormField(
            controller: _cEmail,
            cursorColor: Colors.white,
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(
              color: Colors.white,
              decorationColor: Colors.white,
            ),
            decoration: InputDecoration(
              labelText: "E-mail",
              hintText: 'Digite o e-mail',
              hintStyle: TextStyle(color: Colors.white, fontSize: 15),
              labelStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold),
              fillColor: Colors.white,
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.white, width: 2.0),
                borderRadius: BorderRadius.circular(25.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.white, width: 2.0),
                borderRadius: BorderRadius.circular(25.0),
              ),
            ),
          ),
        ),
        Padding(
            padding:
                EdgeInsets.only(top: 25, left: 20, right: 20, bottom: 20),
            child: SizedBox(
              height: 50,
              width: MediaQuery.of(context).size.width,
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(40))),
                color: Colors.pink,
                child: Text(
                  "Solicitar",
                  style: TextStyle(color: Colors.white70, fontSize: 20),
                ),
                onPressed: _onClickSend,
              ),
            )),
      ],
    );
  }

  _onClickSend() {}
}
