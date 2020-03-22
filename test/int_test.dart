import 'package:flutter_test/flutter_test.dart';
import 'package:pond_hockey/utils/updater.dart';

void main() {
  group('integer tests', () {
    test('replace special characters', () {
      final u = Updater();

      final match = 111;
      final testString1 = '1.1.1';
      final testString2 = '1+1+1';
      final testString3 = '1.1+1';

      final test1 = u.convertToInteger(testString1);
      final test2 = u.convertToInteger(testString2);
      final test3 = u.convertToInteger(testString3);

      expect([test1, test2, test3], [match, match, match]);
    });
  });
}
