import 'dart:convert';
import 'package:form_validation/src/user_preferences/user_preferences.dart';
import 'package:http/http.dart' as http;

class UserProvider{
  final String _firebaseToken = 'AIzaSyBS6tRT2e1Kt6DgHhDtqihm0ToFZV4aLQ8';
  final _preferences = new UserPreferences();

  Future<Map<String, dynamic>> login(String email, String password) async{
    final authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true,
    };
    final response = await http.post(
      'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$_firebaseToken',
      body: json.encode(authData)
    );

    Map<String, dynamic> decodedResponse = json.decode(response.body);

    if(decodedResponse.containsKey('idToken')){
      _preferences.token = decodedResponse['idToken'];
      return{'ok': true, 'token': decodedResponse['idToken']};
    }else{
      return{'ok': false, 'message': decodedResponse['error']['message']};
    }
  }

  Future<Map<String, dynamic>> newUser(String email, String password) async{
    final authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true,
    };
    final response = await http.post(
      'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$_firebaseToken',
      body: json.encode(authData)
    );

    Map<String, dynamic> decodedResponse = json.decode(response.body);

    if(decodedResponse.containsKey('idToken')){
      _preferences.token = decodedResponse['idToken'];      
      return{'ok': true, 'token': decodedResponse['idToken']};
    }else{
      return{'ok': false, 'message': decodedResponse['error']['message']};
    }
  }
}