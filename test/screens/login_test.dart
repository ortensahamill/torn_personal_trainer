import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:torn_personal_trainer/models/user.dart';
import 'package:torn_personal_trainer/screens/login.dart';
import 'login_test.mocks.dart';
import '../mocks/api_mock.dart';

@GenerateMocks(
  [],
  customMocks: [
    MockSpec<NavigatorObserver>(
      onMissingStub: OnMissingStub.returnDefault,
    )
  ],
)
void main() {
  GetIt.instance.registerSingleton<BaseClient>(integrationTestMockClient);
  GetIt.instance.registerSingleton<UserCache>(UserCache());

  group('Login Page Tests', () {
    testWidgets(
        'Test that correct API key is stored in shared preferences and route is now /home',
        (tester) async {
      final mockObserver = MockNavigatorObserver();
      SharedPreferences.setMockInitialValues({});
      SharedPreferences prefs = await SharedPreferences.getInstance();

      await tester.pumpWidget(MaterialApp(
        initialRoute: '/login',
        routes: {
          '/login': (context) => const Login(),
          '/home': (context) => const Text("Home")
        },
        navigatorObservers: [mockObserver],
      ));

      await tester.enterText(find.byType(TextFormField), "limitedKey");
      await tester.tap(find.text('Sign in'));
      await tester.pump(const Duration(milliseconds: 100));
      expect(prefs.get("apikey"), matches("limitedKey"));

      final List pushedRoutes =
          verify(mockObserver.didPush(captureAny, any)).captured;
      expect(pushedRoutes[0].settings.name, equals('/login'));
      expect(pushedRoutes[1].settings.name, matches('/home'));
    });

    testWidgets('Test that incorrect API key shows snackbar', (tester) async {
      SharedPreferences.setMockInitialValues({});
      SharedPreferences prefs = await SharedPreferences.getInstance();

      await tester.pumpWidget(const MaterialApp(home: Scaffold(body: Login())));

      await tester.tap(find.text('Sign in'));
      await tester.pump(); // schedule animation

      expect(find.text('Incorrect key'), findsOneWidget);
      expect(prefs.get("apikey"), isNull);
    });
  });
}
