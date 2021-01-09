import 'package:celulas_vide/Lider/frequencia/frequencia_bloc.dart';
import 'package:celulas_vide/Lider/frequencia/store/list_membro_store.dart';
import 'package:celulas_vide/Lider/frequencia/store/membro_store.dart';
import 'package:celulas_vide/Model/celula.dart';
import 'package:celulas_vide/Model/frequencia_model.dart';
import 'package:celulas_vide/widgets/dialog_decision.dart';
import 'package:celulas_vide/widgets/loading.dart';
import 'package:celulas_vide/widgets/margin.dart';
import 'package:celulas_vide/widgets/state_error.dart';
import 'package:celulas_vide/widgets/textfield_custom.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';

class FrequenciaCultoForm extends StatefulWidget {
  final FrequenciaModel frequenciaModel;
  final int indexFrequencia;
  FrequenciaCultoForm(this.frequenciaModel, {this.indexFrequencia});

  @override
  _FrequenciaCultoFormState createState() => _FrequenciaCultoFormState();
}

class _FrequenciaCultoFormState extends State<FrequenciaCultoForm> {
  bool isLoading = true;
  bool loadingSave = false;
  bool canRecord = true;
  var error;
  Celula celula;

  FrequenciaModel get frequenciaModel => widget.frequenciaModel;
  int get indexFrequencia => widget.indexFrequencia;

  DateTime dateCulto;

  final _cDateCulto = TextEditingController();
  final _bloc = FrequenciaBloc();
  final membrosList = ListMembroStore();

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    if (indexFrequencia != null) {
      dateCulto = frequenciaModel.frequenciaCulto[indexFrequencia].dataCulto;
      _cDateCulto.text = DateFormat('dd/MM/yyyy').format(dateCulto);
      _fetchMembros();
    } else {
      DateTime currentMoment = DateTime(DateTime.now().year,
          DateTime.now().month, DateTime.now().day, 0, 0, 0);

      for (var element in frequenciaModel.frequenciaCulto) {
        DateTime date = DateTime(element.dataCulto.year,
            element.dataCulto.month, element.dataCulto.day, 0, 0, 0);

        if (date.isAtSameMomentAs(currentMoment)) {
          canRecord = false;
          break;
        }
      }

      if (canRecord) {
        dateCulto = DateTime.now();
        _cDateCulto.text = DateFormat('dd/MM/yyyy').format(dateCulto);
        getMembros();
      } else
        setState(() => isLoading = false);
    }

    super.initState();
  }

  _fetchMembros() {
    frequenciaModel.frequenciaCulto[indexFrequencia].membrosCulto
        .forEach((element) {
      var membroStore = MembroStore(
          condicaoMembro: element.condicaoMembro,
          nomeMembro: element.nomeMembro,
          status: element.status,
          frequenciaMembro: element.frequenciaMembro);

      membrosList.addMembrosList(membroStore);
    });

    setState(() => isLoading = false);
  }

  getMembros() {
    _bloc.getCelula().then((celula) {
      this.celula = celula;

      celula.membros.forEach((element) {
        var membroStore = MembroStore(
            condicaoMembro: element.condicaoMembro,
            nomeMembro: element.nomeMembro,
            status: element.status);

        membrosList.addMembrosList(membroStore);
      });

      setState(() => isLoading = false);
    }).catchError((onError) {
      print('error getting celula: ${onError.toString()}');

      error = 'Não foi possível obter os membros, tente novamente';

      setState(() => isLoading = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Wrap(
            children: [
              Text('Registrar Frequência de Culto'),
            ],
          ),
        ),
        body: isLoading
            ? loadingProgress()
            : error != null
                ? stateError(context, error)
                : _body());
  }

  _body() {
    if (!canRecord)
      return stateError(context,
          'Você já registrou a frequência de culto hoje, tente novamente amanhã',
          icon: Icons.bookmark_border);

    return SingleChildScrollView(
      child: Column(
        children: [
          TextFieldCustom(
            _cDateCulto,
            'Data do culto',
            readOnly: true,
            onTap: showDialogDate,
          ),
          Container(
            margin: EdgeInsets.only(top: 8),
            child: Text('Membros'),
          ),
          Column(
            children: membrosList.membros
                .map<Widget>((element) => _itemMembro(element))
                .toList(),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            width: double.infinity,
            margin: marginStart,
            height: 40,
            child: RaisedButton(
              color: Theme.of(context).accentColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              child: !loadingSave
                  ? Text(
                      'Salvar',
                      style: TextStyle(color: Colors.white),
                    )
                  : Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
              onPressed:
                  indexFrequencia != null ? _onClickEditar : _onClickSalvar,
            ),
          )
        ],
      ),
    );
  }

  _itemMembro(MembroStore membroStore) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.only(left: 16, right: 16, top: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ListTile(
        title: Text(
          membroStore.nomeMembro,
          style: TextStyle(color: Theme.of(context).primaryColor),
        ),
        subtitle: Text(membroStore.condicaoMembro),
        trailing: Observer(
          builder: (_) => Checkbox(
            value: membroStore.frequenciaMembro,
            onChanged: (value) => membroStore.setFrequenciaMembro(),
          ),
        ),
      ),
    );
  }

  showDialogDate() async {
    FocusScope.of(context).requestFocus(FocusNode());
    DateTime date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2001),
      lastDate: DateTime.now(),
      initialDatePickerMode: DatePickerMode.day,
      initialEntryMode: DatePickerEntryMode.calendar,
      builder: (BuildContext context, Widget child) => child,
    );

    if (date != null) {
      dateCulto = date;
      _cDateCulto.text = DateFormat('dd/MM/yyyy').format(date);
    }
  }

  _onClickSalvar() async {
    bool isEmpty = membrosList.membros
                .where((element) => !element.frequenciaMembro)
                .toList()
                .length ==
            membrosList.membros.length
        ? true
        : false;

    if (isEmpty) {
      var result = await showDialogDecision(
        context,
        title: 'Ausência de membros',
        message: 'Deseja registrar a frequência sem ninguém presente ?',
      );

      if (result != null) _saveFrequence();
    } else
      _saveFrequence();
  }

  _saveFrequence() {
    setState(() => loadingSave = true);

    var membrosFrequencia = <MembroFrequencia>[];

    membrosList.membros.forEach((element) {
      var membro = MembroFrequencia(
          status: element.status,
          nomeMembro: element.nomeMembro,
          condicaoMembro: element.condicaoMembro,
          frequenciaMembro: element.frequenciaMembro);

      membrosFrequencia.add(membro);
    });

    var frequenciaCulto = FrequenciaCulto(
      dataCulto: dateCulto,
      membrosCulto: membrosFrequencia,
    );

    _bloc.salvarFrequenciaCulto(frequenciaCulto).then((_) {
      setState(() => loadingSave = false);
      Navigator.pop(context);
    }).catchError((onError) {
      setState(() => loadingSave = false);

      print('error saving frequence: ${onError.toString()}');
      _showMessage('Não foi possível salvar a frequência, tente novamente',
          isError: true);
    });
  }

  _onClickEditar() async {
    bool isEmpty = membrosList.membros
                .where((element) => !element.frequenciaMembro)
                .toList()
                .length ==
            membrosList.membros.length
        ? true
        : false;

    if (isEmpty) {
      var result = await showDialogDecision(
        context,
        title: 'Ausência de membros',
        message: 'Deseja registrar a frequência sem ninguém presente ?',
      );

      if (result != null) _saveEdition();
    } else
      _saveEdition();
  }

  _saveEdition() {
    setState(() => loadingSave = true);

    var membrosFrequencia = <MembroFrequencia>[];

    membrosList.membros.forEach((element) {
      var membro = MembroFrequencia(
        status: element.status,
        nomeMembro: element.nomeMembro,
        condicaoMembro: element.condicaoMembro,
        frequenciaMembro: element.frequenciaMembro,
      );

      membrosFrequencia.add(membro);
    });

    var frequenciaCulto = FrequenciaCulto(
      dataCulto: dateCulto,
      membrosCulto: membrosFrequencia,
      idFrequenciaDia:
          frequenciaModel.frequenciaCulto[indexFrequencia].idFrequenciaDia,
    );

    frequenciaModel.frequenciaCulto[indexFrequencia] = frequenciaCulto;

    _bloc.editarFrequenciaCulto(frequenciaModel.frequenciaCulto).then((_) {
      setState(() => loadingSave = false);
      _showMessage('Frequencia alterada com sucesso');
    }).catchError((onError) {
      setState(() => loadingSave = false);

      print('error saving frequence: ${onError.toString()}');
      _showMessage('Não foi possível editar a frequência, tente novamente',
          isError: true);
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
    _cDateCulto.dispose();
    super.dispose();
  }
}
