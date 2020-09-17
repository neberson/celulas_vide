import 'package:celulas_vide/Model/DadosMembroCelulaBEAN.dart';
import 'package:celulas_vide/reports/report_bloc.dart';
import 'package:celulas_vide/widgets/empty_state.dart';
import 'package:celulas_vide/widgets/loading.dart';
import 'package:celulas_vide/widgets/state_error.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReportNominalPage extends StatefulWidget {
  final titleAppBar;
  ReportNominalPage(this.titleAppBar);

  @override
  _ReportNominalPageState createState() => _ReportNominalPageState();
}

class _ReportNominalPageState extends State<ReportNominalPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  final reportBloc = ReportBloc();
  bool isLoading = true;
  var error;

  List<MembrosCelula> _listMembrosAtivos = [];
  List<MembrosCelula> _listMembrosInativos = [];

  @override
  void initState() {
    reportBloc.getMember().then((membros) {
      _listMembrosAtivos =
          membros.where((element) => element.status == 0).toList();
      _listMembrosInativos =
          membros.where((element) => element.status == 1).toList();

      setState(() => isLoading = false);
    }).catchError((onError) {
      print('error geting membros da celula: ${onError.toString()}');
      setState(() {
        error = 'Não foi possível obter os membros da célula, tente novamente';
        isLoading = false;
      });
      _showMessage('Erro ao obter membros da célula, tente novamente',
          isError: true);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          title: Text(widget.titleAppBar),
          backgroundColor: Theme.of(context).accentColor,
          bottom: TabBar(
            tabs: [
              Tab(
                child: Text('Ativos'),
              ),
              Tab(
                child: Text('Inativos'),
              )
            ],
          ),
        ),
        body: isLoading
            ? loading()
            : error != null ? stateError(context, error) : TabBarView(children: [
                _tableAtivos(_listMembrosAtivos),
                _tableAtivos(_listMembrosInativos)
              ]),
      ),
    );
  }

  _tableAtivos(List<MembrosCelula> list) {
    if (list.isEmpty)
      return emptyState(
          context, 'Nenhum membro ativo por enquanto', Icons.person);

    var styleTitle =
        TextStyle(fontWeight: FontWeight.bold, color: Colors.black);

    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            color: Theme.of(context).accentColor.withAlpha(80),
            margin: EdgeInsets.only(left: 8, right: 8, top: 16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: [
                  DataColumn(
                      label: Text(
                    'Nome',
                    style: styleTitle,
                  )),
                  DataColumn(
                      label: Text(
                    'Gênero',
                    style: styleTitle,
                  )),
                  DataColumn(
                      label: Text(
                    'Classificação',
                    style: styleTitle,
                  )),
                  DataColumn(
                      label: Text(
                    'Telefone',
                    style: styleTitle,
                  )),
                  DataColumn(
                      label: Text(
                    'Data nascimento',
                    style: styleTitle,
                  )),
                ],
                rows: list
                    .map(
                      (e) => DataRow(
                        cells: [
                          DataCell(
                            Text(e.nomeMembro.toUpperCase()),
                          ),
                          DataCell(
                            Text(e.generoMembro.toUpperCase()),
                          ),
                          DataCell(
                            Text(e.condicaoMembro),
                          ),
                          DataCell(
                            Text(e.telefoneMembro),
                          ),
                          DataCell(
                            Text(e.dataNascimentoMembro != null ? DateFormat('dd/MM/yyyy')
                                .format(e.dataNascimentoMembro) : ''),
                          ),
                        ],
                      ),
                    )
                    .toList(),
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
                    "Gerar PDF",
                    style: TextStyle(color: Colors.white70, fontSize: 20),
                  ),
                  onPressed: () {},
                ),
              )),
        ],
      ),
    );
  }

  _showMessage(String message, {bool isError = false}) =>
      scaffoldKey?.currentState?.showSnackBar(SnackBar(
        content: Text(message),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        behavior: SnackBarBehavior.floating,
        backgroundColor: isError ? Colors.red : Colors.green[700],
      ));
}
