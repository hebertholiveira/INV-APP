import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class InventarioOperacao extends StatefulWidget {
  @override
  _InventarioOperacaoState createState() => _InventarioOperacaoState();
}

class _InventarioOperacaoState extends State<InventarioOperacao> {

  var focusNodeProduto = new FocusNode();
  var focusNodeQtd = new FocusNode();
  var focusNodeLote = new FocusNode();
  var focusNodeValdiade = new FocusNode();
  TextEditingController _controllerCodigoProduto = TextEditingController();
  TextEditingController _controllerQtdProduto = TextEditingController();
  TextEditingController _controllerLote = TextEditingController();
  TextEditingController _controllerValidade = TextEditingController();

  startScanner() async
  {
    String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        "#ff6666", "Cancel", false, ScanMode.DEFAULT);

    setState(() {
      _controllerCodigoProduto.text=barcodeScanRes;
    });
    print("@SIS "+ barcodeScanRes);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("BIPAGEM"),
        backgroundColor: Colors.green,
      ),
      body: Container(
      //  constraints: BoxConstraints(minWidth: 100, maxWidth: 100),
        padding: EdgeInsets.all(32),
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 16, bottom: 10),
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
            TextField(
              autofocus: true,
              focusNode: focusNodeProduto,
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

          ],
        ),
      ),
    );
  }
}
