import 'package:form_field_validator/form_field_validator.dart';

class EmailLocalPartLengthValidator extends FieldValidator<String> {
  EmailLocalPartLengthValidator(
      {String errorText = 'Invalid email character length'})
      : super(errorText);

  final int maxLocalPart = 64;

  @override
  bool isValid(String value) {
    var split = value.split('@');
    return split[0].length <= maxLocalPart;
    // return true;
  }
}

class EmailDomainPartLengthValidator extends FieldValidator<String> {
  EmailDomainPartLengthValidator(
      {String errorText = 'Invalid email character length'})
      : super(errorText);

  final int maxDomainPart = 255;

  @override
  bool isValid(String value) {
    var split = value.split('@');
    if(split.length!=2) return true;
    return split[1].length <= maxDomainPart;
    // return true;
  }
}
