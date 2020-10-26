import 'package:celulas_vide/Model/Celula.dart';
import 'package:celulas_vide/reports/pdf_generate.dart';
import 'package:celulas_vide/reports/pdf_viewer.dart';
import 'package:celulas_vide/reports/report_bloc.dart';
import 'package:celulas_vide/widgets/empty_state.dart';
import 'package:celulas_vide/widgets/loading.dart';
import 'package:celulas_vide/widgets/state_error.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReportNominal extends StatefulWidget {
  final titleAppBar;
  ReportNominal(this.titleAppBar);

  @override
  _ReportNominalState createState() => _ReportNominalState();
}

class _ReportNominalState extends State<ReportNominal> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  final reportBloc = ReportBloc();
  bool isLoading = true;
  var error;

  Celula celula;
  List<MembroCelula> _listMembrosAtivos = [];
  List<MembroCelula> _listMembrosInativos = [];

  @override
  void initState() {
    reportBloc.getCelula().then((celula) {
      this.celula = celula;
      _listMembrosAtivos =
          celula.membros.where((element) => element.status == 0).toList();
      _listMembrosInativos =
          celula.membros.where((element) => element.status == 1).toList();

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
            : error != null
                ? stateError(context, error)
                : TabBarView(children: [
                    _tableMembers(_listMembrosAtivos, 0),
                    _tableMembers(_listMembrosInativos, 1)
                  ]),
      ),
    );
  }

  _tableMembers(List<MembroCelula> list, int type) {
    if (list.isEmpty)
      return emptyState(
          context, 'Nenhum membro encontrado com esse status', Icons.person);

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
                            Text(e.dataNascimentoMembro != null
                                ? DateFormat('dd/MM/yyyy')
                                    .format(e.dataNascimentoMembro)
                                : ''),
                          ),
                        ],
                      ),
                    ).toList(),
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
                  onPressed: () => _onClickGenerate(list, type),
                ),
              )),
        ],
      ),
    );
  }

  _onClickGenerate(listMembers, int type) async {
    var listColumns = [
      'Nome',
      'Gênero',
      'Classificação',
      'Telefone',
      'Data nascimento'
    ];

    String subtitle =
        '${DateFormat.yMMMMd('pt').format(DateTime.now())} - Membros ${type == 0 ? 'Ativos' : 'Inativos'}';

    String path = await generatePdf(listMembers, listColumns,
        'Relatório Nominal Membros de Célula', subtitle, celula, 'relatorio_nominal_membros.pdf');

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PdfViewerPage(path: path),
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
