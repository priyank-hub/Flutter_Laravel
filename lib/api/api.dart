import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Network {
  // final String _url = 'https://my-laravel-auth.herokuapp.com/api';
  final String _url = 'https://app.taliuptesting.com/api';
  // final String _url = 'https://tali-express.com/api';
  // final String _url = 'https://taliuptesting.com/api';
  var token;

  _getToken() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    token = jsonDecode(localStorage.getString('token'));
  }

  authData(data, apiUrl) async {
    var fullUrl = _url + apiUrl;
    return await http.post(fullUrl,
        body: jsonEncode(data), headers: _setHeaders());
  }

  getData(apiUrl) async {
    var fullUrl = _url + apiUrl;
    await _getToken();
    return await http.get(fullUrl, headers: _setHeaders());
  }

  _setHeaders() => {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      };

  getDataWithoutToken(apiUrl) async {
    print(apiUrl);
    var fullUrl = _url + apiUrl;
    return await http.get(fullUrl, headers: _setHeadersWithoutToken());
  }

  _setHeadersWithoutToken() => {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Access-Control-Allow-Origin': 'http://taliup-express.test',
        'Access-Control-Allow-Methods': 'POST, GET, OPTIONS, DELETE',
      };
}
