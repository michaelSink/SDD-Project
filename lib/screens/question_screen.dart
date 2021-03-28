import 'dart:io';
import 'package:SDD_Project/controller/firebasecontroller.dart';
import 'package:SDD_Project/model/personalcare.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class QuestionFormScreen extends StatefulWidget {
  static const routeName = 'questionHomeScreen/QuestionFormScreen';
  @override
  State<StatefulWidget> createState() {
    return _QuestionFormState();
  }
}

class _QuestionFormState extends State<QuestionFormScreen> {
  _Controller con;
  File image;
  var formKey = GlobalKey<FormState>();
  FirebaseUser user;
  List<PersonalCare> personalCare;

  @override
  void initState() {
    super.initState();
    con = _Controller(this);
  }

  void render(fn) => setState(fn);

  @override
  Widget build(BuildContext context) {
    Map args = ModalRoute.of(context).settings.arguments;
    user ??= args['user'];
    personalCare ??= args['personalCareList'];
    return Scaffold(
      appBar: AppBar(
        title: Text('Add new Question Form'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.check),
             onPressed: con.save,
             )
        ],
      ),
      body: Form(
          key: formKey,
          child: SingleChildScrollView(
              child: Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
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
                              children: <Widget>[
                                Icon(Icons.photo_camera),
                                Text('Camera'),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            value: 'gallery',
                            child: Row(
                              children: <Widget>[
                                Icon(Icons.photo_album),
                                Text('Gallery'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'what is your name?',
                ),
                autocorrect: true,
                validator: con.validatorName,
                onSaved: con.onSavedName,
              ),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'How old are you?',
                ),
                autocorrect: true,
                validator: con.validatorAge,
                onSaved: con.onSavedAge,
              ),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'What is your race?',
                ),
                autocorrect: true,
                validator: con.validatorRace,
                onSaved: con.onSavedRace,
              ),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'What is your sex?',
                ),
                autocorrect: true,
                validator: con.validatorSex,
                onSaved: con.onSavedSex,
              ),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'religiousAffiliation',
                ),
                autocorrect: true,
                keyboardType: TextInputType.multiline,
                maxLines: 3,
                validator: con.validatorReligiousAffiliation,
                onSaved: con.onSavedReligiousAffiliation,
              ),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'sexualOrientation',
                ),
                autocorrect: true,
                keyboardType: TextInputType.multiline,
                maxLines: 3,
                validator: con.validatorSexualOrientation,
                onSaved: con.onSavedSexualOrientation,
              ),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'militaryHistory',
                ),
                autocorrect: true,
                keyboardType: TextInputType.multiline,
                maxLines: 8,
                validator: con.validatorMilitaryHistory,
                onSaved: con.onSavedMilitaryHistory,
              ),
            ],
          ),
          ),
        ),
    );
  }
}

class _Controller {
  _QuestionFormState _state;
  _Controller(this._state);
 String name;
  String age;
  String race;
  String sex;
  String religiousAffiliation;
  String sexualOrientation;
  String militaryHistory;

void save() async {
    if (!_state.formKey.currentState.validate()) {
      return;
    }
    _state.formKey.currentState.save();

    // 1. upload pic to Storage
    // ignore: missing_required_param
    Map<String, String> photoInfo = await FirebaseController.uploadStorage(
      image: _state.image,
      uid: _state.user.uid,
    );
    // 2. save personalcare doc to Firestore
    var p = PersonalCare(
      name: name,
      age: age,
      race: race,
      sex: sex,
      religiousAffiliation: religiousAffiliation,
      sexualOrientation: sexualOrientation,
      militaryHistory: militaryHistory,
      photoPath: photoInfo['path'],
      photoURL: photoInfo['url'],
      createdBy: _state.user.email,
      updatedAt: DateTime.now(),
    );
    p.docId = await FirebaseController.addPersonalCare(p);
    _state.personalCare.insert(0, p);

    Navigator.pop(_state.context);
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

  String validatorName(String value) {
    if (value == null || value.trim().length < 1) {
      return 'min 1 chars';
    } else {
      return null;
    }
  }

  void onSavedName(String value) {
    this.name = value;
  }

  String validatorAge(String value) {
    if (value == null || value.trim().length < 1) {
      return 'min 1 chars';
    } else {
      return null;
    }
  }

  void onSavedAge(String value) {
    this.age = value;
  }

  String validatorRace(String value) {
    if (value == null || value.trim().length < 2) {
      return 'min 2 chars';
    } else {
      return null;
    }
  }

  void onSavedRace(String value) {
    this.race = value;
  }

    String validatorSex(String value) {
    if (value == null || value.trim().length < 2) {
      return 'min 2 chars';
    } else {
      return null;
    }
  }

  void onSavedSex(String value) {
    this.sex = value;
  }

    String validatorReligiousAffiliation(String value) {
    if (value == null || value.trim().length < 5 ){
      return 'min 5 chars';
    } else {
      return null;
    }
  }

  void onSavedReligiousAffiliation(String value) {
    this.religiousAffiliation = value;
  }

      String validatorSexualOrientation(String value) {
    if (value == null || value.trim().length < 5 ){
      return 'min 5 chars';
    } else {
      return null;
    }
  }

  void onSavedSexualOrientation(String value) {
    this.sexualOrientation = value;
  }

        String validatorMilitaryHistory(String value) {
    if (value == null || value.trim().length < 5 ){
      return 'min 5 chars';
    } else {
      return null;
    }
  }

  void onSavedMilitaryHistory(String value) {
    this.militaryHistory = value;
  }

}