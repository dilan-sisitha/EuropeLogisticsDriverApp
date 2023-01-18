import 'package:euex/config/baseConfig.dart';

class DevConfig implements BaseConfig{

  @override
  String get baseUrl => "https://backend.dev.europe.express/api";

  @override
  String get chatCollection => "users-test";

  @override
  String get realTimeDbUrl => "https://europe-express-app-test-db.firebaseio.com/";

  @override
  String get storageBucket => "gs://europe-express-test";

  @override
  String get googleApiKey => "AIzaSyCGspNvYtHtW6cNtBx6G-CFHjbipF_Juh0";

}