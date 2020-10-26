import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

import 'CallAPI.dart';
import 'Glob.dart';
import 'SelecaoEndereco.dart';
import 'auxiliar.dart';
import 'sqliteDao/mBipagem.dart';

class InventarioOperacao extends StatefulWidget {
  String sInvetarioID;
  String sEnderecoID;
  String sContagemAtual;
  String sEndereco;
  InventarioOperacao(
      this.sInvetarioID,
      this.sEnderecoID,
      this.sContagemAtual,
      this.sEndereco
      );
  @override
  _InventarioOperacaoState createState() => _InventarioOperacaoState();
}

class _InventarioOperacaoState extends State<InventarioOperacao> {

  String sQtdReturn="-";
  String _mensagemErro="";
  var focusNodeProduto = new FocusNode();
  var focusNodeQtd = new FocusNode();
  var focusNodeLote = new FocusNode();
  var focusNodeValdiade = new FocusNode();
  var focusNodeNumeroSerial = new FocusNode();
  var focusUnidadeMedida  = new FocusNode();
  TextEditingController _controllerCodigoProduto = TextEditingController();
  TextEditingController _controllerQtdProduto = TextEditingController();
  TextEditingController _controllerLote = TextEditingController();
  TextEditingController _controllerValidade = TextEditingController();
  TextEditingController _controllerNumeroSerial = TextEditingController();
  TextEditingController _controllerUnidadeMedida = TextEditingController();
  Color ColoMsg = Colors.black;
  Color ColoForm = Colors.green;

  startScanner() async
  {
    String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        "#ff6666", "Cancel", false, ScanMode.DEFAULT);

    setState(() {
      _controllerCodigoProduto.text=barcodeScanRes;
    });
    _inputBipagem();
  }
  _MsgAlertErro(String sMsg, bool isErro)
  {
    if(sMsg.length>30)
      sMsg = sMsg.substring(0,29);

    setState(() {
      _mensagemErro = sMsg +" "+ new auxiliar().getDateTimeNow();
      if(isErro)
      {
          ColoMsg = Colors.red;
          ColoForm = ColoMsg;
      }else{
        ColoMsg = Colors.green;
        ColoForm = ColoMsg;
      }
    });

  }
  _finalizarContagemSair() async
  {
    String sRet = await _finalizarContagem();
    print("@SYS SAIR 22");
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SelecaoEndereco(widget.sInvetarioID.trim(), sRet)),
    );
  }

  _finalizarContagem() async
  {
    try
    {
        var response = await CallAPI().finalizarEndereco(widget.sEnderecoID, Global.objUser.Token, Global.objUser.ID, widget.sInvetarioID.trim());

        if (response.statusCode.toString() == "200")
        {
          return null;
        }
        else if ( response.statusCode.toString() != "403") {
          return  "Ocorreu um erro na solicitação";
        }else{
          Map<String, dynamic> retorno = json.decode(response.body);
          return retorno["mensagem"].toString();
        }

    } on Exception catch (exception) {
      return "Ocorreu um erro  crítico na solicitação";
    } catch (error) {
      return "Ocorreu um erro crítico na solicitação";
    }
  }


  _inputBipagem() async
  {
    try{
        setState(() {
          _mensagemErro = "";
        });

        if(_controllerQtdProduto.text == "" )
        {
          _controllerQtdProduto.text="1";
        }

        mBipagem c = new mBipagem();
        c.codigoproduto=_controllerCodigoProduto.text.trim();
        c.contagem= int.parse(widget.sContagemAtual);
        c.enderecoid =int.parse(widget.sEnderecoID);
        c.inventarioid = int.parse(widget.sInvetarioID.trim());
        c.lote=_controllerLote.text.trim();
        c.qtd = int.parse(_controllerQtdProduto.text);
        c.serie = _controllerNumeroSerial.text.trim();
        c.ua = null;
        c.unidadeMedida = _controllerUnidadeMedida.text.trim();
        c.userID = int.parse(Global.objUser.ID);
        c.validade=null;

        var mapBipag = c.toJson();
        var jsonz = json.encode(mapBipag);
        // print("@SYS aqui" + jsonz);
        var response = await CallAPI().biparIntem(jsonz, Global.objUser.Token);

        if (response.statusCode.toString() == "500") {
            _MsgAlertErro("Erro",true);
          return;
        }

        if (response.statusCode.toString() == "401") {
          _MsgAlertErro("Acesso não autorizado",true);
           return;
        }

        if (response.statusCode.toString() != "200" && response.statusCode.toString() != "403") {
          _MsgAlertErro("Busca apresentou inconsistência",true);
          return;
        }

        Map<String, dynamic> retorno = json.decode(response.body);
        if (response.statusCode.toString() == "403") {
          _MsgAlertErro(retorno["mensagem"].toString(),true);
          if(retorno["pendencia"] != null && retorno["pendencia"].toString().length>1)
            _focusPendencia(retorno["pendencia"].toString().toUpperCase());
          return;
        }


        _MsgAlertErro(retorno["mensagem"].toString(),false);
        setState(() {
          sQtdReturn = retorno["qtdbipada"].toString();
          focusNodeProduto.requestFocus();
        });
    } on Exception catch (exception) {
      _MsgAlertErro(exception.toString(),true);
      setState(() {
        ColoForm = Colors.red;
      });
    } catch (error) {
      _MsgAlertErro(error.toString(),true);
      setState(() {
        ColoForm = Colors.red;
      });
    }

  }

  _focusPendencia(String sPendencia)
  {
    setState(() {
      ColoForm = Colors.orange;
      if(sPendencia == "UNIDADEMEDIDA")
      {
        focusUnidadeMedida.requestFocus();
      }
      else if(sPendencia == "LOTE")
      {
        focusNodeLote.requestFocus();
      }
      else if(sPendencia == "SERIE")
      {
        focusNodeNumeroSerial.requestFocus();
      }
      else if(sPendencia == "VALIDADE")
      {
        focusNodeValdiade.requestFocus();
      }
    });

  }

  _voltarForm()
  {
    // BuildContext dialogContext;
    showDialog(
      context: context,
      builder: (context) => new AlertDialog(

        title: new Text('O que deseja fazer?'),
       // content: new Text('O que deseja fazer?'),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 1),
            child: Center(
              child:  new FlatButton(
                onPressed: () {

                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SelecaoEndereco(widget.sInvetarioID.trim(),null)),
                  );
                },
                child: new Text('Sair e NÃO finalizar a contagem.'),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 30),
            child: Center(
              child:  new FlatButton(
                onPressed: () {
                  _finalizarContagemSair();
                },
                child: new Text('Sair e finalizar a contagem.'),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 30),
            child: Center(
              child:  new FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: new Text('Não desejo sair.'),
              ),
            ),
          )
        ],
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: () async {
        _voltarForm();
        return false;
      },
      child: Scaffold(
        // resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text("I: ${widget.sInvetarioID} C: ${widget.sContagemAtual}-${widget.sEndereco}"),
          backgroundColor: ColoForm,
          actions: [],

        ),
        body:  SingleChildScrollView(
          child: Container(
            //  constraints: BoxConstraints(minWidth: 100, maxWidth: 100),
            padding: EdgeInsets.all(20),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 5, bottom: 5),
                  child: RaisedButton(
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.camera)
                      ],

                    ),
                    color: Colors.orange,
                    // padding: EdgeInsets.fromLTRB(32, 16, 32, 30),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32)
                    ),
                    onPressed: (){
                      startScanner();
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 1),
                  child: Center(
                    child: Text(
                      _mensagemErro,
                      style: TextStyle(
                          color: ColoMsg,
                          fontSize: 15
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 1),
                  child: Center(
                    child: Text(
                      "Qtd: " + sQtdReturn,
                      style: TextStyle(
                          color: ColoMsg,
                          fontSize: 12
                      ),
                    ),
                  ),
                ),
                TextField(
                  autofocus: true,
                  focusNode: focusNodeProduto,
                  controller: _controllerCodigoProduto,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      labelText: "Código do Produto"
                  ),
                  onSubmitted: (String value){
                    _inputBipagem();
                  },
                ),
                TextField(
                  focusNode: focusNodeQtd,
                  controller: _controllerQtdProduto,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly,
                    //   FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  ],
                  decoration: InputDecoration(
                      labelText: "Quantidade"
                  ),
                  onSubmitted: (String value){
                    _inputBipagem();
                  },
                ),
                TextField(
                  focusNode: focusUnidadeMedida,
                  controller: _controllerUnidadeMedida,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      labelText: "Unidade de medida"
                  ),
                  onSubmitted: (String value){
                    _inputBipagem();
                  },
                ),
                TextField(
                  focusNode: focusNodeNumeroSerial,
                  controller: _controllerNumeroSerial,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      labelText: "Número serial"
                  ),
                  onSubmitted: (String value){
                    _inputBipagem();
                  },
                ),
                TextField(
                  focusNode: focusNodeLote,
                  controller: _controllerLote,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      labelText: "Lote"
                  ),
                  onSubmitted: (String value){
                    _inputBipagem();
                  },
                ),
                TextField(
                  focusNode: focusNodeValdiade,
                  controller: _controllerValidade,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      labelText: "Validade"
                  ),
                  onSubmitted: (String value){
                    _inputBipagem();
                  },
                ),
                Padding(
                  padding: EdgeInsets.only(top: 16, bottom: 10),
                  child: RaisedButton(
                    child: Text(
                      "Processar",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    color: Colors.orange,
                    padding: EdgeInsets.fromLTRB(32, 16, 32, 30),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32)
                    ),
                    onPressed: (){
                      _inputBipagem();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      )
    );
  }
}
