import 'package:SDD_Project/controller/firebasecontroller.dart';
import 'package:SDD_Project/screens/home_screen.dart';
import 'package:SDD_Project/screens/views/mydialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignInScreen extends StatefulWidget{

  static const routeName = './signInScreen';

  @override
  State<StatefulWidget> createState() {
    
    return _SignInState();

  }

}

class _SignInState extends State<SignInScreen>{

  _Controller con;
  var formKey = GlobalKey<FormState>();

  @override
  void initState(){
    super.initState();
    con = _Controller(this);
  }

  @override
  Widget build(BuildContext context) {
   
    return Scaffold(

      appBar: AppBar(

        title: Text("Sign In"),

      ),
      body: SingleChildScrollView(

        child: Form(

          key: formKey,
          child: Column(

            children: [
              Container(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Personal Care',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  ),
              ),
              SizedBox(height: 15,),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Email',
                ),
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
                validator: con.validatorEmail,
                onSaved: con.onSavedEmail,
              ),
              SizedBox(height: 7.5,),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Password',
                ),
                obscureText: true,
                autocorrect: false,
                validator: con.validatorPassword,
                onSaved: con.onSavedPassword,
              ),
              SizedBox(height: 15,),
              RaisedButton(
                child: Text(
                  'Sign In',
                  style: TextStyle(fontSize: 20.0, color: Colors.white),
                ),
                color: Colors.blue,
                onPressed: con.signIn,
              ),

            ],

          ),

        ),

      ),

    );

  }

}

class _Controller {

  _SignInState _state;
  _Controller(this._state);
  String email;
  String password;

  void signIn() async{

    if(!_state.formKey.currentState.validate()){
      return;
    }

    _state.formKey.currentState.save();

    MyDialog.circularProgressStart(_state.context);
    FirebaseUser user;
    try{

      user = await FirebaseController.signIn(email, password);
      print('User: $user');

    }catch(e){

      MyDialog.circularProgressEnd(_state.context);
      MyDialog.info(
        context: _state.context,
        content: e.message ?? e.toString(),
        title: 'Sign In Error',
      );
      return;

    }

    MyDialog.circularProgressEnd(_state.context);
    
    Navigator.pushReplacementNamed(_state.context, HomeScreen.routeName,
        arguments: {'user': user});

  }

  String validatorEmail(String value) {
    if (value == null || !value.contains('@') || !value.contains('.')) {
      return 'Invalid email address';
    } else {
      return null;
    }
  }

  void onSavedEmail(String value) {
    email = value.trim();
  }

  String validatorPassword(String value) {
    if (value == null || value.trim().length < 6) {
      return 'Invalid Password Format';
    } else {
      return null;
    }
  }

  void onSavedPassword(String value) {
    password = value.trim();
  }

}