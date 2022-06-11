class DateValidate {
  static bool validate(DateTime date) {
    if (date.compareTo(DateTime.now()) >= 0) {
      return true;
    } else {
      return false;
    }
  }
}
