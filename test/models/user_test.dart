import 'dart:io';
import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:torn_personal_trainer/models/user.dart';

void main() {
  group('Testing User', () {
    test('Parses JSON', () {
      String contents = File('./assets/user.json').readAsStringSync();
      User user = User.fromJson(jsonDecode(contents));
      expect(user.playerId, equals(2720412));
      expect(user.name, equals("TogaHimiko"));
      expect(user.strength, equals(1));
      expect(user.speed, equals(2));
      expect(user.dexterity, equals(3));
      expect(user.defense, equals(4));
    });
  });
}
