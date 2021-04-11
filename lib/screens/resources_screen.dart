import 'package:SDD_Project/controller/firebasecontroller.dart';
import 'package:SDD_Project/model/journal.dart';
import 'package:SDD_Project/screens/views/mydialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'calender_screen.dart';
import 'home_screen.dart';
import 'journal_screen.dart';
import 'settings_screen.dart';

class ResourceScreen extends StatefulWidget{

  static const routeName = './signIn/homeScreen/resourceScreen/'; 

  @override
  State<StatefulWidget> createState() {
    return _ResourceScreenState();
  }
}

class _ResourceScreenState extends State<ResourceScreen>{

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
        title: Text('Resources'),
      ),
      body: GridView.count(
        padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
        crossAxisCount: 2,
        children: [
            InkWell(
              onTap: con.calender,
              child: Card(
                elevation: 6,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.calendar_today_rounded, size: 35,),
                    SizedBox(height: 10,),
                    Text(
                      "Calender",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: con.journalScreen,
              child: Card(
                elevation: 6,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.book, size: 35,),
                    SizedBox(height: 10,),
                    Text(
                      "Journal",
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

class _Controller{
  _ResourceScreenState _state;
  _Controller(this._state);

  void settings() async{
    await Navigator.pushNamed(_state.context, SettingsScreen.routeName,
              arguments: {'user' : _state.user});
  }

  void home() async{
    await Navigator.pushNamed(_state.context, HomeScreen.routeName,
                arguments: {'user' : _state.user});
  }

  void journalScreen() async {
    try {
      List<Journal> journal =
          await FirebaseController.getJournal(_state.user.email);
      await Navigator.pushNamed(_state.context, JournalScreen.routeName,
          arguments: {'user': _state.user.email, 'journal': journal});
    } catch (e) {
      MyDialog.info(
        context: _state.context,
        content: e.toString(),
        title: 'Error loading Journal Screen',
      );
    }
  }

  void calender() {
    Navigator.pushNamed(_state.context, CalenderScreen.routeName, arguments: {'user': _state.user});
  }

}