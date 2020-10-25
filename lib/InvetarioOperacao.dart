import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

import 'Glob.dart';
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

  var focusNodeProduto = new FocusNode();
  var focusNodeQtd = new FocusNode();
  var focusNodeLote = new FocusNode();
  var focusNodeValdiade = new FocusNode();
  var focusNodeNumeroSerial = new FocusNode();
  TextEditingController _controllerCodigoProduto = TextEditingController();
  TextEditingController _controllerQtdProduto = TextEditingController();
  TextEditingController _controllerLote = TextEditingController();
  TextEditingController _controllerValidade = TextEditingController();
  TextEditingController _controllerNumeroSerial = TextEditingController();
  TextEditingController _controllerUnidadeMedida = TextEditingController();


  startScanner() async
  {
    String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        "#ff6666", "Cancel", false, ScanMode.DEFAULT);

    setState(() {
      _controllerCodigoProduto.text=barcodeScanRes;
    });
    _inputBipagem();
  }

  _inputBipagem()
  {
    try{
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
    print("@SYS aqui" + jsonz);
    } on Exception catch (exception) {
      setState(() {
        print("@SYS aqui" + exception.toString()) ;
      });
    } catch (error) {
      setState(() {
        print("@SYS aqui" + error.toString());
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     // resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("BIPAGEM"),
        backgroundColor: Colors.green,
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
                padding: EdgeInsets.only(top: 5),
                child: Center(
                  child: Text(
                    "Inventário: ${widget.sInvetarioID}",
                    style: TextStyle(
                        color: Colors.blue,
                        fontSize: 15
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 5),
                child: Center(
                  child: Text(
                    "Endereço: ${widget.sEndereco}",
                    style: TextStyle(
                        color: Colors.blue,
                        fontSize: 15
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 5),
                child: Center(
                  child: Text(
                    "Contagem atual: ${widget.sContagemAtual}",
                    style: TextStyle(
                        color: Colors.blue,
                        fontSize: 15
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
                 // focusNodeQtd.requestFocus();
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

              ),
              TextField(
                focusNode: focusNodeNumeroSerial,
                controller: _controllerNumeroSerial,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    labelText: "Número serial"
                ),

              ),
              TextField(
                focusNode: focusNodeLote,
                controller: _controllerLote,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    labelText: "Lote"
                ),

              ),
              TextField(
                focusNode: focusNodeValdiade,
                controller: _controllerValidade,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    labelText: "Validade"
                ),

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
    );
  }
}
