import 'package:celulas_vide/Lider/frequencia/frequencia_bloc.dart';
import 'package:celulas_vide/Lider/frequencia/frequencia_celula_form.dart';
import 'package:celulas_vide/Lider/frequencia/frequencia_culto_form.dart';
import 'package:celulas_vide/Model/frequencia_model.dart';
import 'package:celulas_vide/widgets/dialog_decision.dart';
import 'package:celulas_vide/widgets/empty_state.dart';
import 'package:celulas_vide/widgets/loading.dart';
import 'package:celulas_vide/widgets/state_error.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class FrequenciasTabView extends StatefulWidget {
  @override
  _FrequenciasTabViewState createState() => _FrequenciasTabViewState();
}

class _FrequenciasTabViewState extends State<FrequenciasTabView> {
  final _bloc = FrequenciaBloc();
  FrequenciaModel frequenciaModel;

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    _bloc.listenFrequencia();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text('Frequência dos Membros'),
          bottom: TabBar(
            tabs: [
              Tab(
                text: 'Célula',
              ),
              Tab(
                text: 'Culto',
              )
            ],
          ),
        ),
        body: StreamBuilder<FrequenciaModel>(
            stream: _bloc.streamFrequencia,
            builder: (context, snapshot) {
              if (snapshot.hasError)
                return stateError(context, snapshot.error);
              else if (snapshot.hasData) {
                frequenciaModel = snapshot.data;

                return TabBarView(
                  children: [
                    _itensCelula(),
                    _itensCulto(),
                  ],
                );
              } else
                return loadingProgress(title: 'Carregando frequências');
            }),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          backgroundColor: Theme.of(context).accentColor,
          onPressed: _showModalSheet,
        ),
      ),
    );
  }

  _itensCelula() {
    if (frequenciaModel.frequenciaCelula.isEmpty)
      return emptyState(context, 'Nenhuma frequência registrada ainda',
          Icons.bookmark_border);
    else
      return SingleChildScrollView(
        child: Column(
          children: frequenciaModel.frequenciaCelula
              .map((e) => Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    margin: EdgeInsets.only(left: 16, right: 16, top: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          leading: FaIcon(
                            FontAwesomeIcons.calendarAlt,
                            color: Theme.of(context).primaryColor,
                          ),
                          trailing: Icon(Icons.keyboard_arrow_right_rounded),
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Wrap(
                                children: [
                                  Text(
                                    'Data da célula: ',
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor),
                                  ),
                                  Text(DateFormat('dd/MM/yyyy')
                                      .format(e.dataCelula)),
                                ],
                              ),
                              Wrap(
                                children: [
                                  Text('Presença de membros: '),
                                  Text(e.membrosCelula
                                      .where((element) => element.frequenciaMembro)
                                      .toList()
                                      .length
                                      .toString()),
                                ],
                              ),
                              Text('Visitantes: ${e.quantidadeVisitantes} '),
                            ],
                          ),
                          onTap: () => onClickItemCelula(frequenciaModel.frequenciaCelula.indexOf(e)),
                        ),
                        Container(
                          height: 40,
                          alignment: Alignment.bottomLeft,
                          child: FlatButton.icon(
                            label: Text('Apagar', style: TextStyle(color: Theme.of(context).accentColor,),),
                            icon: Icon(Icons.delete, color: Theme.of(context).accentColor,),
                            onPressed: () => _onClickDeleteFrequence(frequenciaModel.frequenciaCelula.indexOf(e)),
                          ),
                        ),
                      ],
                    ),
                  ))
              .toList(),
        ),
      );
  }

  _itensCulto() {
    if (frequenciaModel.frequenciaCulto.isEmpty)
      return emptyState(context, 'Nenhuma frequência registrada ainda',
          Icons.bookmark_border);
    else
      return SingleChildScrollView(
        child: Column(
          children: frequenciaModel.frequenciaCulto
              .map((e) => Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    margin: EdgeInsets.only(left: 16, right: 16, top: 8),
                    child: ListTile(
                      leading: FaIcon(
                        FontAwesomeIcons.calendarAlt,
                        color: Theme.of(context).primaryColor,
                      ),
                      trailing: Icon(Icons.keyboard_arrow_right_rounded),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Wrap(
                            // crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Data do culto: ',
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor),
                              ),
                              Text(
                                  DateFormat('dd/MM/yyyy').format(e.dataCulto)),
                            ],
                          ),
                          Wrap(
                            children: [
                              Text('Presença de membros: '),
                              Text(e.membrosCulto
                                  .where((element) => element.frequenciaMembro)
                                  .toList()
                                  .length
                                  .toString()),
                            ],
                          ),
                        ],
                      ),
                      onTap: _onClickItemCulto,
                    ),
                  ))
              .toList(),
        ),
      );
  }

  void _onClickDeleteFrequence(int indexFrequencia) async {

    var result = await showDialogDecision(
      context,
      title: 'Apagar frequência',
      message: 'Esta ação não pode ser desfeita. Deseja realmente apagar esta frequência ?',
      icon: Icons.warning,
      colorIcon: Theme.of(context).accentColor
    );

    if(result != null){

      frequenciaModel.frequenciaCelula.removeAt(indexFrequencia);

      _bloc.apagarFrequencia(frequenciaModel.frequenciaCelula).then((_) {

        _showMessage('Frequencia apagada com sucesso');
      }).catchError((onError) {

        print('error saving frequence: ${onError.toString()}');
        _showMessage('Não foi possível apagar a frequência, tente novamente',
            isError: true);
      });
    }

  }

  void _onClickItemCulto() {}

  void onClickItemCelula(int indexFrequencia) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => FrequenciaCelulaForm(
                  frequenciaModel,
                  indexFrequencia: indexFrequencia,
                )));
  }

  _showModalSheet() {
    return showModalBottomSheet(
        isDismissible: true,
        enableDrag: false,
        context: context,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(20), topLeft: Radius.circular(20))),
        builder: (context) {
          return Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 10, bottom: 4),
                  child: Center(
                    child: Text('Registrar frequência de',
                        style: TextStyle(fontSize: 16)),
                  ),
                ),
                ListTile(
                    title: Text('Célula'),
                    leading: Icon(Icons.supervisor_account),
                    trailing: Icon(Icons.keyboard_arrow_right),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  FrequenciaCelulaForm(frequenciaModel)));
                    }),
                ListTile(
                    leading: FaIcon(FontAwesomeIcons.church),
                    title: Text('Culto'),
                    trailing: Icon(Icons.keyboard_arrow_right),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  FrequenciaCultoForm(frequenciaModel)));
                    })
              ],
            ),
          );
        });
  }

  _showMessage(String message, {bool isError = false}) {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(color: Colors.white),
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: isError ? Colors.red : Colors.blueGrey,
      ),
    );
  }


  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }
}
