import 'package:http/http.dart' as http;
import 'dart:convert';

Future getData() async {
  var url = 'https://192.168.1.14/create-php-service.php';
  http.Response response = await http.get(url as Uri);
  var data = jsonDecode(response.body);
  return data;
}
