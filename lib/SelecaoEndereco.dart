import 'package:flutter/material.dart';

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
   Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => InventarioOperacao()
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
             // onSubmitted: _ValidaEndreco(),
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
