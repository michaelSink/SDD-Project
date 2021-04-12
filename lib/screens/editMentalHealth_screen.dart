import 'package:SDD_Project/controller/firebasecontroller.dart';
import 'package:SDD_Project/model/mental_health.dart';
import 'package:SDD_Project/screens/views/mydialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EditMentalHealth extends StatefulWidget {
  static const routeName = "./signIn/homeScreen/mentalHealth.editMentalHealth/";

  @override
  State<StatefulWidget> createState() {
    return _EditMentalHealth();
  }
}

class _EditMentalHealth extends State<EditMentalHealth> {
  FirebaseUser user;
  _Controller con;
  MentalHealth mentalHealth;
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
    mentalHealth ??= arg['mentalHealth'];

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Mental Health Factor'),
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
              CheckboxListTile(
                value: mentalHealth.acute,
                title: Text('(Selected) Acute, (Not Selected) Chronic'),
                onChanged: con.onSavedAcute,
              ),
              Divider(
                height: 8.0,
              ),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Description',
                ),
                maxLines: 7,
                autocorrect: false,
                onSaved: con.onSavedDescription,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Controller {
  _EditMentalHealth _state;
  _Controller(this._state);

  void save() async {
    if (!_state.formKey.currentState.validate()) {
      return;
    }

    _state.formKey.currentState.save();

    try {
      MyDialog.circularProgressStart(_state.context);
      await FirebaseController.updateMentalHealth(_state.mentalHealth);
      MyDialog.circularProgressEnd(_state.context);
      Navigator.pop(_state.context);
    } catch (e) {
      MyDialog.circularProgressEnd(_state.context);
      MyDialog.info(
        context: _state.context,
        title: 'Error uploading mental health factor.',
        content: e.message ?? e.toString(),
      );
    }
  }

  //Savers
  void onSavedAcute(bool value) {
    _state.mentalHealth.acute = value;
  }

  void onSavedDescription(String value) {
    _state.mentalHealth.description = value;
  }
}
