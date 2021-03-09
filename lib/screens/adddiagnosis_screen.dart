import 'package:SDD_Project/controller/firebasecontroller.dart';
import 'package:SDD_Project/model/diagnosis.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'views/mydialog.dart';

class AddDiagnosis extends StatefulWidget{

  static const routeName = './signIn/homeScreen/diagnosis/diagnosisHistory';

  @override
  State<StatefulWidget> createState() {
    return _AddDiagnosisState();
  }
}

class _AddDiagnosisState extends State<AddDiagnosis>{

  _Controller con;
  FirebaseUser user;
  List<Diagnosis> diagnoses;
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
    diagnoses ??= args['diagnoses'];

    return Scaffold(
      appBar: AppBar(
        title: Text('Add Diagnosis'),
        actions: [
          IconButton(
            onPressed: con.save,
            icon: Icon(Icons.check),
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
                autocorrect: true,
                validator: con.diagnosisValidator,
                onSaved: con.onSavedDiagnosis,
              ),
              Divider(height: 8.0,),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Diagnosed On YYYY-MM-DD',
                  suffix: Text('YYYY-MM-DD'),
                ),
                autocorrect: false,
                validator: con.validatorDateBeforeToday,
                onSaved: con.onSavedDignosedOn,
              ),
              Divider(height: 8.0,),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Diagnosed By',
                ),
                autocorrect: true,
                validator: con.diagnosedByValidator,
                onSaved: con.onSavedDiagnosedBy,
              ),
              Divider(height: 8.0,),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Diagnosed At',
                ),
                autocorrect: true,
                validator: con.diagnosedAtValidator,
                onSaved: con.onSavedDiagnosedAt,
              ),
              Divider(height: 8.0,),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'List of Treatments (comma seperated list)',
                ),
                autocorrect: false,
                onSaved: con.onSavedTreatments,
              ),
              Divider(height: 8.0,),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Additional Comments',
                ),
                maxLines: 7,
                autocorrect: false,
                onSaved: con.onSavedComments,
              ),
            ],
          ),
        ),
      ),
    );
  }

}

class _Controller{
  _AddDiagnosisState _state;
  _Controller(this._state);

  String diagnosis;
  DateTime diagnosedOn;
  String diagnosedBy;
  String diagnosedAt;
  List<String> treatments;
  String additionalComments;

void save() async {

      if (!_state.formKey.currentState.validate()) {
        return;
      }

      _state.formKey.currentState.save();

      try{
        
        MyDialog.circularProgressStart(_state.context);

        var d = new Diagnosis(
          createdBy: _state.user.uid,
          diagnosedFor: this.diagnosis,
          diagnosedOn: this.diagnosedOn,
          diagnosedBy: this.diagnosedBy,
          diagnosedAt: this.diagnosedAt,
          treatments: this.treatments,
          additionalComments: this.additionalComments,
        );

        d.docId = await FirebaseController.addDiagnosis(d);
        _state.diagnoses.insert(0, d);

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

  //Savers
  void onSavedDiagnosis(String value){
    this.diagnosis = value.trim();
  }

  void onSavedDignosedOn(String value){
    this.diagnosedOn = DateTime.parse(value.trim());
  }

  void onSavedDiagnosedBy(String value){
    this.diagnosedBy = value.trim();
  }

  void onSavedDiagnosedAt(String value){
    this.diagnosedAt = value.trim();
  }

  void onSavedTreatments(String value){
    this.treatments = value.split(',').map((e) => e.trim()).toList();
  }

  void onSavedComments(String value){
    this.additionalComments = value;
  }

  //Validators
  RegExp dateExp = new RegExp("[0-9]{4}[-][0-9]{2}[-][0-9]{2}");

  String diagnosisValidator(String value){
    if(value == null || value.trim().length < 4){
      return 'Invalid diagnosis, must be at least 4 characters.';
    }
    return null;
  }

  String validatorDate(String value){

    if(value == null || value.trim().length != 10 || !dateExp.hasMatch(value.trim())){

      return 'Invalid Date';

    }

    return null;

  }

  String validatorDateBeforeToday(String value){

    String dateValidation = validatorDate(value);
    if(dateValidation != null){

      return dateValidation;

    }else if(DateTime.parse(value.trim()).isAfter(DateTime.now())){

      return 'Date Is Not Before Today, or Today';

    }

    return null;

  }

  String diagnosedByValidator(String value){
    if(value == null || value.trim().length < 6){

      return 'Invalid Diagnoser';

    }

    return null;
  }

  String diagnosedAtValidator(String value){

    if(value == null || value.trim().length < 8){

      return 'Invalid Hospital Address';

    }

    return null;
  }

}