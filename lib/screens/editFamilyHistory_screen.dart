import 'package:SDD_Project/controller/firebasecontroller.dart';
import 'package:SDD_Project/model/medicalHistory.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'views/mydialog.dart';

class EditFamilyHistory extends StatefulWidget{

  static const routeName = './signIn/homeScreen/familyHistory/editFamilyHistory';

  @override
  State<StatefulWidget> createState() {
    return _EditFamilyScreenState();
  }
}

class _EditFamilyScreenState extends State<EditFamilyHistory>{

  _Controller con;
  FirebaseUser user;
  MedicalHistory history;
  bool neither;
  var formKey = GlobalKey<FormState>();

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
        title: Text('Edit Family History'),
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
                initialValue: history.diagnosis,
                autocorrect: false,
                validator: con.validateDiagnosis,
                onSaved: con.onSavedDiagnosis,
              ),
              Divider(height: 8.0,),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Family Members Diagnosed (Comma seperated list)',
                ),
                initialValue: history.membersDiagnosed.toString().replaceFirst("[", "").replaceAll("]", ""),
                autocorrect: false,
                onSaved: con.onSavedFamilyMembers,
                validator: con.validatorDiagnosedMembers,
              ),
              CheckboxListTile(
                title: Text('Is this hereditary?'),
                value: history.hereditary,
                onChanged: (val){
                  setState(() {
                    history.hereditary = val;
                  });
                },
              ),
              Text("Check one of the following", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
              CheckboxListTile(
                title: Text('Maternal'),
                value: history.maternal,
                onChanged: (val){
                  setState(() {
                    history.maternal = true;
                    history.paternal = false;
                    neither = false;
                  });
                },
              ),
              CheckboxListTile(
                title: Text('Paternal'),
                value: history.paternal,
                onChanged: (val){
                  setState(() {
                    history.maternal = false;
                    history.paternal = true;
                    neither = false;
                  });
                },
              ),
              CheckboxListTile(
                title: Text('Neither'),
                value: history.maternal == false && history.paternal == false ? true : false,
                onChanged: (val){
                  setState(() {
                    history.maternal = false;
                    history.paternal = false;
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

  _EditFamilyScreenState _state;
  _Controller(this._state);

void save() async {

      if (!_state.formKey.currentState.validate()) {
        return;
      }

      _state.formKey.currentState.save();

      try{
        
        MyDialog.circularProgressStart(_state.context);

        await FirebaseController.updateFamilyHistory(_state.history);

        MyDialog.circularProgressEnd(_state.context);
        Navigator.pop(_state.context);

      }catch(e){

        MyDialog.circularProgressEnd(_state.context);
        MyDialog.info(
          context: _state.context,
          title: 'Error uploading family history.',
          content: e.message ?? e.toString(),
        );

      }

  }

  //OnSaved
  void onSavedDiagnosis(String value){
    _state.history.diagnosis = value.trim();
  }

  void onSavedFamilyMembers(String value){
    _state.history.membersDiagnosed = value.split(',').map((e) => e.trim()).toList();
  }

  //Validators
  String validateDiagnosis(String value){
    if(value == null || value.trim().length < 4){
      return 'Invalid diagnosis, must be at least 4 characters.';
    }
    return null;
  }

  String validatorDiagnosedMembers(String value){
    if(value == null || value.trim().length < 3){
      return "Invalid Family Members List.";
    }
    return null;
  }

}