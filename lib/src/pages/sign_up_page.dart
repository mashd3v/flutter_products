import 'package:flutter/material.dart';
import 'package:form_validation/src/bloc/provider.dart';
import 'package:form_validation/src/providers/user_provider.dart';
import 'package:form_validation/src/utils/functions.dart';

class SignUpPage extends StatelessWidget {
  final userProvider = new UserProvider();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _backgroundLogin(context),
          _logInBox(context),
        ],
      ),
    );
  }

  Widget _logInBox(BuildContext context) {
    final bloc = Provider.of(context);
    final screenSize = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Column(
        children: [
          SafeArea(
            child: Container(
              height: 180.0,
            ),
          ),
          Container(
            width: screenSize.width * 0.85,
            padding: EdgeInsets.symmetric(vertical: 50.0),
            margin: EdgeInsets.symmetric(vertical: 30.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(11.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 3.0,
                  offset: Offset(0.0, 5.0),
                  spreadRadius: 3.0,
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  'New User',
                  style: TextStyle(fontSize: 20.0),
                ),
                SizedBox(
                  height: 30.0,
                ),
                _createEmail(bloc),
                SizedBox(
                  height: 10.0,
                ),
                _createPassword(bloc),
                SizedBox(
                  height: 20.0,
                ),
                _createLogInButton(bloc),
              ],
            ),
          ),
          Row(           
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Already registered?', style: TextStyle(color: Colors.grey),),
              FlatButton(                
                child: Text('Log In', style: TextStyle(decoration: TextDecoration.underline),),
                onPressed: () => Navigator.pushReplacementNamed(context, 'login'),
              ),              
            ],
          ),  
          SizedBox(
            height: 100.0,
          ),
        ],
      ),
    );
  }

  Widget _createEmail(LoginBloc bloc) {
    return StreamBuilder(
      stream: bloc.emailStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: TextField(
            cursorColor: Color.fromRGBO(90, 70, 178, 1.0),
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              icon: Icon(
                Icons.alternate_email,
                color: Colors.deepPurple,
              ),
              hintText: 'myemail@email.com',
              labelText: 'Email',
              counterText: snapshot.data,
              errorText: snapshot.error,
            ),
            onChanged: bloc.changeEmail,
          ),
        );
      },
    );
  }

  Widget _createPassword(LoginBloc bloc) {
    return StreamBuilder(
      stream: bloc.passwordStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: TextField(
            cursorColor: Color.fromRGBO(90, 70, 178, 1.0),
            obscureText: true,
            decoration: InputDecoration(
              icon: Icon(
                Icons.lock,
                color: Colors.deepPurple,
              ),
              labelText: 'Password',
              counterText: snapshot.data,
              errorText: snapshot.error,
            ),
            onChanged: bloc.changePassword,
          ),
        );
      },
    );
  }

  Widget _createLogInButton(LoginBloc bloc) {
    return StreamBuilder(
      stream: bloc.formValidStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return RaisedButton(
          color: Color.fromRGBO(90, 70, 178, 1.0),
          textColor: Colors.white,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 80.0, vertical: 15.0),
            child: Text('Sign Up'),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(11.0),
          ),
          elevation: 0.0,
          onPressed: snapshot.hasData ? () => _signup(context, bloc) : null,
        );
      },
    );
  }

  _signup(BuildContext context, LoginBloc bloc) async{
    Map info = await userProvider.newUser(bloc.email, bloc.password);
    
    if(info['ok']){
      Navigator.pushReplacementNamed(context, 'login');
    }else{
      showAlert(context, 'Some field must be wrong, try again');
    }
  }

  Widget _backgroundLogin(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    final backgroundContainer = Container(
      height: screenSize.height * 0.4,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromRGBO(63, 63, 156, 1.0),
            Color.fromRGBO(90, 70, 178, 1.0),
          ],
        ),
      ),
    );

    final circleBackground = Container(
      width: 100.0,
      height: 100.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100.0),
        color: Color.fromRGBO(255, 255, 255, 0.05),
      ),
    );

    return Stack(
      children: [
        backgroundContainer,
        Positioned(
          top: 90.0,
          left: 30.0,
          child: circleBackground,
        ),
        Positioned(
          top: -40.0,
          right: -30.0,
          child: circleBackground,
        ),
        Positioned(
          bottom: -50.0,
          right: -10.0,
          child: circleBackground,
        ),
        Positioned(
          bottom: 120.0,
          right: 20.0,
          child: circleBackground,
        ),
        Positioned(
          bottom: -50.0,
          left: -20.0,
          child: circleBackground,
        ),
        Container(
          padding: EdgeInsets.only(top: 80.0),
          child: Column(
            children: [
              Icon(
                Icons.person_pin,
                color: Colors.white,
                size: 100.0,
              ),
              SizedBox(
                height: 11.0,
                width: double.infinity,
              ),
              Text(
                'MASH',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25.0,
                  letterSpacing: 3.0,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
