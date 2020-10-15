import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'CallAPI.dart';
import 'dart:convert';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  TextEditingController _controllerCodigoInv = TextEditingController();
  _findInvetario() async
  {
    http.Response resp;
    var response = await CallAPI().findInv("9", "xx", "x");

    print("Resposta "+ json.decode(response.body).toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("HOME"),
        backgroundColor: Colors.green,
      ),
      body: Container(
        padding: EdgeInsets.all(32),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _controllerCodigoInv,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Digite o Codigo do inventário"
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
