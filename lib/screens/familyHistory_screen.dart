import 'package:SDD_Project/model/medicalHistory.dart';
import 'package:SDD_Project/screens/addFamilyHistory_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
      ),
      body: ListView.builder(
        itemCount: history.length,
        itemBuilder: (BuildContext context, int index) => Container(
          margin: EdgeInsets.all(8),
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(width: 3, color: Colors.black),
              bottom: BorderSide(width: 3, color: Colors.black),
              left: BorderSide(width: 3, color: Colors.black),
              right: BorderSide(width: 3, color: Colors.black),
            ),
          ),
          child: Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                    ),
                    children: [
                      TextSpan(text: "Diagnosis: ", style: TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(text: "${history[index].diagnosis}"),
                    ]
                  ),
                ),
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                    ),
                    children: [
                      TextSpan(text: "Affected: ", style: TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(text: "${history[index].membersDiagnosed.toString().replaceAll('[', '').replaceAll(']', '')}"),
                    ]
                  ),
                ),
                Divider(height: 8,),
                history[index].hereditary == true ? Text("Diagnosis is hereditary.", style: TextStyle(fontWeight: FontWeight.bold),) : Container(),
                history[index].paternal == true ? Text("Diagnosis is paternal.", style: TextStyle(fontWeight: FontWeight.bold),) : Container(),
                history[index].maternal == true ? Text("Diagnosis is maternal.", style: TextStyle(fontWeight: FontWeight.bold),) : Container(),
              ],
            ),
          ),
        ),),
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

}