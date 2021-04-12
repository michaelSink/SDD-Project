import 'package:SDD_Project/controller/firebasecontroller.dart';
import 'package:SDD_Project/model/mental_health.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'views/mydialog.dart';

class AddMentalHealth extends StatefulWidget {
  static const routeName =
      './signIn/homeScreen/mentalHealth/mentalHealthHistory';

  @override
  State<StatefulWidget> createState() {
    return _AddMentalHealth();
  }
}

class _AddMentalHealth extends State<AddMentalHealth> {
  _Controller con;
  FirebaseUser user;
  bool acute = false;
  List<MentalHealth> mentalHealth;
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
    mentalHealth ??= args['mentalHealth'];

    return Scaffold(
      appBar: AppBar(
        title: Text('Add Mental Health Factor'),
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
                value: acute,
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
  _AddMentalHealth _state;
  _Controller(this._state);

  String description;

  void save() async {
    if (!_state.formKey.currentState.validate()) {
      return;
    }

    _state.formKey.currentState.save();

    try {
      MyDialog.circularProgressStart(_state.context);

      var d = new MentalHealth(
        createdBy: _state.user.uid,
        acute: _state.acute,
        description: this.description,
      );

      d.docId = await FirebaseController.addMentalHealth(d);
      _state.mentalHealth.insert(0, d);

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
    _state.acute = value;
    _state.setState(() {});
  }

  void onSavedDescription(String value) {
    this.description = value;
  }
}
