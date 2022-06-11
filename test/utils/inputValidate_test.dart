import 'package:flutter_project/utils/inputValidate.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Input Validate', () {
    test('Input is empty', () {
      String input = '';
      bool checkValid = InputValidate.validate(input);
      expect(checkValid, true);
    });
    test('Input is not empty', () {
      String input = 'abcxyz';
      bool checkValid = InputValidate.validate(input);
      expect(checkValid, false);
    });
  });
}