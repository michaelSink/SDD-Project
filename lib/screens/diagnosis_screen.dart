import 'package:SDD_Project/model/diagnosis.dart';
import 'package:SDD_Project/screens/adddiagnosis_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'views/mydialog.dart';

class DiagnosisScreen extends StatefulWidget{

  static const routeName = './signIn/homeScreen/diagnosis';

  @override
  State<StatefulWidget> createState() {
    return _DiagnosisScreenState();
  }
}

class _DiagnosisScreenState extends State<DiagnosisScreen>{

  _Controller con;
  FirebaseUser user;
  List<Diagnosis> diagnoses;

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
      ),
      body: ListView.builder(
        itemCount: diagnoses.length,
        itemBuilder: (BuildContext buildContext, int index) => Container(
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
                Text(
                  "${diagnoses[index].diagnosedFor}",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                      color: Colors.black,
                    ),
                    children: [
                      TextSpan(text: "Diagnosed On: ", style: TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(text: "${diagnoses[index].diagnosedOn.year}-${diagnoses[index].diagnosedOn.month.toString().padLeft(2, '0')}-${diagnoses[index].diagnosedOn.day.toString().padLeft(2, '0')}"),
                    ]
                  ),
                ),
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                      color: Colors.black,
                    ),
                    children: [
                      TextSpan(text: "Diagnosed By: ", style: TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(text: "${diagnoses[index].diagnosedBy}"),
                    ]
                  ),
                ),
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                      color: Colors.black,
                    ),
                    children: [
                      TextSpan(text: "Diagnosed At: ", style: TextStyle(fontWeight: FontWeight.bold)),
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
                      TextSpan(text: "Previous Treatments: ", style: TextStyle(fontWeight: FontWeight.bold)),
                      diagnoses[index].treatments.length == 0 ? 
                        TextSpan(text: "${diagnoses[index].treatments.toString().replaceAll('[', '').replaceAll(']', '')}")
                        : TextSpan(text: "None"),
                    ]
                  ),
                ),
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                      color: Colors.black,
                    ),
                    children: [
                      TextSpan(text: "Comments: ", style: TextStyle(fontWeight: FontWeight.bold)),
                      !diagnoses[index].additionalComments.trim().isEmpty ?
                      TextSpan(text: "${diagnoses[index].additionalComments}")
                      :
                      TextSpan(text: "None")
                    ]
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: con.addMedicalHistoryScreen,
        child: Icon(Icons.add),
      ),
    );
  }
}

class _Controller{
  _DiagnosisScreenState _state;
  _Controller(this._state);

  void addMedicalHistoryScreen() async{
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

}