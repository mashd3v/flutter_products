import 'package:flutter/material.dart';

bool isNumeric(String s){
  final n = num.tryParse(s);
  
  if(s.isEmpty) return false;
  return (n == null) ? false : true;
}

void showAlert(BuildContext context, String message){
  showDialog(
    context: context,
    builder: (context){
      return AlertDialog(
        title: Text('Error!'),
        content: Text(message),
        actions: [
          FlatButton(
            child: Text('Ok'),
            onPressed: () => Navigator.of(context).pop(), 
          ),
        ],
      );
    }
  );
}