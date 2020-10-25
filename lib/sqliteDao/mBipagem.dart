import 'dart:ffi';

class mBipagem
{
  String codigoproduto;
  int contagem;
  int enderecoid;
  int inventarioid;
  String lote;
  int qtd;
  String serie;
  String ua;
  String unidadeMedida;
  int userID;
  String validade;

  mBipagem(
      {this.codigoproduto,
        this.contagem,
        this.enderecoid,
        this.inventarioid,
        this.lote,
        this.qtd,
        this.serie,
        this.ua,
        this.unidadeMedida,
        this.userID,
        this.validade});

  mBipagem.fromJson(Map<String, dynamic> json) {
    codigoproduto = json['codigoproduto'];
    contagem = json['contagem'];
    enderecoid = json['enderecoid'];
    inventarioid = json['inventarioid'];
    lote = json['lote'];
    qtd = json['qtd'];
    serie = json['serie'];
    ua = json['ua'];
    unidadeMedida = json['unidadeMedida'];
    userID = json['userID'];
    validade = json['validade'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['codigoproduto'] = this.codigoproduto;
    data['contagem'] = this.contagem;
    data['enderecoid'] = this.enderecoid;
    data['inventarioid'] = this.inventarioid;
    data['lote'] = this.lote;
    data['qtd'] = this.qtd;
    data['serie'] = this.serie;
    data['ua'] = this.ua;
    data['unidadeMedida'] = this.unidadeMedida;
    data['userID'] = this.userID;
    data['validade'] = this.validade;
    return data;
  }



}