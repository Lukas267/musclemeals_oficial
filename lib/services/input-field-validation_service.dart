import 'package:email_validator/email_validator.dart';

class Validator {

  dynamic emailValidation(String email) {
    return EmailValidator.validate(email) ? null : 'Die eingegebene E-Mail ist nicht gültig';
  }

  dynamic passwordValidation(String password) {
    return password.length >= 6 ? null : 'Das Password muss mindestens 6 Zeichen lang sein.';
  }

  dynamic nameValidation(String name) {
    return name.isNotEmpty ? null : 'Bitte gib deinen Namen ein.';
  }

  dynamic locationValidation(dynamic location) {
    return location != null ? null : 'Bitte wähle einen Standort.';
  }

}