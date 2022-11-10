import 'package:get_it/get_it.dart';
import 'package:http/http.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:torn_personal_trainer/models/user.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late String _apikey;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  BaseClient client = GetIt.instance<BaseClient>();
  UserCache userCache = GetIt.instance<UserCache>();

  void showInSnackBar(String value) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value)));
  }

  void _handleSubmitted() async {
    _formKey.currentState!.save();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("apikey", _apikey);
    try {
      await userCache.fetch();
      if (!mounted) return;
      Navigator.pushNamedAndRemoveUntil(
          context, '/home', ModalRoute.withName('/home'));
    } catch (error) {
      prefs.remove("apikey");
      showInSnackBar(error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: const Text('Enter Limited Access API key'),
        ),
        body: SafeArea(
          top: false,
          bottom: false,
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextFormField(
                    key: const Key("_apikey"),
                    decoration: const InputDecoration(
                        labelText: "Limited Access API Key"),
                    keyboardType: TextInputType.text,
                    onSaved: (value) {
                      _apikey = value!;
                    },
                  ),
                  const SizedBox(height: 10.0),
                  ButtonBar(
                    children: <Widget>[
                      ElevatedButton.icon(
                          onPressed: () => _handleSubmitted(),
                          icon: const Icon(Icons.arrow_forward),
                          label: const Text('Sign in')),
                    ],
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
