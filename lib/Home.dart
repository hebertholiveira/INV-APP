import 'package:bigwhoinventario/SelecaoEndereco.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'CallAPI.dart';
import 'dart:convert';

import 'Glob.dart';
import 'InvetarioOperacao.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController _controllerCodigoInv = TextEditingController();
  String _mensagemErro="";

  _findInvetario() async
  {
        setState(() {
          _mensagemErro = "";
        });

        var response = await CallAPI().findInv(_controllerCodigoInv.text, Global.objUser.ID, Global.objUser.Token);

        if (response.statusCode.toString() == "404") {
          setState(() {
            _mensagemErro = "Inventário não encontrado";
          });
          return;
        }

        if (response.statusCode.toString() == "401") {
          setState(() {
            _mensagemErro = "Acesso não autorizado";
          });
          return;
        }

        if (response.statusCode.toString() != "200") {
          setState(() {
            _mensagemErro = "Busca apresentou inconsistência";
          });
          return;
        }

        Map<String, dynamic> retorno = json.decode(response.body);

      if(retorno["statusID"].toString() == "5")
      {
        setState(() {
          _mensagemErro = "Inventário já  se encontra FINALIZADO.";
        });
        return;
      }

      if(retorno["statusID"].toString() != "3")
      {
            setState(() {
              _mensagemErro = "Inventário não se encontra no Status: EM INVENTÁRIO";
            });
            return;
      }

      Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SelecaoEndereco(retorno["idinventario"].toString())
            )
        );

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("HOME"),
        backgroundColor: Colors.red,
      ),
      body: Container(
        padding: EdgeInsets.all(32),
        child: Column(
          children: <Widget>[
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
            ),
            TextField(

              controller: _controllerCodigoInv,
              autofocus: true,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Digite o Codigo do inventário"
              ),
              onSubmitted: (String value){_findInvetario();},


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
                  _findInvetario();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
