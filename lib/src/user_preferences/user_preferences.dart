import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {

  static final UserPreferences _instance = new UserPreferences._internal();

  factory UserPreferences() {
    return _instance;
  }

  UserPreferences._internal();

  SharedPreferences _preferences;

  initPreferences() async {
    this._preferences = await SharedPreferences.getInstance();
  }

  // GET y SET del nombre
  get token {
    return _preferences.getString('token') ?? '';
  }

  set token(String value) {
    _preferences.setString('token', value);
  }
  

  // GET y SET de la última página
  get lastPage {
    return _preferences.getString('lastPage') ?? 'login';
  }

  set lastPage(String value) {
    _preferences.setString('lastPage', value);
  }

}


