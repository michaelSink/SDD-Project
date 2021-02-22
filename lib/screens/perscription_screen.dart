import 'package:SDD_Project/model/perscription.dart';
import 'package:SDD_Project/screens/perscriptionDetails_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'addperscription_screen.dart';

class PerscriptionScreen extends StatefulWidget{

  static const routeName = '/signIn/homeScreen/perscriptionScreen/';

  @override
  State<StatefulWidget> createState() {
    return _PerscriptionState();
  }

}

class _PerscriptionState extends State<PerscriptionScreen>{

  FirebaseUser user;
  List<Perscription> perscriptions;
  _Controller con;

  @override
  void initState() {
    super.initState();
    con = _Controller(this);
  }

  void render(fn) => setState(fn);

  @override
  Widget build(BuildContext context) {

    Map arg = ModalRoute.of(context).settings.arguments;
    user ??= arg['user'];
    perscriptions ??= arg['perscriptions'];

    return Scaffold(
      appBar: AppBar(
        title: Text('Perscriptions'),
      ),
      body: perscriptions.length == 0
        ? Text(
            'No Perscriptions',
            style: TextStyle(fontSize: 30.0),
          )
        : ListView.builder(
            itemCount: perscriptions.length,
            itemBuilder: (BuildContext context, int index) => Container(
              padding: EdgeInsets.all(4.0),
              child: Card(
                elevation: 4.0,
                  child: ListTile(
                    onTap: () => con.perscriptionDetails(index),
                    leading: Icon(Icons.add),
                    trailing: Icon(Icons.arrow_forward),
                    title: Text("Perscription for " + perscriptions[index].drugName),
                    subtitle: Text("Perscribed by: " + perscriptions[index].perscriber),
                  ),
              ),
            ),
          ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: con.addScreen,
      ),
    );
  }

}

class _Controller{

  _PerscriptionState _state;
  _Controller(this._state);

  void addScreen() async{

    await Navigator.pushNamed(_state.context, AddPerscriptionScreen.routeName,
      arguments: {'user' : _state.user, 'perscriptions': _state.perscriptions});
    _state.render((){});

  }

  void perscriptionDetails(int index) async{
    await Navigator.pushNamed(_state.context, PerscriptionDetails.routeName,
      arguments: {'perscription' : _state.perscriptions[index]});
  }

}