import 'package:SDD_Project/controller/firebasecontroller.dart';
import 'package:SDD_Project/model/medicalHistory.dart';
import 'package:SDD_Project/screens/addFamilyHistory_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'editFamilyHistory_screen.dart';
import 'views/mydialog.dart';

class FamilyHistory extends StatefulWidget{

  static const routeName = './signIn/homeScreen/familyHistory/';

  @override
  State<StatefulWidget> createState() {
    return _FamilyHistoryState();
  }
}

class _FamilyHistoryState extends State<FamilyHistory>{

  _Controller con;
  FirebaseUser user;
  List<MedicalHistory> history;
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
    history ??= args['history'];

    return Scaffold(
      appBar: AppBar(
        title: Text('Family History'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: selectedIndex != -1 ? con.editHistory : null,
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: selectedIndex != -1 ? con.deleteHistory : null,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: history.length,
        itemBuilder: (BuildContext buildContext, int index) => InkWell(
          onLongPress: () {
            render((){
              selectedIndex = index;
            });
          },
          onTap: (){
            render((){
              selectedIndex = -1;
            });
          },
          child: Card(
            color: selectedIndex == index ? Colors.blue[200] : Colors.white,
            margin: EdgeInsets.all(8),
            clipBehavior: Clip.antiAlias,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  leading: Icon(Icons.people),
                  title: Text(history[index].diagnosis, style: TextStyle(fontWeight: FontWeight.bold),),
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: ExpansionTile(
                    expandedCrossAxisAlignment: CrossAxisAlignment.start,
                    title: Text("More Info"),
                    children: [
                          RichText(
                            text: TextSpan(
                              style: TextStyle(
                                color: Colors.black,
                              ),
                              children: [
                              TextSpan(text: "Family Members: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                              history[index].membersDiagnosed[0].length == 0 ? 
                                TextSpan(text: "None")
                                :
                                TextSpan(text: "${history[index].membersDiagnosed.toString().replaceAll('[', '').replaceAll(']', '')}"),
                              ]
                            ),
                          ),
                        history[index].hereditary == true ? Text("• Diagnosis is hereditary!", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),) : Container(),
                        history[index].maternal == true ? Text("• Diagnosis is maternal!", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),) : Container(),
                        history[index].paternal == true ? Text("• Diagnosis is paternal!", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),) : Container(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: con.addFamilyHistory,
        child: Icon(Icons.add),
      ),
    );
  }
}

class _Controller{
  _FamilyHistoryState _state;
  _Controller(this._state);

  void addFamilyHistory() async{

    try{
      await Navigator.pushNamed(_state.context, AddFamilyHistory.routeName,
              arguments: {'user' : _state.user, 'history' : _state.history});
      _state.render((){});
    }catch(e){
      print(e);
    }

  }

  void editHistory() async{

    try{
      await Navigator.pushNamed(_state.context, EditFamilyHistory.routeName, 
              arguments: {'user' : _state.user, 'history' : _state.history[_state.selectedIndex]});
      _state.render((){});
    }catch(e){
      MyDialog.info(
        content: "Error updating history",
        context: _state.context,
        title: "Error",
      );
    }

  }

  void deleteHistory() async{

    await FirebaseController.deleteHistory(_state.history[_state.selectedIndex].docId);
    _state.history.removeAt(_state.selectedIndex);
    _state.render((){
      _state.selectedIndex = -1;
    });
    MyDialog.info(
      content: "Family History Sucessfully Deleted!",
      context: _state.context,
      title: "Success",
    );

  }

}