import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:torn_personal_trainer/models/ratio.dart';
import 'package:torn_personal_trainer/models/user.dart';
import 'package:torn_personal_trainer/widgets/stat_slider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Future<User> _user = GetIt.instance<UserCache>().fetch();

  void _handleLogout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    prefs.remove("apikey");
    Navigator.pushNamedAndRemoveUntil(
        context, '/login', ModalRoute.withName('/login'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Torn City Personal Trainer"),
        ),
        body: FutureBuilder<User>(
            future: _user,
            builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
              if (snapshot.hasData) {
                return ChangeNotifierProvider(
                    create: (context) => RatioModel(snapshot.data as User),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Icon(
                          Icons.check_circle_outline,
                          color: Colors.green,
                          size: 60,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: Text('Hello, ${snapshot.data?.name}!'),
                        ),
                        ElevatedButton(
                          onPressed: _handleLogout,
                          child: const Text("Logout"),
                        ),
                        GymTrainerWidget(user: snapshot.data as User),
                      ],
                    ));
              } else {
                return const CircularProgressIndicator();
              }
            }));
  }
}

class GymTrainerWidget extends StatefulWidget {
  final User user;
  const GymTrainerWidget({super.key, required this.user});

  @override
  State<GymTrainerWidget> createState() => _GymTrainerWidgetState();
}

class _GymTrainerWidgetState extends State<GymTrainerWidget> {
  @override
  Widget build(BuildContext context) {
    return Consumer<RatioModel>(builder: (context, ratio, child) {
      return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            StatSliderWidget(
                initialStatValue: widget.user.dexterity.toDouble(),
                maxStatValue: ratio.dexterity.maximumValue.toDouble(),
                statName: "Dexterity"),
            StatSliderWidget(
                initialStatValue: widget.user.strength.toDouble(),
                maxStatValue: ratio.strength.maximumValue,
                statName: "Strength"),
            StatSliderWidget(
                initialStatValue: widget.user.speed.toDouble(),
                maxStatValue: ratio.speed.maximumValue,
                statName: "Speed")
          ]);
    });
  }
}
