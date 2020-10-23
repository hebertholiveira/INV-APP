import 'package:http/http.dart' as http;

import 'Glob.dart';
class CallAPI
{


  findInv(String InvId, String sUser, String sToken) async
  {
      String sUrl = await Global().GetUrls(1);
      Map<String, String> map_headers = {
        'Content-Type': "application/json",
        'user': sUser,
        'token': sToken};

      http.Response response = await http.get(
          sUrl + '/inventario/'+InvId,
          // Send authorization headers to the backend.
          headers:map_headers
      ) ;
      return response;
  }

}