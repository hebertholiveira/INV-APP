import 'package:bigwhoinventario/sqliteDao/daoSqliteConfig.dart';
import 'package:bigwhoinventario/sqliteDao/mConfig.dart';

import 'sqliteDao/mUsuario.dart';

class Global {

   static var objUser = new mUsuario();

  GetUrls(int iUrl) async
  {
    String _UrlApiCad="http://0.0.0.0:0000/inventario-cad/v1";
    var list = await daoSqliteConfig().getConfig();

    if(list != null)
    {

      if (iUrl == 1) {
        return list.url1;
      }
      else if (iUrl == 2) {
        return list.url2;
      }
    }else {

      mConfig newConf = mConfig();
      newConf.url1=_UrlApiCad;
      newConf.url2=_UrlApiCad;

      await daoSqliteConfig().newConfig(newConf);
      return "@EXS@:Configure a URL do servidor";
    }
    return _UrlApiCad;
  }
}