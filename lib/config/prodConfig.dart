import 'package:euex/config/baseConfig.dart';

class ProdConfig implements BaseConfig{

  @override
  String get baseUrl => "https://backend.europe.express/api";

  @override
  String get chatCollection => "users";

  @override
  String get realTimeDbUrl => "https://europe-express-app-production.firebaseio.com/";

  @override
  String get storageBucket => "gs://europe-express.appspot.com";

  @override
  String get googleApiKey => "AIzaSyBGe3--ckftSI5N6sgpPV5bwDamhD4Qt8s";

}