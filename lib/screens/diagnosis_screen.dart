import 'package:SDD_Project/controller/firebasecontroller.dart';
import 'package:SDD_Project/model/diagnosis.dart';
import 'package:SDD_Project/screens/adddiagnosis_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:SDD_Project/screens/editDiagnosis_screen.dart';
import 'package:flutter/material.dart';

import 'views/mydialog.dart';

class DiagnosisScreen extends StatefulWidget{

  static const routeName = './signIn/homeScreen/diagnosis/';

  @override
  State<StatefulWidget> createState() {
    return _DiagnosisScreenState();
  }
}

class _DiagnosisScreenState extends State<DiagnosisScreen>{

  _Controller con;
  FirebaseUser user;
  List<Diagnosis> diagnoses;
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
    diagnoses ??= args['diagnoses'];

    return Scaffold(
      appBar: AppBar(
        title: Text('Diagnosis'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: selectedIndex != -1 ? con.editDiagnosis : null,
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: selectedIndex != -1 ? con.deleteDiagnosis : null,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: diagnoses.length,
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
              children: [
                ListTile(
                  leading: Icon(Icons.note),
                  title: Text(diagnoses[index].diagnosedFor),
                  subtitle: Text("By: " + diagnoses[index].diagnosedBy + " at " + diagnoses[index].diagnosedAt),
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: ExpansionTile(
                    title: Text("More Info"),
                    children: [
                          RichText(
                            text: TextSpan(
                              style: TextStyle(
                                color: Colors.black,
                              ),
                              children: [
                                TextSpan(text: "Diagnosed At: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                                TextSpan(text: "${diagnoses[index].diagnosedAt}"),
                              ]
                            ),
                          ),
                        RichText(
                          text: TextSpan(
                            style: TextStyle(
                              color: Colors.black,
                            ),
                            children: [
                              TextSpan(text: "Previous Treatments: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                              diagnoses[index].treatments[0].length == 0 ? 
                                TextSpan(text: "None")
                                :
                                TextSpan(text: "${diagnoses[index].treatments.toString().replaceAll('[', '').replaceAll(']', '')}"),
                            ]
                          ),
                        ),
                        RichText(
                          text: TextSpan(
                            style: TextStyle(
                              color: Colors.black,
                            ),
                            children: [
                              TextSpan(text: "Comments: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                              diagnoses[index].additionalComments.trim().isEmpty ?
                                TextSpan(text: "None")
                              :
                                TextSpan(text: "${diagnoses[index].additionalComments}")
                            ]
                          ),
                        )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: con.addDiagnosis,
        child: Icon(Icons.add),
      ),
    );
  }
}

class _Controller{
  _DiagnosisScreenState _state;
  _Controller(this._state);

  void addDiagnosis() async{
    try{
      await Navigator.pushNamed(_state.context, AddDiagnosis.routeName,
            arguments: {'user': _state.user, 'diagnoses' : _state.diagnoses});

      _state.render((){});
    }catch(e){
      MyDialog.info(
        context: _state.context,
        content: e.message ?? e.toString(),
        title: 'Error',
      );
    }
  }

  void editDiagnosis() async{
        await Navigator.pushNamed(_state.context, EditDiagnosis.routeName,
          arguments: {'diagnosis' : _state.diagnoses[_state.selectedIndex], "user" : _state.user});
    _state.render((){});
  }

  void deleteDiagnosis() async{    
    await FirebaseController.deleteDiagnosis(_state.diagnoses[_state.selectedIndex].docId);
    _state.diagnoses.removeAt(_state.selectedIndex);
    _state.render((){
      _state.selectedIndex = -1;
    });
    MyDialog.info(
      content: "Diagnosis Sucessfully Deleted!",
      context: _state.context,
      title: "Success",
    );
  }

}