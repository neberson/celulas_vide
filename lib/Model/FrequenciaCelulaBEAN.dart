
class Frequencia {

    DateTime dataFrequencia;
    List<Map> membrosFrequencia;
    double ofertaFrequencia;
    int quantidadeVisitantes;

    Frequencia(){
        membrosFrequencia = List<Map>();
    }

    Map<String, dynamic> toMapFrequencia(){
        Map<String, dynamic> map = {
            "dataCelula": this.dataFrequencia,
            "ofertaCelula": this.ofertaFrequencia,
            "quantidadeVisitantes": this.quantidadeVisitantes,
            "membrosCelula": this.membrosFrequencia
        };
        return map;
    }

    Map<String, dynamic> toMapCulto(){
        Map<String, dynamic> map = {
            "dataCulto": this.dataFrequencia,
            "membrosCulto": this.membrosFrequencia
        };
        return map;
    }


}