import 'package:euex/api/api.dart';
import 'package:euex/providers/signUpDataProvider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class SignUpService {
  Future<String?> validateField(value, fieldName, url, context) async {
    Map response = await Api().validate(url, {fieldName: value});
    String status = response['status'];
    if (status == "validation_errors") {
      switch (fieldName) {
        case "user_name":
          {
            Provider.of<SignUpDataProvider>(context, listen: false)
                    .userNameErrText =
                AppLocalizations.of(context)!.uniqueUserNameError;
            Provider.of<SignUpDataProvider>(context, listen: false)
                .invalidUserName = true;
          }
          break;

        case "email":
          {
            String error = Map.from(response['errors'])['email'][0];
            if (error.contains('The email has already been taken')) {
              Provider.of<SignUpDataProvider>(context, listen: false)
                      .emailErrText =
                  AppLocalizations.of(context)!.uniqueEmailError;
              Provider.of<SignUpDataProvider>(context, listen: false)
                  .invalidEmail = true;
            }
          }
          break;

        case "reg_no":
          {
            Provider.of<SignUpDataProvider>(context, listen: false)
                    .vanRegistrationErrText =
                AppLocalizations.of(context)!.uniqueVanRegError;
            Provider.of<SignUpDataProvider>(context, listen: false)
                .invalidRegNo = true;
          }
          break;
      }
    }
    return null;
  }

  bool isBackendError(context) {
    bool regNoError =
        Provider.of<SignUpDataProvider>(context, listen: false).invalidRegNo;
    bool userNameError =
        Provider.of<SignUpDataProvider>(context, listen: false).invalidUserName;
    bool emailError =
        Provider.of<SignUpDataProvider>(context, listen: false).invalidEmail;

    return regNoError || userNameError || emailError;
  }

  bool isFormInvalid(context) {
    bool formError =
        !Provider.of<SignUpDataProvider>(context, listen: false).isValid;
    bool isBackendValid = isBackendError(context);

    return formError || isBackendValid;
  }
}
