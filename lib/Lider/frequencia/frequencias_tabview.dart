import 'package:celulas_vide/Lider/frequencia/frequencia_bloc.dart';
import 'package:celulas_vide/Model/frequencia_model.dart';
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

  bool isLoading = true;
  var error;

  @override
  void initState() {
    _bloc.getFrequencia().then((freq) {
      frequenciaModel = freq;

      setState(() => isLoading = false);
    }).catchError((onError) {
      print('error getting frequencia; ${onError.toString()}');
      error =
          'Não foi possível obter a frequência dos membros, tente novamente';

      setState(() => isLoading = false);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
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
        body: TabBarView(
          children: [_body(0), _body(1)],
        ),
      ),
    );
  }

  _body(int type) {
    if (isLoading)
      return loadingProgress(title: 'Carregando membros');
    else if (error != null) return stateError(context, error);

    if (type == 0)
      return _itensCelula();
    else
      return _itensCulto();
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
                      onTap: onClickItemCelula,
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

  void _onClickItemCulto() {}

  void onClickItemCelula() {}
}
