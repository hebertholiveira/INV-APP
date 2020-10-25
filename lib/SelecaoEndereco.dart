import 'dart:convert';

import 'package:flutter/material.dart';

import 'CallAPI.dart';
import 'Glob.dart';
import 'InvetarioOperacao.dart';


class SelecaoEndereco extends StatefulWidget {

  String sInvetarioID;
  SelecaoEndereco(this.sInvetarioID);
  @override
  _SelecaoEnderecoState createState() => _SelecaoEnderecoState();
}

class _SelecaoEnderecoState extends State<SelecaoEndereco> {

  TextEditingController _controllerEndereco = TextEditingController();
  String _mensagemErro="";

  _ValidaEndreco() async
  {
    setState(() {
      _mensagemErro = "";
    });
     var response = await CallAPI().findEndereco(widget.sInvetarioID, _controllerEndereco.text, Global.objUser.ID, Global.objUser.Token);

     if (response.statusCode.toString() == "500") {
       setState(() {
         _mensagemErro = "Erro";
       });
       return;
     }

     if (response.statusCode.toString() == "404") {
       setState(() {
         _mensagemErro = "Endereço não encontrado";
       });
       return;
     }

     if (response.statusCode.toString() == "401") {
       setState(() {
         _mensagemErro = "Acesso não autorizado";
       });
       return;
     }

     Map<String, dynamic> retorno = json.decode(response.body);
     if (response.statusCode.toString() == "403") {
       setState(() {
         _mensagemErro = retorno["mensagem"].toString();
       });
       return;
     }

     if (response.statusCode.toString() != "200") {
       setState(() {
         _mensagemErro = "Busca apresentou inconsistência";
       });
       return;
     }


     Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => InventarioOperacao(widget.sInvetarioID, retorno["idendereco"].toString(), retorno["contagem"].toString(),_controllerEndereco.text.toUpperCase())
          )
      );

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("SELECIONE UM ENDEREÇO"),
        backgroundColor: Colors.green,
      ),
      body: Container(
        padding: EdgeInsets.all(32),
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 16),
              child: Center(
                child: Text(
                  "Inventário: ${widget.sInvetarioID}",
                  style: TextStyle(
                      color: Colors.blue,
                      fontSize: 30
                  ),
                ),
              ),
            ),
            TextField(
              controller: _controllerEndereco,
              autofocus: true,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                  labelText: "Digite um endereço"
              ),
              onSubmitted: (String value){_ValidaEndreco();},
              style: TextStyle(
                  fontSize: 20.0,
                  height: 2.0,
                  color: Colors.black
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 16, bottom: 10),
              child: RaisedButton(
                child: Text(
                  "Continuar",

                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                color: Colors.orange,
                padding: EdgeInsets.fromLTRB(32, 16, 32, 30),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32)
                ),
                onPressed: (){
                  _ValidaEndreco();
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 16),
              child: Center(
                child: Text(
                  _mensagemErro,
                  style: TextStyle(
                      color: Colors.red,
                      fontSize: 20
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
