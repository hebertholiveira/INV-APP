import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';

import 'Configurar.dart';
import 'Glob.dart';
import 'Home.dart';
import 'sqliteDao/mUsuario.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {


  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerSenha = TextEditingController();
  String _mensagemErro = "";

  _LoginState(){
  _controllerEmail.text="Wender";
  _controllerSenha.text = "12345";
  /*DateTime now = DateTime.now();
  String formattedDate = DateFormat('yyyy-MM-dd – HH:mm').format(now);*/


  }

  String _TokenAuth()
  {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('14dd10MMyyyyHH2020').format(now);
    var bytes = utf8.encode(formattedDate); // data being hashed

    return sha256.convert(bytes).toString();

  }

  String _Cryptografia(String sSenha)
  {
    var bytes = utf8.encode(sSenha); // data being hashed

    return sha256.convert(bytes).toString();

  }

 /* CallApiAuth(String sUser, String sPass) async
  {
    print("resposta: "+ _sUrl+'/auth');
    Map<String, String> map_headers = {
      'Content-Type': "application/json",
      'user': sUser,
      'bak': sPass,
      'bek': "200"};

    http.Response response = await http.get(
      _sUrl + '/auth',
      // Send authorization headers to the backend.
      headers:map_headers
    ) ;

    print("resposta: "+ response.statusCode.toString());
    //Map<String, dynamic> retorno =  json.decode(response.body);
    //print("resposta: " + retorno["name"]);

  }*/

  _LogarUser() async
  {
      try
      {
        setState(() {
          _mensagemErro = "";
        });

        String _sUrl = await Global().GetUrls(1);
        print("@SIS "+ _sUrl);
          //Recupera dados dos campos
          String email = _controllerEmail.text;
          String senha = _controllerSenha.text;

          if (email.isEmpty) {
            setState(() {
              _mensagemErro = "Preencha o E-Mail";
            });
            return;
          }
          if (senha.isEmpty) {
            setState(() {
              _mensagemErro = "Preencha a senha";
            });
            return;
          }
          String sSenhaCryp = _Cryptografia(senha.trim());

          Map<String, String> map_headers = {
            'Content-Type': "application/json",
            'user': email,
            'bak': sSenhaCryp,
            'bek': _TokenAuth()};

          http.Response response = await http.get(
              _sUrl + '/auth',
              // Send authorization headers to the backend.
              headers: map_headers
          ).timeout(const Duration(seconds: 10));

          print("resposta: " + response.statusCode.toString());
          if (response.statusCode.toString() == "401") {
            setState(() {
              _mensagemErro = "Acesso não autorizado";
            });
            return;
          }

          if (response.statusCode.toString() != "200") {
            setState(() {
              _mensagemErro = "Erro ao acessar o servidor";
            });
            return;
          }


          Map<String, dynamic> retorno = json.decode(response.body);
          print("@SYS " + retorno["token"].toString());

          Global.objUser.ID = retorno["idusuario"].toString();
          Global.objUser.Token = retorno["token"].toString();
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Home()
              )
          );
      } on Exception catch (exception) {
        setState(() {
          _mensagemErro = exception.toString();
        });
      } catch (error) {
        setState(() {
          _mensagemErro = error.toString();
        });
      }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(

          gradient: new LinearGradient(
              colors: [
                const Color(0xFF0000),//0xf05545
                const Color(0xFF00CCFF)
              ],
               begin: const FractionalOffset(0.0, 0.0),
               end: const FractionalOffset(1.0, 0.0),
               stops: [0.0, 1.0],
               tileMode: TileMode.clamp
          ),
        ),
        padding: EdgeInsets.all(16),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                GestureDetector(
                  onLongPress: ()
                  {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Configurar()
                        )
                    );
                  },
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 32),
                    child:  Image.asset(
                      "images/logo_box.png",
                      width: 200,
                      height: 150,
                    ),
                  ),
                ),
                Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: TextField(
                      controller: _controllerEmail,
                      autofocus: true,
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(fontSize: 20),
                      decoration: InputDecoration(
                           hintText: "E-Mail.",
                           border: OutlineInputBorder(
                             borderRadius: BorderRadius.circular(32)
                           ),
                           filled: true,
                           fillColor: Colors.white,
                           contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                          ),
                    ),
                ),
                TextField(
                  controller: _controllerSenha,
                  keyboardType: TextInputType.text,
                  style: TextStyle(fontSize: 20),
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: "Senha",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32)
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 16, bottom: 10),
                  child: RaisedButton(
                    child: Text(
                      "Entrar+",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    color: Colors.orange,
                    padding: EdgeInsets.fromLTRB(32, 16, 32, 30),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32)
                    ),
                    onPressed: () {
                      _LogarUser();
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

        ),
      ),
    );
  }
}
