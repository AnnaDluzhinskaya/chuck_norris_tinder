import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:chuck_norris_tinder/model/user.dart';

class NetworkService {
  final client = http.Client();

  Future<User> getUserData(Uri apiUrl) async {
    User data;
    var response = await client.get(apiUrl);
    if (response.statusCode == 200) {
      data = User.fromJson(jsonDecode(response.body));
    } else {
      data = const User(description: "Can't get joke!");
    }
    return data;
  }
}
