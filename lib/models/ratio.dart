import 'package:flutter/foundation.dart';
import 'package:torn_personal_trainer/models/user.dart';

class StatRange {
  final int currentValue;
  final double maximumValue;

  StatRange(this.currentValue, this.maximumValue);
}

// Hanks ratio, dex specialist
// Strength + Speed 25% higher than Dexterity + Defense
// Dexterity 25% higher than your second highest stat
class RatioModel extends ChangeNotifier {
  late StatRange strength;
  late StatRange speed;
  late StatRange dexterity;
  late StatRange defense;
  RatioModel(User user) {
    strength = StatRange(user.strength, user.dexterity / 1.25);
    speed = StatRange(user.speed, user.dexterity / 1.25);
    dexterity = StatRange(
        user.dexterity, (user.strength + user.speed) / 1.25 - user.defense);
    defense = StatRange(user.defense, user.defense.toDouble());
  }
  void setCurrentStrength(int value) {
    strength = StatRange(value, dexterity.currentValue / 1.25);
    dexterity = StatRange(
        dexterity.currentValue,
        (strength.currentValue + speed.currentValue) / 1.25 -
            defense.currentValue);
    notifyListeners();
  }

  void setCurrentSpeed(int value) {
    speed = StatRange(value, dexterity.currentValue / 1.25);
    dexterity = StatRange(
        dexterity.currentValue,
        (strength.currentValue + speed.currentValue) / 1.25 -
            defense.currentValue);
    notifyListeners();
  }

  void setCurrentDexterity(int value) {
    strength = StatRange(strength.currentValue, value / 1.25);
    speed = StatRange(speed.currentValue, value / 1.25);
    dexterity = StatRange(
        value,
        (strength.currentValue + speed.currentValue) / 1.25 -
            defense.currentValue);
    notifyListeners();
  }
}
