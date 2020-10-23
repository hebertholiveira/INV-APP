import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import 'sqliteDao/daoSqliteConfig.dart';
import 'sqliteDao/mConfig.dart';

class Configurar extends StatefulWidget {
  @override
  _ConfigurarState createState() => _ConfigurarState();
}

class _ConfigurarState extends State<Configurar> {

  String _mensagem="";
  String _diretorioApp="";
  TextEditingController _controllerUrl01 = TextEditingController();
  TextEditingController _controllerUrl02 = TextEditingController();

  _validar() async
  {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    setState(() {
      _diretorioApp=documentsDirectory.path;
    });

    try
    {
        var list = await daoSqliteConfig().getConfig();

        if(list == null)
        {
          mConfig newConf = mConfig();
          newConf.url1 = "http://0.0.0.0:0000/inventario-cad/v1";
          newConf.url2 = "http://0.0.0.0:0000/inventario-cad/v1";
          print("@SYS INSERT");
          await daoSqliteConfig().newConfig(newConf);
          setState(() {
            _controllerUrl01.text = newConf.url1;
            _controllerUrl02.text = newConf.url2;
          });
        }else{
          setState(() {
            _controllerUrl01.text = list.url1;
            _controllerUrl02.text = list.url2;
          });
        }
    } on Exception catch (exception) {
    setState(() {
      _mensagem = exception.toString();
    });
    } catch (error) {
    setState(() {
      _mensagem = error.toString();
    });
    }
  }

  _ConfigurarState()
  {
    _validar();
  }

  _UpdateConfig() async
  {
    try
    {
        await daoSqliteConfig().updateClient(_controllerUrl01.text, _controllerUrl02.text);
        setState(() {
          _mensagem = "Alteração realizada com sucesso!";
        });
    } on Exception catch (exception) {
    setState(() {
    _mensagem = exception.toString();
    });
    } catch (error) {
    setState(() {
    _mensagem = error.toString();
    });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Configuração'),
        backgroundColor: Colors.red,
      ),
      body: Container(

        padding: EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 25),
              child: Center(
                child: Text(
                  _mensagem,
                  style: TextStyle(
                      color: Colors.orange,
                      fontSize: 20
                  ),
                ),
              ),
            ),
            TextField(
              controller: _controllerUrl01,
              autofocus: true,
              keyboardType: TextInputType.url,
              decoration: InputDecoration(
                  labelText: "URL 01"
              ),
            ),
            TextField(
              controller: _controllerUrl02,
              autofocus: true,
              keyboardType: TextInputType.url,
              decoration: InputDecoration(
                  labelText: "URL 02"
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 16, bottom: 10),
              child: RaisedButton(
                child: Text(
                  "Salvar",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                color: Colors.blue,
                padding: EdgeInsets.fromLTRB(32, 16, 32, 30),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32)
                ),
                onPressed: (){
                  setState(() {
                    _UpdateConfig();
                  });
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 25),
              child: Center(
                child: Text(
                  _diretorioApp,
                  style: TextStyle(
                      color: Colors.orange,
                      fontSize: 20
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
