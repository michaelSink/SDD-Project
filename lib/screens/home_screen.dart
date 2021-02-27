import 'package:SDD_Project/controller/firebasecontroller.dart';
import 'package:SDD_Project/screens/contacts_screen.dart';
import 'package:SDD_Project/screens/signin_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:SDD_Project/model/perscription.dart';
import 'package:SDD_Project/screens/hotline_screen.dart';
import 'package:SDD_Project/screens/views/myimageview.dart';
import '../controller/firebasecontroller.dart';
import 'perscription_screen.dart';
import 'signin_screen.dart';
import 'views/mydialog.dart';

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
    super.initState();
    con = _Controller(this);
  }

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

    return  WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Home'),
        ),
        drawer: Drawer(
          child: ListView(
            children: [
              UserAccountsDrawerHeader(
                currentAccountPicture: ClipOval(
                  child: 
                  user.photoUrl != null ? MyImageView.network(
                    imageUrl: user.photoUrl, 
                    context: context
                  )
                  :
                  Image.asset('static/images/default-user.png')
                ),
                accountEmail: Text(user.email),
                accountName: Text(user.displayName ?? 'N/A'),
              ),
              ListTile(
                leading: Icon(Icons.exit_to_app),
                title: Text('Sign Out'),
                onTap: con.signOut,
              ),
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
            Card(
                child: ListTile(
                  leading: FlutterLogo(),
                  title: Text('Perscriptions'),
                  onTap: con.perscriptionScreen,
                ),
            ),

            Card(
                child: ListTile(
                  leading: FlutterLogo(),
                  title: Text('Hotlines'),
                  onTap: con.hotlineScreen,
                ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Controller{
  _HomeState _state;
  _Controller(this._state);

  void perscriptionScreen() async {
    try{
      //Get perscriptions
      List<dynamic> perscriptions = await FirebaseController.getPerscriptions(_state.user.uid);

      await Navigator.pushNamed(_state.context, PerscriptionScreen.routeName,
          arguments: {'user': _state.user, 'perscriptions' : perscriptions});
    }catch(e){
      MyDialog.info(
        context: _state.context,
        content: e.message ?? e.toString(),
        title: 'Error',
      );
    }
  }

  void hotlineScreen() async{
    Navigator.pushNamed(_state.context, HotlineScreen.routeName);
  }

   void accessContacts() async {
    Navigator.pushNamed(_state.context, ContactScreen.routeName);
  }

  void signOut() async {
    try {
      await FirebaseController.signOut();
    } catch (e) {
      print('signOut exception: ${e.message}');
    }
    Navigator.pushReplacementNamed(_state.context, SignInScreen.routeName);
  }
}