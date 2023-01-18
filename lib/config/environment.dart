import 'package:euex/config/devConfig.dart';
import 'package:euex/config/prodConfig.dart';

import 'baseConfig.dart';

class Environment{

  Environment._internal();

  static final Environment _singleton = Environment._internal();

  factory Environment(){
    return _singleton;
  }

  static late BaseConfig config;

  initConfig(Env environment) {
    config = _getConfig(environment);
  }

  BaseConfig _getConfig(Env environment) {
    switch (environment) {
      case Env.development:
        return DevConfig();
      case Env.production:
        return ProdConfig();
      default:
        return DevConfig();
    }
  }

}

enum Env{
  production,
  development
}