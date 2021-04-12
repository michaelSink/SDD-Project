import 'package:SDD_Project/controller/firebasecontroller.dart';
import 'package:SDD_Project/model/diagnosis.dart';
import 'package:SDD_Project/screens/views/mydialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EditDiagnosis extends StatefulWidget {
  static const routeName = "./signIn/homeScreen/diagnosis.editDiagnosis/";

  @override
  State<StatefulWidget> createState() {
    return _EditDiagnosisState();
  }
}

class _EditDiagnosisState extends State<EditDiagnosis> {
  FirebaseUser user;
  _Controller con;
  Diagnosis diagnosis;
  var formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    con = _Controller(this);
  }

  @override
  Widget build(BuildContext context) {
    Map arg = ModalRoute.of(context).settings.arguments;
    user ??= arg['user'];
    diagnosis ??= arg['diagnosis'];

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Diagnosis'),
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
              Divider(
                height: 8.0,
              ),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Medical Diagnosis',
                ),
                initialValue: diagnosis.diagnosedFor,
                autocorrect: true,
                validator: con.diagnosisValidator,
                onSaved: con.onSavedDiagnosis,
              ),
              Divider(
                height: 8.0,
              ),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Diagnosed On YYYY-MM-DD',
                  suffix: Text('YYYY-MM-DD'),
                ),
                initialValue:
                    "${diagnosis.diagnosedOn.year.toString()}-${diagnosis.diagnosedOn.month.toString().padLeft(2, '0')}-${diagnosis.diagnosedOn.day.toString().padLeft(2, '0')}",
                autocorrect: false,
                validator: con.validatorDateBeforeToday,
                onSaved: con.onSavedDignosedOn,
              ),
              Divider(
                height: 8.0,
              ),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Diagnosed By',
                ),
                initialValue: diagnosis.diagnosedBy,
                autocorrect: true,
                validator: con.diagnosedByValidator,
                onSaved: con.onSavedDiagnosedBy,
              ),
              Divider(
                height: 8.0,
              ),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Diagnosed At',
                ),
                initialValue: diagnosis.diagnosedAt,
                autocorrect: true,
                validator: con.diagnosedAtValidator,
                onSaved: con.onSavedDiagnosedAt,
              ),
              Divider(
                height: 8.0,
              ),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'List of Treatments (comma seperated list)',
                ),
                initialValue: diagnosis.treatments
                    .toString()
                    .replaceFirst("[", "")
                    .replaceAll("]", ""),
                autocorrect: false,
                onSaved: con.onSavedTreatments,
              ),
              Divider(
                height: 8.0,
              ),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'List of Coping Strategies (comma seperated list)',
                ),
                initialValue: diagnosis.copingStrategies
                    .toString()
                    .replaceFirst("[", "")
                    .replaceAll("]", ""),
                autocorrect: false,
                onSaved: con.onSavedCopingStrategies,
              ),
              Divider(
                height: 8.0,
              ),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Additional Comments',
                ),
                initialValue: diagnosis.additionalComments,
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

class _Controller {
  _EditDiagnosisState _state;
  _Controller(this._state);

  void save() async {
    if (!_state.formKey.currentState.validate()) {
      return;
    }

    _state.formKey.currentState.save();

    try {
      MyDialog.circularProgressStart(_state.context);
      await FirebaseController.updateDiagnosis(_state.diagnosis);
      MyDialog.circularProgressEnd(_state.context);
      Navigator.pop(_state.context);
    } catch (e) {
      MyDialog.circularProgressEnd(_state.context);
      MyDialog.info(
        context: _state.context,
        title: 'Error uploading prescription.',
        content: e.message ?? e.toString(),
      );
    }
  }

  //Savers
  void onSavedDiagnosis(String value) {
    _state.diagnosis.diagnosedFor = value.trim();
  }

  void onSavedDignosedOn(String value) {
    _state.diagnosis.diagnosedOn = DateTime.parse(value.trim());
  }

  void onSavedDiagnosedBy(String value) {
    _state.diagnosis.diagnosedBy = value.trim();
  }

  void onSavedDiagnosedAt(String value) {
    _state.diagnosis.diagnosedAt = value.trim();
  }

  void onSavedTreatments(String value) {
    _state.diagnosis.treatments =
        value.split(',').map((e) => e.trim()).toList();
  }

  void onSavedCopingStrategies(String value) {
    _state.diagnosis.copingStrategies =
        value.split(',').map((e) => e.trim()).toList();
  }

  void onSavedComments(String value) {
    _state.diagnosis.additionalComments = value;
  }

  //Validators
  RegExp dateExp = new RegExp("[0-9]{4}[-][0-9]{2}[-][0-9]{2}");

  String diagnosisValidator(String value) {
    if (value == null || value.trim().length < 4) {
      return 'Invalid diagnosis, must be at least 4 characters.';
    }
    return null;
  }

  String validatorDate(String value) {
    if (value == null ||
        value.trim().length != 10 ||
        !dateExp.hasMatch(value.trim())) {
      return 'Invalid Date';
    }

    return null;
  }

  String validatorDateBeforeToday(String value) {
    String dateValidation = validatorDate(value);
    if (dateValidation != null) {
      return dateValidation;
    } else if (DateTime.parse(value.trim()).isAfter(DateTime.now())) {
      return 'Date Is Not Before Today, or Today';
    }

    return null;
  }

  String diagnosedByValidator(String value) {
    if (value == null || value.trim().length < 6) {
      return 'Invalid Diagnoser';
    }

    return null;
  }

  String diagnosedAtValidator(String value) {
    if (value == null || value.trim().length < 8) {
      return 'Invalid Hospital Address';
    }

    return null;
  }
}
