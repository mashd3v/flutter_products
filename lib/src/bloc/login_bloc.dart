import 'dart:async';

import 'package:form_validation/src/bloc/validators.dart';
import 'package:rxdart/rxdart.dart';

class LoginBloc with Validators{
  final _emailController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();
  
  //Get data from Stream
  Stream<String> get emailStream    => _emailController.stream.transform(validateEmail);
  Stream<String> get passwordStream => _passwordController.stream.transform(validatePassword);
  Stream<bool> get formValidStream => 
    Rx.combineLatest2(emailStream, passwordStream, (e, p) => true);
  
  //Set values
  Function(String) get changeEmail    => _emailController.sink.add;
  Function(String) get changePassword => _passwordController.sink.add;

  //Get latest data from Streams
  String get email => _emailController.value;
  String get password => _passwordController.value;

  
  dispose(){
    _emailController?.close();
    _passwordController?.close();
  }

}