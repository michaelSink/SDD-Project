import 'dart:io';

import 'package:SDD_Project/controller/firebasecontroller.dart';
import 'package:SDD_Project/model/prescription.dart';
import 'package:SDD_Project/screens/prescriptionDetails_screen.dart';
import 'package:SDD_Project/screens/views/mydialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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
      floatingActionButton: Container(
        color: Colors.blue[200],
        child: PopupMenuButton<String>(
          onSelected: con.addScreen,
          itemBuilder: (context) => <PopupMenuEntry<String>>[
            PopupMenuItem(
              value: 'manual',
              child: Row(
                children: [
                  Icon(Icons.add),
                  Text('Manual Entry'),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'camera',
              child: Row(
                children: [
                  Icon(Icons.photo_camera),
                  Text('From Camera'),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'gallery',
              child: Row(
                children: [
                  Icon(Icons.photo_album),
                  Text('From Gallery'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

}

class _Controller{

  _PrescriptionState _state;
  _Controller(this._state);

  void addScreen(String src) async{

    List<String> recognizedText = [];

    if(src != 'manual'){

      try{

        PickedFile _imageFile;
        if (src == 'camera') {
          _imageFile = await ImagePicker().getImage(source: ImageSource.camera);
        } else if(src == 'gallery'){
          _imageFile = await ImagePicker().getImage(source: ImageSource.gallery);
        }
        File _image = File(_imageFile.path);

        recognizedText = await FirebaseController.getImageText(_image);

      }catch(e){

        MyDialog.info(
          context: _state.context,
          content: e.message ?? e.toString(),
          title: "Error",
        );

      }

    }

    await Navigator.pushNamed(_state.context, AddPrescriptionScreen.routeName,
      arguments: {'user' : _state.user, 'prescriptions': _state.prescriptions, 'recognizedText' : recognizedText});
    _state.render((){});

  }

  void prescriptionDetails(int index) async{
    await Navigator.pushNamed(_state.context, PrescriptionDetails.routeName,
      arguments: {'prescription' : _state.prescriptions[index]});
      
    _state.prescriptions = await FirebaseController.getPrescriptions(_state.user.uid);
    _state.render((){});
  }

}