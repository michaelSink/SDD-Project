import 'package:SDD_Project/controller/firebasecontroller.dart';
import 'package:SDD_Project/model/prescription.dart';
import 'package:SDD_Project/screens/prescriptionDetails_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'addprescription_screen.dart';

class PrescriptionScreen extends StatefulWidget{

  static const routeName = '/signIn/homeScreen/prescriptionScreen/';

  @override
  State<StatefulWidget> createState() {
    return _PrescriptionState();
  }

}

class _PrescriptionState extends State<PrescriptionScreen>{

  FirebaseUser user;
  List<Prescription> prescriptions;
  _Controller con;

  @override
  void initState() {
    super.initState();
    con = _Controller(this);
  }

  void render(fn) => setState(fn);

  @override
  Widget build(BuildContext context) {

    Map arg = ModalRoute.of(context).settings.arguments;
    user ??= arg['user'];
    prescriptions ??= arg['prescriptions'];

    return Scaffold(
      appBar: AppBar(
        title: Text('Prescriptions'),
      ),
      body: prescriptions.length == 0
        ? Text(
            'No Prescriptions',
            style: TextStyle(fontSize: 30.0),
          )
        : ListView.builder(
            itemCount: prescriptions.length,
            itemBuilder: (BuildContext context, int index) => Container(
              padding: EdgeInsets.all(4.0),
              child: Card(
                elevation: 4.0,
                  child: ListTile(
                    onTap: () => con.prescriptionDetails(index),
                    leading: Icon(Icons.add),
                    trailing: Icon(Icons.arrow_forward),
                    title: Text("Prescription for " + prescriptions[index].drugName),
                    subtitle: Text("Prescribed by: " + prescriptions[index].prescriber),
                  ),
              ),
            ),
          ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: con.addScreen,
      ),
    );
  }

}

class _Controller{

  _PrescriptionState _state;
  _Controller(this._state);

  void addScreen() async{

    await Navigator.pushNamed(_state.context, AddPrescriptionScreen.routeName,
      arguments: {'user' : _state.user, 'prescriptions': _state.prescriptions});
    _state.render((){});

  }

  void prescriptionDetails(int index) async{
    await Navigator.pushNamed(_state.context, PrescriptionDetails.routeName,
      arguments: {'prescription' : _state.prescriptions[index]});
      
    _state.prescriptions = await FirebaseController.getPrescriptions(_state.user.uid);
    _state.render((){});
  }

}