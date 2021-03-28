import 'dart:io';

import 'package:SDD_Project/controller/firebasecontroller.dart';
import 'package:SDD_Project/model/location.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'views/mydialog.dart';

class AddLocationScreen extends StatefulWidget{

  static const routeName = '/signIn/homeScreen/locationScreen/addLocationScreen/';

  @override
  State<StatefulWidget> createState() {
    return _AddLocationScreenState();
  }
}

class _AddLocationScreenState extends State<AddLocationScreen>{

  _Controller con;
  FirebaseUser user;
  List<Location> locations;
  File image;
  var formKey = GlobalKey<FormState>();

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
    locations ??= arg['locations'];

    return Scaffold(
      appBar: AppBar(
        title: Text('Add Social Setting'),
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
              Stack(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: image == null
                        ? Icon(
                            Icons.photo_library,
                            size: 300.0,
                          )
                        : Image.file(image, fit: BoxFit.fill),
                  ),
                  Positioned(
                    right: 0.0,
                    bottom: 0.0,
                    child: Container(
                      color: Colors.blue[200],
                      child: PopupMenuButton<String>(
                        onSelected: con.getPicture,
                        itemBuilder: (context) => <PopupMenuEntry<String>>[
                          PopupMenuItem(
                            value: 'camera',
                            child: Row(
                              children: [
                                Icon(Icons.photo_camera),
                                Text('Camera'),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            value: 'gallery',
                            child: Row(
                              children: [
                                Icon(Icons.photo_album),
                                Text('Gallery'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Divider(height: 10),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Name',
                ),
                validator: con.validatorName,
                onSaved: con.onSavedName,
              ),
              Divider(height: 10),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Description',
                ),
                maxLines: 7,
                validator: con.validatorDescription,
                onSaved: con.onSavedDescription,
              ),
              Divider(height: 10),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Location'
                ),
                validator: con.validatorLocation,
                onSaved: con.onSavedLocation,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Controller{
  _AddLocationScreenState _state;
  _Controller(this._state);

  String name;
  String description;
  String location;

  void save() async {
    if (!_state.formKey.currentState.validate()) {
      return;
    }

    _state.formKey.currentState.save();

    try {
      MyDialog.circularProgressStart(_state.context);
      Map<String, String> photoInfo = await FirebaseController.uploadLocationStorage(
        image: _state.image,
        uid: _state.user.uid,
      );

      var l = Location(
        name: name,
        description: description,
        location: location,
        createdBy: _state.user.uid,
        photoPath: photoInfo['path'],
        photoURL: photoInfo['url'],
      );

      l.docId = await FirebaseController.addLocation(l);
      _state.locations.insert(0, l);

      MyDialog.circularProgressEnd(_state.context);

      Navigator.pop(_state.context);

    } catch (e) {

      MyDialog.circularProgressEnd(_state.context);

      MyDialog.info(
        context: _state.context,
        title: 'Firebase Error',
        content: e.message ?? e.toString(),
      );

    }
  }

  void getPicture(String src) async {
    try {
      PickedFile _imageFile;
      if (src == 'camera') {
        _imageFile = await ImagePicker().getImage(source: ImageSource.camera);
      } else {
        _imageFile = await ImagePicker().getImage(source: ImageSource.gallery);
      }

      _state.render(() {
        _state.image = File(_imageFile.path);
      });
    } catch (e) {}
  }

  String validatorName(String value){
    if(value == null || value.trim().length < 4){
      return 'Min 4 characters';
    }
    return null;
  }

  String validatorDescription(String value){
    if(value == null || value.trim().length < 8){
      return 'Min 8 characters';
    }
    return null;
  }

  String validatorLocation(String value){
    if(value == null || value.trim().length < 10){
      return 'Min 10 charactrs';
    }
    return null;
  }

  void onSavedName(String value){
    this.name = value.trim();
  }

  void onSavedDescription(String value){
    this.description = value.trim();
  }

  void onSavedLocation(String value){
    this.location = value.trim();
  }

}