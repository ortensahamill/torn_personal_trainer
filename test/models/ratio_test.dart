import 'package:flutter_test/flutter_test.dart';
import 'package:torn_personal_trainer/models/ratio.dart';
import 'package:torn_personal_trainer/models/user.dart';

void main() {
  group('Testing Hanks ratio DEX', () {
    test('When train dex, strength max increases, speed max increases', () {
      User user = User(
          playerId: 0,
          name: "",
          strength: 100000,
          speed: 100000,
          dexterity: 125000,
          defense: 0);
      RatioModel ratio = RatioModel(user);
      expect(ratio.strength.currentValue, equals(ratio.strength.maximumValue));
      expect(ratio.speed.currentValue, equals(ratio.speed.maximumValue));
      expect(ratio.dexterity.maximumValue, equals(160000));
      ratio.addListener(() {
        expect(
            ratio.strength.currentValue, lessThan(ratio.strength.maximumValue));
        expect(ratio.speed.currentValue, lessThan(ratio.speed.maximumValue));
      });
      ratio.setCurrentDexterity(250000);
    });
  });
}
