import 'package:SDD_Project/controller/firebasecontroller.dart';
import 'package:SDD_Project/screens/contacts_screen.dart';
import 'package:SDD_Project/screens/signin_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = './signIn/homeScreen/';

  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<HomeScreen> {
  _Controller con;
  FirebaseUser user;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    con = _Controller(this);
  }

  @override
  Widget build(BuildContext context) {
    Map arg = ModalRoute.of(context).settings.arguments;
    user ??= arg['user'];

    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(user.displayName ?? 'N/A'),
              accountEmail: Text(user.email),
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Sign Out'),
              onTap: con.signOut,
            )
          ],
        ),
      ),
      body: Column(
        children: [
          FlatButton(
            onPressed: con.accessContacts, //access contacts,
            color: Colors.blue[600],
            child: Icon(
              Icons.accessibility_new,
            ),
          ),
        ],
      ),
    );
  }
}

class _Controller {
  _HomeState _state;
  _Controller(this._state);

  void signOut() async {
    try {
      await FirebaseController.signOut();
    } catch (e) {
      // do nothing
    }
    Navigator.of(_state.context).pop();
    Navigator.pushReplacementNamed(_state.context, SignInScreen.routeName);
  }

  void accessContacts() async {
    Navigator.pushNamed(_state.context, ContactScreen.routeName);
  }
}
