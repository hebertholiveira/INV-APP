import 'package:flutter/material.dart';

class InventarioOperacao extends StatefulWidget {
  @override
  _InventarioOperacaoState createState() => _InventarioOperacaoState();
}

class _InventarioOperacaoState extends State<InventarioOperacao> {

  var focusNodeQtd = new FocusNode();
  TextEditingController _controllerCodigoProduto = TextEditingController();
  TextEditingController _controllerQtdProduto = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("BIPAGEM"),
        backgroundColor: Colors.green,
      ),
      body: Container(
        padding: EdgeInsets.all(32),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _controllerCodigoProduto,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                  labelText: "Codigo do Produto"
              ),
              onSubmitted: (String value){
                focusNodeQtd.requestFocus();
              },
            ),
            TextField(
              focusNode: focusNodeQtd,
              controller: _controllerQtdProduto,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                  labelText: "Quantidade"
              ),

            ),


          ],
        ),
      ),
    );
  }
}
