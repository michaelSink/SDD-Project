import 'package:flutter/material.dart';

class SignInScreen extends StatefulWidget{

  static const routeName = './signInScreen';

  @override
  State<StatefulWidget> createState() {
    
    return _SignInState();

  }

}

class _SignInState extends State<SignInScreen>{

  @override
  Widget build(BuildContext context) {
   
    return Scaffold(

      appBar: AppBar(

        title: Text("Sign In"),

      ),
      body: Text('Sign In Screen'),

    );

  }

}