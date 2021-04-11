import 'package:SDD_Project/controller/firebasecontroller.dart';
import 'package:SDD_Project/model/contacts.dart';
import 'package:SDD_Project/model/location.dart';
import 'package:SDD_Project/model/vault.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'contacts_screen.dart';
import 'feelgoodvault_screen.dart';
import 'home_screen.dart';
import 'location_screen.dart';
import 'settings_screen.dart';
import 'views/mydialog.dart';

class CommunitySupport extends StatefulWidget{

  static const routeName = './signIn/homeScreen/communitySupport/';

  @override
  State<StatefulWidget> createState() {
    return _CommunitySupportState();
  }
}

class _CommunitySupportState extends State<CommunitySupport>{

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
        title: Text('Community Support'),
      ),
      body: GridView.count(
        padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
        crossAxisCount: 2,
        children: [
            InkWell(
              onTap: con.locationScreen,
              child: Card(
                elevation: 6,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.house, size: 35,),
                    SizedBox(height: 10,),
                    Text(
                      "Social Settings",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: con.accessContacts,
              child: Card(
                elevation: 6,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.person, size: 35,),
                    SizedBox(height: 10,),
                    Text(
                      "Contacts",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: con.accessVault,
              child: Card(
                elevation: 6,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.wb_sunny, size: 35,),
                    SizedBox(height: 10,),
                    Text(
                      "Feel Good Vault",
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
  _CommunitySupportState _state;
  _Controller(this._state);

    void settings() async{
      await Navigator.pushNamed(_state.context, SettingsScreen.routeName,
                arguments: {'user' : _state.user});
    }

    void home() async{
      await Navigator.pushNamed(_state.context, HomeScreen.routeName,
                  arguments: {'user' : _state.user});
    }

    void locationScreen() async{
    try{

      List<Location> locations = await FirebaseController.getLocations(_state.user.uid);

      await Navigator.pushNamed(_state.context, LocationScreen.routeName,
                arguments: {'locations' : locations, 'user' : _state.user});
    }catch(e){
      MyDialog.info(
        title: 'Error',
        context: _state.context,
        content: e.toString()
      );
    }
  }

  void accessContacts() async {
    try {
      List<Contacts> contacts =
          await FirebaseController.getContacts(_state.user.email);
      await Navigator.pushNamed(_state.context, ContactScreen.routeName,
          arguments: {'user': _state.user.email, 'contacts': contacts});
    } catch (e) {
      MyDialog.info(
        context: _state.context,
        content: e.toString(),
        title: 'Error loading Contact Screen',
      );
    }
  }

  void accessVault() async {
    try {
      Vault vault = await FirebaseController.getVault(_state.user.email);
      if(vault == null){
        vault = Vault(owner: _state.user.email);
        vault.docId = await FirebaseController.createVault(vault);
      }

      await Navigator.pushNamed(_state.context, FeelGoodVault.routeName,arguments: {'user': _state.user.email, "vault": vault});
    } catch (e) {
      MyDialog.info(
        context: _state.context,
        content: e.toString(),
        title: 'Error loading Vault',
      );
    }
  }
}