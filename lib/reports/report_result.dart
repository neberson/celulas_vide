import 'package:celulas_vide/Model/FrequenciaCelulaModel.dart';
import 'package:celulas_vide/reports/report_bloc.dart';
import 'package:celulas_vide/widgets/loading.dart';
import 'package:celulas_vide/widgets/state_error.dart';
import 'package:flutter/material.dart';

class ReportResult extends StatefulWidget {
  final title;
  DateTime dateStart;
  DateTime dateEnd;
  ReportResult({this.title, this.dateStart, this.dateEnd});

  @override
  _ReportResultState createState() => _ReportResultState();
}

class _ReportResultState extends State<ReportResult> {

  final reportBloc = ReportBloc();
  bool isLoading = true;
  var error;
  List<FrequenciaCelulaModel> listaFrequencia = [];

  @override
  void initState() {
    reportBloc.getFrequenciaMembros().then((list) {
      listaFrequencia = List.from(list);

      setState(() {
        isLoading = false;
      });
    }).catchError((onError){
      print('error getting frequencia membros: ${onError.toString()}');
      setState(() {
        error = 'Não foi possível obter a frequencia dos membros, tente novamente.';
        isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).backgroundColor,
        title: Text(widget.title),
      ),
      body: isLoading ? loading() : error != null ? stateError(context, error) : _body(),
    );
  }

  _body(){

  }
}
