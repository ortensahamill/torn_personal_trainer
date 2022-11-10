import 'dart:io';
import 'package:http/http.dart';
import 'package:http/testing.dart';

MockClient integrationTestMockClient = MockClient((request) async {
  // https://api.torn.com/user/?selections=battlestats,basic&key=XXXXXX
  String? key = request.url.queryParameters['key'];
  switch (key) {
    case 'limitedKey':
      return Response(File('./assets/user.json').readAsStringSync(), 200);
    case 'publicKey':
      return Response(
          '{"error":{"code":16,"error":"Access level of this key is not high enough"}}',
          200);
    case 'minimalKey':
      return Response(
          '{"error":{"code":16,"error":"Access level of this key is not high enough"}}',
          200);
    default:
      return Response('{"error":{"code":2,"error":"Incorrect key"}}', 200);
  }
});
