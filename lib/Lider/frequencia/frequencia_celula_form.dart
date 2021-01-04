import 'package:celulas_vide/Model/frequencia_model.dart';
import 'package:celulas_vide/widgets/loading.dart';
import 'package:celulas_vide/widgets/state_error.dart';
import 'package:flutter/material.dart';

class FrequenciaCelulaForm extends StatefulWidget {
  FrequenciaModel frequenciaModel;
  FrequenciaCelulaForm(this.frequenciaModel);

  @override
  _FrequenciaCelulaFormState createState() => _FrequenciaCelulaFormState();
}

class _FrequenciaCelulaFormState extends State<FrequenciaCelulaForm> {
  bool isLoading = true;
  bool canRecord = true;
  FrequenciaModel get frequenciaModel => widget.frequenciaModel;

  @override
  void initState() {
    DateTime moment = DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day, 0, 0, 0);

    for (var element in frequenciaModel.frequenciaCelula) {
      DateTime date = DateTime(element.dataCelula.year,
          element.dataCelula.month, element.dataCelula.day, 0, 0, 0);

      if (date.isAtSameMomentAs(moment)) {
        canRecord = false;
        break;
      }
    }

    setState(() {
      isLoading = false;
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            title: Wrap(
              children: [
                Text('Registrar Frequência de Célula'),
              ],
            ),
          ),
          body: isLoading ? loadingProgress() : _body()),
    );
  }

  _body() {
    if (!canRecord)
      return stateError(context,
          'Você já registrou a frequência de célula hoje, tente novamente amanhã');

    return Container(
      child: Center(
        child: Text('Registre aqui a frequencia'),
      ),
    );
  }
}
