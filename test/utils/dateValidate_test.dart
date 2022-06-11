import 'package:flutter_project/utils/dateValidate.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Date', () {
    test('Date should be invalid', () {
      DateTime date = DateTime(2022, 6, 1);

      bool checkValid = DateValidate.validate(date);

      expect(checkValid, false);
    });
    test('Date should be valid', () {
      DateTime date = DateTime(2024, 1, 1);
      bool checkValid = DateValidate.validate(date);
      expect(checkValid, true);
    });
  });
}
