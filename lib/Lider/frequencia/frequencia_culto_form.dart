import 'package:celulas_vide/Model/frequencia_model.dart';
import 'package:flutter/material.dart';

class FrequenciaCultoForm extends StatefulWidget {
  final FrequenciaModel frequenciaModel;
  FrequenciaCultoForm(this.frequenciaModel);

  @override
  _FrequenciaCultoFormState createState() => _FrequenciaCultoFormState();
}

class _FrequenciaCultoFormState extends State<FrequenciaCultoForm> {
  bool isLoading = true;
  bool canRecord = true;
  FrequenciaModel get frequenciaModel => widget.frequenciaModel;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Wrap(
            children: [
              Text('Registrar Frequencia de Culto'),
            ],
          ),
        ),
        body: _body()
    );
  }

  _body() {
    return Container();
  }
}
