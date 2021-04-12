import 'package:SDD_Project/controller/firebasecontroller.dart';
import 'package:SDD_Project/model/mental_health.dart';
import 'package:SDD_Project/screens/addMentalHealth.dart';
import 'package:SDD_Project/screens/editMentalHealth_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'views/mydialog.dart';

class MentalHealthScreen extends StatefulWidget {
  static const routeName = '/signIn/homeScreen/mentalHealth/';

  @override
  State<StatefulWidget> createState() {
    return _MentalHealthScreen();
  }
}

class _MentalHealthScreen extends State<MentalHealthScreen> {
  _Controller con;
  FirebaseUser user;
  List<MentalHealth> mentalHealth;
  int selectedIndex = -1;

  @override
  void initState() {
    super.initState();
    con = _Controller(this);
  }

  void render(fn) => setState(fn);

  @override
  Widget build(BuildContext context) {
    Map args = ModalRoute.of(context).settings.arguments;
    user ??= args['user'];
    mentalHealth ??= args['mentalHealth'];

    return Scaffold(
      appBar: AppBar(
        title: Text('Mental Health Factors'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: selectedIndex != -1 ? con.editMentalHealth : null,
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: selectedIndex != -1 ? con.deleteMentalHealth : null,
          ),
        ],
      ),
      body: mentalHealth == null ? Container() :
      ListView.builder(
        itemCount: mentalHealth.length,
        itemBuilder: (BuildContext buildContext, int index) => InkWell(
          onLongPress: () {
            render(() {
              selectedIndex = index;
            });
          },
          onTap: () {
            render(() {
              selectedIndex = -1;
            });
          },
          child: Card(
            color: selectedIndex == index ? Colors.blue[200] : Colors.white,
            margin: EdgeInsets.all(8),
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.note),
                  title: Text(mentalHealth[index].description),
                  subtitle: mentalHealth[index].acute == true ? Text("Acute") : Text("Chronic"),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: con.addMentalHealth,
        child: Icon(Icons.add),
      ),
    );
  }
}

class _Controller {
  _MentalHealthScreen _state;
  _Controller(this._state);

  void addMentalHealth() async {
    try {
      await Navigator.pushNamed(_state.context, AddMentalHealth.routeName,
          arguments: {
            'user': _state.user,
            'mentalHealth': _state.mentalHealth
          });

      _state.render(() {});
    } catch (e) {
      MyDialog.info(
        context: _state.context,
        content: e.message ?? e.toString(),
        title: 'Error',
      );
    }
  }

  void editMentalHealth() async {
    await Navigator.pushNamed(_state.context, EditMentalHealth.routeName,
        arguments: {
          'mentalHealth': _state.mentalHealth[_state.selectedIndex],
          "user": _state.user
        });
    _state.render(() {});
  }

  void deleteMentalHealth() async {
    await FirebaseController.deleteMentalHealth(
        _state.mentalHealth[_state.selectedIndex].docId);
    _state.mentalHealth.removeAt(_state.selectedIndex);
    _state.render(() {
      _state.selectedIndex = -1;
    });
    MyDialog.info(
      content: "Mental Health Factor Sucessfully Deleted!",
      context: _state.context,
      title: "Success",
    );
  }
}
