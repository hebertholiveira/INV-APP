import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class InventarioOperacao extends StatefulWidget {
  @override
  _InventarioOperacaoState createState() => _InventarioOperacaoState();
}

class _InventarioOperacaoState extends State<InventarioOperacao> {

  var focusNodeQtd = new FocusNode();
  TextEditingController _controllerCodigoProduto = TextEditingController();
  TextEditingController _controllerQtdProduto = TextEditingController();

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
