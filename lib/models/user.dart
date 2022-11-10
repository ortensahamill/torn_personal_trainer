import 'dart:convert';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class User {
  final int playerId;
  final String name;
  final int strength;
  final int speed;
  final int dexterity;
  final int defense;

  User(
      {required this.playerId,
      required this.name,
      required this.strength,
      required this.speed,
      required this.dexterity,
      required this.defense});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      playerId: json['player_id'],
      name: json['name'],
      strength: json['strength'],
      speed: json['speed'],
      dexterity: json['dexterity'],
      defense: json['defense'],
    );
  }
}

class UserCache {
  User? _user;
  Future<User> fetch() async {
    if (_user != null) {
      return _user as User;
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? apikey = prefs.get("apikey") as String?;
    BaseClient client = GetIt.instance<BaseClient>();
    Response response = await client.get(Uri(
        scheme: "https",
        host: "api.torn.com",
        path: "user",
        queryParameters: {'selections': 'battlestats,basic', 'key': apikey}));
    if (response.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(response.body);
      if (json.containsKey('error')) {
        throw (json['error']['error']);
      } else {
        _user = User.fromJson(json);
        return _user as User;
      }
    } else {
      throw ('Call to Torn API failed: status code ${response.statusCode}');
    }
  }
}
