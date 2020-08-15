
class Frequencia {

    String _dataFrequencia;
    List<Map> _MembrosFrequencia;
    double _ofertaFrequencia;
    int _quantidadeVisitantes;

    Frequencia(){
        _MembrosFrequencia = List<Map>();
    }

    Map<String, dynamic> toMapFrequencia(){
        Map<String, dynamic> map = {
            "dataCelula": this.dataFrequencia,
            "ofertaCelula": this.ofertaFrequencia,
            "quantidadeVisitantes": this.quantidadeVisitantes,
            "membrosCelula": this.MembrosFrequencia
        };
        return map;
    }

    Map<String, dynamic> toMapCulto(){
        Map<String, dynamic> map = {
            "dataCulto": this.dataFrequencia,
            "membrosCulto": this.MembrosFrequencia
        };
        return map;
    }

    int get quantidadeVisitantes => _quantidadeVisitantes;

    set quantidadeVisitantes(int value) {
        _quantidadeVisitantes = value;
    }

    double get ofertaFrequencia => _ofertaFrequencia;

    set ofertaFrequencia(double value) {
        _ofertaFrequencia = value;
    }

    List<Map> get MembrosFrequencia => _MembrosFrequencia;

    set MembrosFrequencia(List<Map> value) {
        _MembrosFrequencia = value;
    }

    String get dataFrequencia => _dataFrequencia;

    set dataFrequencia(String value) {
        _dataFrequencia = value;
    }


}