import 'package:dio/dio.dart';
import 'package:euex/helpers/httpClient.dart';

import '../config/environment.dart';

class Api {
  static  final String _baseUrl = Environment.config.baseUrl;

  final String _driverLoginUrl = '$_baseUrl/driver_login';

  final String _driverCreateUrl = '$_baseUrl/driver/create';

  final String _driverUpdateUrl = '$_baseUrl/driver/update';

  final String userNameValidateUrl = '$_baseUrl/driver/validate_username';

  final String emailValidateUrl = '$_baseUrl/driver/validate_email';

  final String regNoValidateUrl = '$_baseUrl/driver/validate_reg_no';

  final String _requestVerificationCodeUrl = '$_baseUrl/driver/request_otp';

  final String _restPasswordUrl = '$_baseUrl/driver/reset_password';

  final String _saveFcmTokenUrl = '$_baseUrl/update_fcm_token';

  final String _orderUrl = '$_baseUrl/orders';

  final String _documentUrl = '$_baseUrl/docs';

  final String _driverDetailsUrl = '$_baseUrl/user';

  final String _attachmentUploadUrl = '$_baseUrl/update_attachments';

  final String _invoiceDataUrl = '$_baseUrl/order/invoice_data';

  final String _updateTimeUrl = '$_baseUrl/update_time';

  final String _adminSettingsUrl = '$_baseUrl/driver/settings';

  final String _markDriversHelpNotEligibleUrl = '$_baseUrl/driver-help-status';

  final String _translateUrl = '$_baseUrl/translate';

  final HttpClient _httpClient = HttpClient();

  Future<Map> login(data) async {
    var message = {};
    try {
      var response = await _httpClient.post(_driverLoginUrl, data: data);
      if (response.statusCode == 200) {
        message['status'] = 'success';
        message['data'] = response.data;
      } else {
        message['status'] = 'server_error';
        if (response.statusCode == 422) {
          message['status'] = 'invalid';
        } else if (response.statusCode == 403) {
          if (response.data.toString().contains('account is disabled')) {
            message['status'] = 'disabled';
          }
        }
      }
      return message;
    } catch (e) {
      message['status'] = 'app_error';
      return message;
    }
  }

  Future<Map> signUp(data) async {
    var message = Map();
    try {
      var options = Options(contentType: 'multipart/form-data');
      var response = await _httpClient.post(_driverCreateUrl,
          data: data, options: options);
      if (response.statusCode == 201) {
        message['status'] = 'success';
      } else {
        message['status'] = 'server_error';
        if (response.statusCode == 422) {
          message['status'] = 'validation_errors';
          message['errors'] =
              Map<String, dynamic>.from(response.data['errors']);
        }
      }
      return message;
    } catch (e) {
      message['status'] = 'app_error';
      return message;
    }
  }

  Future<Map> driverUpdate(data) async {
    var message = Map();
    try {
      var options = Options(contentType: 'multipart/form-data');
      var response = await _httpClient.post(_driverUpdateUrl,
          data: data, options: options, authenticated: true);
      if (response.statusCode == 200) {
        message['status'] = 'success';
      } else {
        message['status'] = 'server_error';
        if (response.statusCode == 422) {
          message['status'] = 'validation_errors';
          message['errors'] =
              Map<String, dynamic>.from(response.data['errors']);
        }
      }
      return message;
    } catch (e) {
      message['status'] = 'app_error';
      return message;
    }
  }

  Future<Map> validate(url, data) async {
    var message = Map();
    try {
      var response = await _httpClient.post(url, data: data);
      if (response.statusCode == 200) {
        message['status'] = 'success';
        return message;
      } else {
        message['status'] = 'server_error';
        if (response.statusCode == 422) {
          message['status'] = 'validation_errors';
          message['errors'] = Map<String, dynamic>.from(response.data);
        }
        return message;
      }
    } catch (e) {
      message['status'] = 'app_error';
      return message;
    }
  }

  Future<Map> requestVerificationCode(data) async {
    var message = Map();
    try {
      var response =
          await _httpClient.post(_requestVerificationCodeUrl, data: data);
      if (response.statusCode == 200) {
        message['status'] = 'success';
      } else {
        message['status'] = 'server_error';
        if (response.statusCode == 422) {
          message['status'] = 'validation_errors';
          message['errors'] = Map<String, dynamic>.from(response.data);
        } else if (response.statusCode == 403) {
          message['status'] = 'success';
        }
      }
      return message;
    } catch (e) {
      message['status'] = 'app_error';
      return message;
    }
  }

  Future<Map> restPassword(data) async {
    var message = Map();
    try {
      var response = await _httpClient.post(_restPasswordUrl, data: data);
      if (response.statusCode == 200) {
        message['status'] = 'success';
        return message;
      } else {
        message['status'] = 'failed';
        if (response.statusCode == 422) {
          message['status'] = 'validation_errors';
          message['errors'] = Map<String, dynamic>.from(response.data);
        } else if (response.statusCode == 403) {
          if (response.data == "OTP expired.") {
            message['status'] = 'otp_expired';
          } else if (response.data == "Invalid OTP.") {
            message['status'] = 'invalid_otp';
          }
          return message;
        } else if (response.statusCode == 503) {
          message['status'] = 'server_error';
        }
      }
      return message;
    } catch (e) {
      message['status'] = 'app_error';
      return message;
    }
  }

  Future<Map> saveFcmToken(data) async {
    var message = Map();
    try {
      var response = await _httpClient.post(_saveFcmTokenUrl,
          data: data, authenticated: true);
      if (response.statusCode == 200) {
        message['status'] = 'success';
      } else {
        message['status'] = 'server_error';
      }
      return message;
    } catch (e) {
      message['status'] = 'app_error';
      return message;
    }
  }

  Future getOrders() async {
    try {
      return await _httpClient.get(_orderUrl, authenticated: true);
    } catch (e) {
      return false;
    }
  }

  Future getDocuments() async {
    try {
      return await _httpClient.get(_documentUrl, authenticated: true);
    } catch (e) {
      return false;
    }
  }

  Future getDriverDetails() async {
    try {
      return await _httpClient.get(_driverDetailsUrl, authenticated: true);
    } catch (e) {
      return false;
    }
  }

  Future<Map> uploadAttachments(data) async {
    var message = Map();
    try {
      var response = await _httpClient.post(_attachmentUploadUrl,
          data: data, authenticated: true);
      if (response.statusCode == 200) {
        message['status'] = 'success';
      } else {
        message['status'] = 'server_error';
      }
      return message;
    } catch (e) {
      message['status'] = 'app_error';
      return message;
    }
  }

  Future getInvoices() async {
    try {
      return await _httpClient.get(_invoiceDataUrl, authenticated: true);
    } catch (e) {
      return false;
    }
  }

  Future updateTime(data) async {
    try {
      var response = await _httpClient.post(_updateTimeUrl,
          data: data, authenticated: true);
      return response;
    } catch (e) {
      return false;
    }
  }

  Future getAdminSettings() async {
    try {
      return await _httpClient.get(_adminSettingsUrl, authenticated: true);
    } catch (e) {
      return false;
    }
  }

  Future markDriversHelpEligibility(data) async {
    try {
      var response = await _httpClient.post(_markDriversHelpNotEligibleUrl,
          data: data, authenticated: true);
      return response;
    } catch (e) {
      return false;
    }
  }
  Future getTranslation(data) async {
    try {
      return await _httpClient.get(_translateUrl, queryParameters:data,authenticated: true);
    } catch (e) {
      return null;
    }
  }
}
