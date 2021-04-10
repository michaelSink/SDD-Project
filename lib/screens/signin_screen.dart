import 'package:SDD_Project/controller/Authentication.dart';
import 'package:SDD_Project/controller/firebasecontroller.dart';
import 'package:SDD_Project/screens/home_screen.dart';
import 'package:SDD_Project/screens/signup_screen.dart';
import 'package:SDD_Project/screens/views/mydialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignInScreen extends StatefulWidget {
  static const routeName = './signInScreen';

  @override
  State<StatefulWidget> createState() {
    return _SignInState();
  }
}

class _SignInState extends State<SignInScreen> {
  _Controller con;
  var formKey = GlobalKey<FormState>();
  FirebaseUser user;
  bool remember = false;
  var prefs;

  @override
  void initState() {
    super.initState();
    con = _Controller(this);
    con.checkCredentials();
  }

  void render(fn) => setState(fn);

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
              SizedBox(
                height: 15,
              ),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Email',
                ),
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
                validator: con.validatorEmail,
                onSaved: con.onSavedEmail,
              ),
              SizedBox(
                height: 7.5,
              ),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Password',
                ),
                obscureText: true,
                autocorrect: false,
                validator: con.validatorPassword,
                onSaved: con.onSavedPassword,
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  Text("Remember Me"),
                  Checkbox(value: remember, onChanged: (value){
                    setState(() {
                      remember = value;
                    });
                  }),
                ],
              ),
              Container(
              width: 350.0,
              height: 60.0,
              padding: const EdgeInsets.only(top: 16.0),
              child: RaisedButton(
                  child: Text(
                    'Sign In',
                    style: TextStyle(fontSize: 20.0, color: Colors.white),
                  ),
                  color: Colors.blue,
                  onPressed: con.signIn,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0)),
                ),
              ),
              Container(
                width: 350.0,
                height: 60.0,
                padding: const EdgeInsets.only(top: 16.0),
                // ignore: deprecated_member_use
                child: RaisedButton(
                  child: Text(
                    'Sign In With Google',
                    style: TextStyle(fontSize: 20.0, color: Colors.white),
                  ),
                  color: Colors.blue,
                  onPressed: () {
                    signInWithGoogle().then((user) async {
                      this.user = user;
                      print('========google sign in start');
                      var personalCare =
                          await FirebaseController.getPersonalCare(user.email);
                      print('========google call');
                      Navigator.pushReplacementNamed(
                          context, HomeScreen.routeName, arguments: {
                        'user': user,
                        'personalCareList': personalCare
                      });
                      print('========google sign in finish');
                    });
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0)),
                ),
              ),
              SizedBox(
                height: 30.0,
              ),
              FlatButton(
                onPressed: con.signUp,
                child: Text(
                  'No account yet? Sign Up',
                  style: TextStyle(fontSize: 15.0),
                ),
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

  void signIn() async {
    if (!_state.formKey.currentState.validate()) {
      return;
    }

    _state.formKey.currentState.save();

    if(_state.remember){
      _state.prefs.setBool('remember', true);
      _state.prefs.setString('username', email);
      _state.prefs.setString('password', password);
    }else{
      _state.prefs.setBool('remember', false);
    }

    MyDialog.circularProgressStart(_state.context);
    FirebaseUser user;
    try {
      user = await FirebaseController.signIn(email, password);
      print('User: $user');
    } catch (e) {
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

  void checkCredentials() async{
    _state.prefs = await SharedPreferences.getInstance();

    _state.remember = _state.prefs.getBool('remember') ?? false;

    if(_state.remember){
      
      MyDialog.circularProgressStart(_state.context);

      String userName = _state.prefs.getString('username');
      String password = _state.prefs.getString('password');

      FirebaseUser user;

      try{
        user = await FirebaseController.signIn(userName, password);
        MyDialog.circularProgressEnd(_state.context);
        Navigator.pushReplacementNamed(_state.context, HomeScreen.routeName,
          arguments: {'user': user});
      }catch(e){
        MyDialog.circularProgressEnd(_state.context);
      }

    }
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

  void signUp() async {
    Navigator.pushNamed(_state.context, SignUpScreen.routeName);
  }
}
