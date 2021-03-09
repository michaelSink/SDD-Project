import 'package:SDD_Project/controller/firebasecontroller.dart';
import 'package:SDD_Project/model/medicalHistory.dart';
import 'package:SDD_Project/screens/views/mydialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddFamilyHistory extends StatefulWidget{

  static const routeName = './signIn/homeScreen/familyHistory/addFamilyHistory/';

  @override
  State<StatefulWidget> createState() {
    return _AddFamilyHistoryState();
  }
}

class _AddFamilyHistoryState extends State<AddFamilyHistory>{

  _Controller con;
  FirebaseUser user;
  List<MedicalHistory> history;
  var formKey = GlobalKey<FormState>();
  bool hereditary = false;
  bool maternal = false;
  bool paternal = false;
  bool neither = true;

  @override
  void initState() {
    super.initState();
    con = _Controller(this);
  }

  @override
  Widget build(BuildContext context) {
    Map args = ModalRoute.of(context).settings.arguments;
    user ??= args['user'];
    history ??= args['history'];

    return Scaffold(
      appBar: AppBar(
        title: Text('Add Family History'),
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: con.save,
          ),
        ],
      ),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Divider(height: 8.0,),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Medical Diagnosis',
                ),
                autocorrect: false,
                validator: con.validateDiagnosis,
                onSaved: con.onSavedDiagnosis,
              ),
              Divider(height: 8.0,),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Family Members Diagnosed (Comma seperated list)',
                ),
                autocorrect: false,
                onSaved: con.onSavedFamilyMembers,
              ),
              CheckboxListTile(
                title: Text('Is this hereditary?'),
                value: hereditary,
                onChanged: (val){
                  setState(() {
                    hereditary = val;
                  });
                },
              ),
              Text("Check one of the following", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
              CheckboxListTile(
                title: Text('Maternal'),
                value: maternal,
                onChanged: (val){
                  setState(() {
                    maternal = true;
                    paternal = false;
                    neither = false;
                  });
                },
              ),
              CheckboxListTile(
                title: Text('Paternal'),
                value: paternal,
                onChanged: (val){
                  setState(() {
                    maternal = false;
                    paternal = true;
                    neither = false;
                  });
                },
              ),
              CheckboxListTile(
                title: Text('Neither'),
                value: neither,
                onChanged: (val){
                  setState(() {
                    maternal = false;
                    paternal = false;
                    neither = true;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Controller{
  _AddFamilyHistoryState _state;
  _Controller(this._state);

  String diagnosis;
  List<String> familyMmebers;

void save() async {

      if (!_state.formKey.currentState.validate()) {
        return;
      }

      _state.formKey.currentState.save();

      try{
        
        MyDialog.circularProgressStart(_state.context);

        var familyHistory = new MedicalHistory(
          createdBy: _state.user.uid,
          diagnosis: diagnosis,
          hereditary: _state.hereditary,
          paternal: _state.paternal,
          maternal: _state.maternal,
          membersDiagnosed: familyMmebers,
        );

        familyHistory.docId = await FirebaseController.addFamilyHistory(familyHistory);
        _state.history.insert(0, familyHistory);

        MyDialog.circularProgressEnd(_state.context);
        Navigator.pop(_state.context);

      }catch(e){

        MyDialog.circularProgressEnd(_state.context);
        MyDialog.info(
          context: _state.context,
          title: 'Error uploading diagnosis.',
          content: e.message ?? e.toString(),
        );

      }

  }

  //OnSaved
  void onSavedDiagnosis(String value){
    this.diagnosis = value.trim();
  }

  void onSavedFamilyMembers(String value){
    this.familyMmebers = value.split(',').map((e) => e.trim()).toList();
  }

  //Validators
  String validateDiagnosis(String value){
    if(value == null || value.trim().length < 4){
      return 'Invalid diagnosis, must be at least 4 characters.';
    }
    return null;
  }

}