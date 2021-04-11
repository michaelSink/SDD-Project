import 'package:SDD_Project/controller/firebasecontroller.dart';
import 'package:SDD_Project/model/hotline.dart';
import 'package:SDD_Project/model/warningSign.dart';
import 'package:SDD_Project/screens/warningsigns_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'home_screen.dart';
import 'hotline_screen.dart';
import 'settings_screen.dart';
import 'views/mydialog.dart';

class SelfHelp extends StatefulWidget{

  static const routeName = './signIn/homeScreen/selfHelpScreen/'; 

  @override
  State<StatefulWidget> createState() {
    return _SelfHelpState();
  }
}

class _SelfHelpState extends State<SelfHelp>{

  _Controller con;
  FirebaseUser user;

  @override
  void initState() {
    super.initState();
    con = _Controller(this);
  }

  @override
  Widget build(BuildContext context) {

    Map arg = ModalRoute.of(context).settings.arguments;
    user ??= arg['user'];

    return Scaffold(
      appBar: AppBar(
        title: Text('Self Help Resources'),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
        children: [
          InkWell(
            onTap: con.hotlineScreen,
            child: Card(
              elevation: 6,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.phone, size: 35,),
                  SizedBox(height: 10,),
                  Text(
                    "Hotlines",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: con.warningScreen,
            child: Card(
              elevation: 6,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.warning_outlined, size: 35,),
                  SizedBox(height: 10,),
                  Text(
                    "Warning Signs",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
              backgroundColor: Colors.grey,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
              backgroundColor: Colors.grey,
            ),
          ],
          currentIndex: 0,
          onTap: (value) => value == 1 ? con.settings() : con.home(),
        ),
    );
  }
}

class _Controller {
  _SelfHelpState _state;
  _Controller(this._state);

  void settings() async{
    await Navigator.pushNamed(_state.context, SettingsScreen.routeName,
              arguments: {'user' : _state.user});
  }

  void home() async{
    await Navigator.pushNamed(_state.context, HomeScreen.routeName,
                arguments: {'user' : _state.user});
  }

  void hotlineScreen() async {
    try {
      List<Hotline> hotlines =
          await FirebaseController.getHotlines(_state.user.uid);
      Navigator.pushNamed(_state.context, HotlineScreen.routeName,
          arguments: {'hotlines': hotlines, 'user': _state.user});
    } catch (e) {
      MyDialog.info(
        context: _state.context,
        title: 'Error getting hotlines',
        content: e.message ?? e.toString(),
      );
    }
  }
  
  void warningScreen() async{
    try{

      List<WarningSign> signs = await FirebaseController.getWarningSigns(_state.user.uid);

      await Navigator.pushNamed(_state.context, WarningSigns.routeName,
        arguments: {'user' : _state.user, 'signs' : signs});
    }catch(e){
      MyDialog.info(
        title: 'Error',
        context: _state.context,
        content: e.toString()
      );
    }
  }

}