import 'package:find_me/models/position.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Stream<List<Position>> getData() async* {
  var url = 'http://192.168.1.14:8080/serviceApp/create-php-service.php';
  try {
    http.Response response = await http.get(Uri.parse(url));
    dynamic data;
    List<Position> pos = [];
    try {
      data = jsonDecode(response.body);
      for (var elem in data['UnePosition']) {
        pos.add((Position.fromMap(elem)));
      }
    } catch (e) {
      print(e);
    }
    yield pos;
  } catch (e) {
    print(e);
  }
}

Future insert(Position pos) async {
  var url = "http://192.168.1.14:8080/serviceApp/insert_ami.php";
  final response = await http.post(Uri.parse(url),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode(pos.toJSON()));
  if (response.statusCode == 200) {
    return 1;
  } else {
    return 0;
  }
}
