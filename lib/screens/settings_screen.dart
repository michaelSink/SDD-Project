import 'dart:io';

import 'package:SDD_Project/controller/firebasecontroller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'signin_screen.dart';
import 'views/mydialog.dart';

class SettingsScreen extends StatefulWidget{

  static const routeName = '/signInScreen/settingsScreen';

  @override
  State<StatefulWidget> createState() {
    return _SettingsScreenState();
  }
}

class _SettingsScreenState extends State<SettingsScreen>{
  
  FirebaseUser user;
  _Controller con;
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

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Settings'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: Text(
                  'Change Profile Picture',
                  style: TextStyle(fontSize: 20.0),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: Stack(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: ClipOval(
                        child: con.imageFile == null
                            ? user.photoUrl == null 
                              ? Image.asset(
                                  'static/images/default-user.png',
                                  height: 150,
                                  width: 150,
                                )
                              : Image.network(
                                  user.photoUrl,
                                  height: 150,
                                  width: 150,
                                )
                            : Image.file(
                                con.imageFile,
                                fit: BoxFit.fill,
                              ),
                      ),
                    ),
                    Positioned(
                      right: 0.0,
                      bottom: 0.0,
                      child: Container(
                        color: Colors.grey[400],
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
                                  Icon(Icons.photo_library),
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
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: Column(
                  children: [
                    Text(
                      'Display Name',
                      style: TextStyle(fontSize: 20.0),
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: user.displayName == null
                            ? "Display Name"
                            : user.displayName,
                      ),
                      keyboardType: TextInputType.emailAddress,
                      autocorrect: false,
                      validator: con.validatorName,
                      onSaved: con.onSavedName,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: Column(
                  children: [
                    Text(
                      'Update Email',
                      style: TextStyle(fontSize: 20.0),
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Email',
                      ),
                      keyboardType: TextInputType.emailAddress,
                      autocorrect: false,
                      validator: con.validatorEmail,
                      onSaved: con.onSavedEmail,
                    ),
                  ],
                ),
              ),
              RaisedButton(
                onPressed: con.save,
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Controller{
  _SettingsScreenState _state;
  _Controller(this._state);

  File imageFile;
  String email;
  String displayName;

  void save() async {
    if (!(_state.formKey.currentState.validate())) return;

    _state.formKey.currentState.save();

    try {

      if(imageFile != null){
        await FirebaseController.updateProfilePicture(
          image: imageFile, 
          user: _state.user
        );
      }

      if(displayName.trim().isNotEmpty){
        await FirebaseController.updateDisplayName(
          displayName: displayName, 
          user: _state.user
        );
      }

      if(this.email.isNotEmpty){
        await FirebaseController.updateEmail(user: _state.user, email: email);
      }

      await MyDialog.infoFuture(
        context: _state.context,
        title: "Success",
        content: "Your profile was updated successfully!\n You will now be signed out.",
      );

      Navigator.pushReplacementNamed(_state.context, SignInScreen.routeName);

    } catch (e) {
      MyDialog.info(
        context: _state.context,
        title: 'Profile Update error',
        content: e.message ?? e.toString(),
      );
    }
  }

  void getPicture(String src) async {
    try {
      PickedFile _image;
      if (src == 'camera') {
        _image = await ImagePicker().getImage(source: ImageSource.camera);
      } else {
        _image = await ImagePicker().getImage(source: ImageSource.gallery);
      }

      _state.render(() => imageFile = File(_image.path));
    } catch (e) {
      MyDialog.info(
        context: _state.context,
        title: 'Image capture error',
        content: e.message ?? e.toString(),
      );
    }
  }

  String validatorEmail(String value) {
    if (value == null ||
        (!value.contains('@') ||
                !value.contains('.') ||
                (value.split('@').length != 2)) &&
            value.length != 0) {
      return 'Invalid email address';
    }

    return null;
  }

  void onSavedEmail(String value) {
    email = value.trim();
  }

  String validatorName(String value) {
    if (value == null || (value.length < 4 && value.length != 0)) {
      return "Minimum 4 characters";
    }

    return null;
  }

  void onSavedName(String value) {
    this.displayName = value;
  }

}