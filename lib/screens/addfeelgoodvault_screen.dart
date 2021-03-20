import 'dart:io';

import 'package:SDD_Project/controller/firebasecontroller.dart';
import 'package:SDD_Project/model/vault.dart';
import 'package:SDD_Project/screens/views/mydialog.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddFeelGoodVault extends StatefulWidget {
  static const routeName = "/feelgoodvault/addfeelgoodvault";

  @override
  State<StatefulWidget> createState() {
    return _AddFeelGoodVault();
  }
}

class _AddFeelGoodVault extends State<AddFeelGoodVault> {
  _Controller con;
  var formKey = GlobalKey<FormState>();
  File image;
  String user;
  int view;
  Vault vault;

  @override
  void initState() {
    con = _Controller(this);
    super.initState();
  }

  render(fn) => setState(fn);

  @override
  Widget build(BuildContext context) {
    Map map = ModalRoute.of(context).settings.arguments;
    user ??= map['user'];
    view ??= map['view'];
    vault ??= map['vault'];

    return Scaffold(
      floatingActionButton: Container(
        child: IconButton(
          icon: Icon(Icons.check),
          onPressed: con.save,
        ),
      ),
      appBar: AppBar(
        title: Text("Add new Item"),
      ),
      body: con.getForm(view),
    );
  }
}

class _Controller {
  _AddFeelGoodVault _state;
  _Controller(this._state);
  String name, quote, song, story, video;

  Widget getForm(int view) {
    switch (view) {
      case 1:
        return Form(
          key: _state.formKey,
          child: Container(
            width: MediaQuery.of(_state.context).size.width,
            height: MediaQuery.of(_state.context).size.height,
            child: SingleChildScrollView(
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.all(10),
                          width: MediaQuery.of(_state.context).size.width,
                          child: _state.image == null
                              ? Icon(
                                  Icons.filter_frames,
                                  size: 300,
                                  color: Colors.brown[100],
                                )
                              : Image.file(
                                  _state.image,
                                  alignment: Alignment.center,
                                  scale: 3,
                                ),
                        ),
                        Positioned(
                          right: 0.0,
                          bottom: 0.0,
                          child: Container(
                            color: Colors.transparent,
                            child: PopupMenuButton<String>(
                              onSelected: getPicture,
                              itemBuilder: (context) =>
                                  <PopupMenuEntry<String>>[
                                PopupMenuItem(
                                  value: 'Gallery',
                                  child: Row(
                                    children: <Widget>[
                                      Icon(Icons.photo_album),
                                      Text("Gallery"),
                                    ],
                                  ),
                                ),
                                PopupMenuItem(
                                  value: 'Camera',
                                  child: Row(
                                    children: <Widget>[
                                      Icon(Icons.photo_camera),
                                      Text("Camera"),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 75.0,
                    ),
                    Container(
                      width: 350.0,
                      padding: EdgeInsets.fromLTRB(15, 15, 15, 0),
                      child: TextFormField(
                        decoration: InputDecoration(
                          hintText: "Name",
                        ),
                        autocorrect: true,
                        textAlign: TextAlign.center,
                        validator: validateName,
                        onSaved: saveName,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
        break;
      case 2:
        return Form(
          key: _state.formKey,
          child: Container(
            width: MediaQuery.of(_state.context).size.width,
            padding: EdgeInsets.all(5),
            child: TextFormField(
              decoration: InputDecoration(
                hintText: "Quote",
              ),
              autocorrect: true,
              maxLines: 1,
              validator: validateQuote,
              onSaved: saveQuote,
            ),
          ),
        );
        break;
      case 3:
        return Form(
          key: _state.formKey,
          child: Container(
            width: MediaQuery.of(_state.context).size.width,
            padding: EdgeInsets.all(5),
            child: TextFormField(
              decoration: InputDecoration(
                hintText: "Song URL",
              ),
              autocorrect: true,
              maxLines: 1,
              validator: validateSong,
              onSaved: saveSong,
            ),
          ),
        );
        break;
      case 4:
        return Form(
          key: _state.formKey,
          child: Container(
            width: MediaQuery.of(_state.context).size.width,
            padding: EdgeInsets.all(5),
            child: TextFormField(
              decoration: InputDecoration(
                hintText: "Story",
              ),
              autocorrect: true,
              maxLines: 10,
              validator: validateStory,
              onSaved: saveStory,
            ),
          ),
        );
        break;
      case 5:
        return Form(
          key: _state.formKey,
          child: Container(
            width: MediaQuery.of(_state.context).size.width,
            padding: EdgeInsets.all(5),
            child: TextFormField(
              decoration: InputDecoration(
                hintText: "Video URL",
              ),
              autocorrect: true,
              maxLines: 1,
              validator: validateVideo,
              onSaved: saveVideo,
            ),
          ),
        );
        break;
      default:
        return Container(child: Text("No valid form found"));
        break;
    }
  }

  void saveName(String s) {
    String c = s.substring(0, 1);
    c = c.toUpperCase();
    String b = s.substring(1);
    b = b.toLowerCase();
    name = c + b;
  }
  void saveQuote(String s) {
    quote = s;
  }
  void saveSong(String s) {
    song = s;
  }
  void saveStory(String s) {
    story = s;
  }
  void saveVideo(String s) {
    video = s;
  }

  String validateName(String s) {
    if (s.isEmpty) {
      print("Here");
      return "Name cannot be empty";
    }
    return null;
  }
  String validateQuote(String s) {
    if (s.isEmpty) {
      return "Please input a quote";
    }
    return null;
  }
  String validateSong(String s) {
    if (s.isEmpty) {
      return "Please input a quote";
    }
    return null;
  }
  String validateStory(String s) {
    if (s.isEmpty) {
      return "Please input a quote";
    }
    return null;
  }
  String validateVideo(String s) {
    if (s.isEmpty) {
      return "Please input a quote";
    }
    return null;
  }

  void save() {
    //this is where the firebase upload is
    if (!_state.formKey.currentState.validate()) {
      return;
    }
    print(_state.view);
    switch (_state.view) {
      case 1:
        uploadPic();
        break;
      case 2:
        uploadQuote();
        break;
      case 3:
        uploadSong();
        break;
      case 4:
        uploadVideo();
        break;
      case 5:
        uploadStory();
        break;
    }
  }

  void uploadPic() async {
    if (_state.image == null) {
      MyDialog.info(
          context: _state.context,
          title: "No Picture",
          content: "You must include a picture");
      return;
    }

    _state.formKey.currentState.save();
    MyDialog.circularProgressStart(_state.context);

    try {
      Map<String, String> photo = await FirebaseController.addPicToStorage(
          image: _state.image, email: _state.user);

      var p = Picture(
        name: name,
        photoPath: photo["path"],
        photoURL: photo["url"],
        owner: _state.user,
      );
      //print("Made new picture");
      //print(p.docId);
      await FirebaseController.addPicToVault(_state.vault.docId, p);

      MyDialog.circularProgressEnd(_state.context);
      Navigator.pop(_state.context);
      MyDialog.info(
          context: _state.context,
          title: "Add Pic Complete",
          content: "Pic added successfully");
    } catch (e) {
      MyDialog.circularProgressEnd(_state.context);
      MyDialog.info(
          context: _state.context,
          title: "Add Pic Error",
          content: e.toString());
    }
  }

  void uploadQuote() {
    _state.formKey.currentState.save();
    MyDialog.circularProgressStart(_state.context);

    try{
      //await FirebaseController.addQuote(quote);
    }catch(e){

    }
  }

  void uploadSong() {}

  void uploadVideo() {}

  void uploadStory() {}

  void getPicture(String src) async {
    try {
      PickedFile _imageFile;
      if (src == "Camera") {
        _imageFile = await ImagePicker().getImage(source: ImageSource.camera);
      } else {
        _imageFile = await ImagePicker().getImage(source: ImageSource.gallery);
      }
      _state.render(() {
        _state.image = File(_imageFile.path);
      });
    } catch (e) {}
  }
}