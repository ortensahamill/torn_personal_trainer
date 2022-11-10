import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import './api_mock.dart';

void main() {
  group('Testing API Mock', () {
    test('Incorrect Key', () async {
      MockClient mock = integrationTestMockClient;
      Response response = await mock.get(Uri(
          scheme: "https",
          host: "api.torn.com",
          path: "user",
          queryParameters: {
            'selections': 'battlestats,basic',
            'key': 'notAKey'
          }));
      expect(response.statusCode, equals(200));
      Map<String, dynamic> json = jsonDecode(response.body);
      expect(json['error']['code'], equals(2));
    });

    test('Access Level of Key not high enough', () async {
      MockClient mock = integrationTestMockClient;
      Response response = await mock.get(Uri(
          scheme: "https",
          host: "api.torn.com",
          path: "user",
          queryParameters: {
            'selections': 'battlestats,basic',
            'key': 'publicKey'
          }));
      expect(response.statusCode, equals(200));
      Map<String, dynamic> json = jsonDecode(response.body);
      expect(json['error']['code'], equals(16));
    });
  });
}
