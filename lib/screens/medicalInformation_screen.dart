import 'package:SDD_Project/controller/firebasecontroller.dart';
import 'package:SDD_Project/model/diagnosis.dart';
import 'package:SDD_Project/model/medicalHistory.dart';
import 'package:SDD_Project/screens/views/mydialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'diagnosis_screen.dart';
import 'familyHistory_screen.dart';
import 'home_screen.dart';
import 'prescription_screen.dart';
import 'settings_screen.dart';

class MedicalInformation extends StatefulWidget{

  static const routeName = './signIn/homeScreen/medicalInformation/';

  @override
  State<StatefulWidget> createState() {
    return _MedicalInofrmationState();
  }
}

class _MedicalInofrmationState extends State<MedicalInformation>{

  _Controller con;
  FirebaseUser user;

  @override
  void initState() {
    super.initState();
    con = _Controller(this);
  }

  @override
  Widget build(BuildContext context) {

    Map arg = ModalRoute.of(context).settings.arguments;
    user ??= arg['user'];

    return Scaffold(

      appBar: AppBar(
        title: Text('Medical Information'),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
        children: [
          InkWell(
            onTap: con.prescriptionScreen,
            child: Card(
              elevation: 6,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.local_hospital, size: 35,),
                  SizedBox(height: 10,),
                  Text(
                    "Prescriptions",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: con.familyScreen,
            child: Card(
              elevation: 6,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.people, size: 35,),
                  SizedBox(height: 10,),
                  Text(
                    "Family History",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: con.diagnosisScreen,
            child: Card(
              elevation: 6,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.history, size: 35,),
                  SizedBox(height: 10,),
                  Text(
                    "Diagnoses",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
              backgroundColor: Colors.grey,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
              backgroundColor: Colors.grey,
            ),
          ],
          currentIndex: 0,
          onTap: (value) => value == 1 ? con.settings() : con.home(),
        ),
    );
  }
}

class _Controller {
  _MedicalInofrmationState _state;
  _Controller(this._state);

  void settings() async{
    await Navigator.pushNamed(_state.context, SettingsScreen.routeName,
              arguments: {'user' : _state.user});
  }

  void home() async{
    await Navigator.pushNamed(_state.context, HomeScreen.routeName,
                arguments: {'user' : _state.user});
  }

  void diagnosisScreen() async {
    try {
      List<Diagnosis> diagnoses =
          await FirebaseController.getDiagnoses(_state.user.uid);

      await Navigator.pushNamed(_state.context, DiagnosisScreen.routeName,
          arguments: {'user': _state.user, 'diagnoses': diagnoses});
    } catch (e) {
      MyDialog.info(
        context: _state.context,
        content: e.toString(),
        title: 'Error',
      );
    }
  }

  void prescriptionScreen() async {
    try {
      //Get perscriptions
      List<dynamic> prescriptions =
          await FirebaseController.getPrescriptions(_state.user.uid);

      await Navigator.pushNamed(_state.context, PrescriptionScreen.routeName,
          arguments: {'user': _state.user, 'prescriptions': prescriptions});
    } catch (e) {
      MyDialog.info(
        context: _state.context,
        content: e.message ?? e.toString(),
        title: 'Error',
      );
    }
  }

  void familyScreen() async {
    try {
      List<MedicalHistory> history =
          await FirebaseController.getFamilyHistory(_state.user.uid);
      await Navigator.pushNamed(_state.context, FamilyHistory.routeName,
          arguments: {'user': _state.user, 'history': history});
    } catch (e) {
      MyDialog.info(
        context: _state.context,
        content: e.message ?? e.toString(),
        title: 'Error',
      );
    }
  }
}