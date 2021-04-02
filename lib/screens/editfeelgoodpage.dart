import 'dart:io';

import 'package:SDD_Project/controller/firebasecontroller.dart';
import 'package:SDD_Project/model/vault.dart';
import 'package:SDD_Project/screens/views/mydialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditFeelGoodVault extends StatefulWidget {
  static const routeName = "/feelgoodvault/editfeelgoodvault";
  @override
  State<StatefulWidget> createState() {
    return _EditFeelGoodVault();
  }
}

class _EditFeelGoodVault extends State<EditFeelGoodVault> {
  _Controller con;
  var formKey = GlobalKey<FormState>();
  var formKey2 = GlobalKey<FormState>();
  var formKey3 = GlobalKey<FormState>();
  var formKey4 = GlobalKey<FormState>();
  var formKey5 = GlobalKey<FormState>();
  File image;
  String user;
  int view;
  Vault vault;
  int index;

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
    index ??= map['index'];
    vault ??= map['vault'];

    return Scaffold(
      floatingActionButton: Container(
        child: IconButton(
          icon: Icon(Icons.check),
          onPressed: con.save,
        ),
      ),
      appBar: AppBar(
        title: Text("Edit Item"),
      ),
      body: con.getForm(view),
    );
  }
}

class _Controller {
  _EditFeelGoodVault _state;
  _Controller(this._state);
  String name, quote, song, story, video, songValue, videoValue;

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
                              ? Image.network(
                                  _state.vault.pictures[_state.index].photoURL,
                                  scale: 2.5,
                                  alignment: Alignment.center,
                                )
                              : Image.file(
                                  _state.image,
                                  alignment: Alignment.center,
                                  scale: 2.5,
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
                        initialValue: _state.vault.pictures[_state.index].name,
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
          key: _state.formKey2,
          child: Container(
            width: MediaQuery.of(_state.context).size.width,
            padding: EdgeInsets.all(5),
            child: TextFormField(
              decoration: InputDecoration(
                hintText: "Quote",
              ),
              initialValue: _state.vault.quotes[_state.index],
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
          key: _state.formKey3,
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(_state.context).size.width,
                padding: EdgeInsets.all(5),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "Song URL",
                  ),
                  autocorrect: true,
                  initialValue: _state.vault.songs[_state.index].name,
                  maxLines: 1,
                  validator: validateSong,
                  onSaved: saveSong,
                ),
              ),
              Container(
                width: MediaQuery.of(_state.context).size.width,
                padding: EdgeInsets.all(5),
                child: DropdownButton(
                  items: <String>["Happy", "Energetic", "Peaceful"]
                      .map((String value) {
                    return DropdownMenuItem(
                        child: new Text(value), value: value);
                  }).toList(),
                  value: songValue == null
                      ? _state.vault.songs[_state.index].category
                      : songValue,
                  hint: Text("Category"),
                  onChanged: (String changedValue) {
                    _state.setState(() {
                      songValue = changedValue;
                    });
                  },
                ),
              ),
            ],
          ),
        );
        break;
      case 4:
        return Form(
          key: _state.formKey4,
          child: Container(
            width: MediaQuery.of(_state.context).size.width,
            padding: EdgeInsets.all(5),
            child: TextFormField(
              decoration: InputDecoration(
                hintText: "Story",
              ),
              initialValue: _state.vault.stories[_state.index],
              autocorrect: true,
              maxLines: 30,
              validator: validateStory,
              onSaved: saveStory,
            ),
          ),
        );
        break;
      case 5:
        return Form(
          key: _state.formKey5,
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(_state.context).size.width,
                padding: EdgeInsets.all(5),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "Video URL",
                  ),
                  autocorrect: true,
                  initialValue: _state.vault.videos[_state.index].name,
                  maxLines: 1,
                  validator: validateVideo,
                  onSaved: saveVideo,
                ),
              ),
              Container(
                width: MediaQuery.of(_state.context).size.width,
                padding: EdgeInsets.all(5),
                child: DropdownButton(
                  items: <String>["Happy", "Energetic", "Peaceful"]
                      .map((String value) {
                    return DropdownMenuItem(
                        child: new Text(value), value: value);
                  }).toList(),
                  value: videoValue == null
                      ? _state.vault.videos[_state.index].category
                      : videoValue,
                  hint: Text("Category"),
                  onChanged: (String changedValue) {
                    _state.setState(() {
                      videoValue = changedValue;
                    });
                  },
                ),
              ),
            ],
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
    _state.vault.pictures[_state.index].name = c + b;
  }

  void saveQuote(String s) {
    _state.vault.quotes[_state.index] = s;
  }

  void saveSong(String s) {
    _state.vault.songs[_state.index].name = s;
    if (songValue != null)
      _state.vault.songs[_state.index].category = songValue;
  }

  void saveStory(String s) {
    _state.vault.stories[_state.index] = s;
  }

  void saveVideo(String s) {
    _state.vault.videos[_state.index].name = s;
    if (videoValue != null)
      _state.vault.videos[_state.index].category = videoValue;
  }

  String validateName(String s) {
    if (s.isEmpty) {
      //print("Here");
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
      return "Please input a song url";
    }
    return null;
  }

  String validateStory(String s) {
    if (s.isEmpty) {
      return "Please type a story";
    }
    return null;
  }

  String validateVideo(String s) {
    if (s.isEmpty) {
      return "Please input a video url";
    }
    return null;
  }

  void save() {
    //this is where the firebase upload is
    //print(_state.view);
    switch (_state.view) {
      case 1:
        updatePic();
        break;
      case 2:
        updateQuote();
        break;
      case 3:
        updateSong();
        break;
      case 4:
        updateStory();
        break;
      case 5:
        updateVideo();
        break;
    }
  }

  void updatePic() async {
    if (!_state.formKey.currentState.validate()) {
      return;
    }
    _state.formKey.currentState.save();
    MyDialog.circularProgressStart(_state.context);

    try {
      //a new pic was added?
      if (_state.image != null) {
        Map<String, String> photo = await FirebaseController.addPicToStorage(
            image: _state.image, email: _state.user);
        _state.vault.pictures[_state.index].photoPath = photo['path'];
        _state.vault.pictures[_state.index].photoURL = photo['url'];
      }
      await FirebaseController.updatePicture(
          _state.vault.docId, _state.vault.pictures[_state.index]);
      MyDialog.circularProgressEnd(_state.context);
      Navigator.pop(_state.context); //pop form screen
      MyDialog.info(
          context: _state.context,
          title: "Edit Pic Complete",
          content: "Pic successfully edited");
    } catch (e) {
      MyDialog.circularProgressEnd(_state.context);
      MyDialog.info(
          context: _state.context,
          title: "Edit Pic Error",
          content: e.toString());
    }
  }

  void updateQuote() async {
    print("Updating quote");
  }

  void updateSong() async {
    if (!_state.formKey3.currentState.validate()) {
      return;
    }

    _state.formKey3.currentState.save();
    MyDialog.circularProgressStart(_state.context);
    try {
      await FirebaseController.updateSong(_state.vault.docId, _state.vault.songs[_state.index]);
      MyDialog.circularProgressEnd(_state.context);
      Navigator.pop(_state.context); //pop form screen
      MyDialog.info(
          context: _state.context,
          title: "Edit Song Complete",
          content: "Song successfully edited");
    } catch (e) {
      MyDialog.circularProgressEnd(_state.context);
      MyDialog.info(
          context: _state.context,
          title: "Edit Song Error",
          content: e.toString());
    }
  }

  void updateStory() async {
    print("Updating story");
  }

  void updateVideo() async {
     if (!_state.formKey5.currentState.validate()) {
      return;
    }

    _state.formKey5.currentState.save();
    MyDialog.circularProgressStart(_state.context);
    try {
      await FirebaseController.updateVideo(_state.vault.docId, _state.vault.videos[_state.index]);
      MyDialog.circularProgressEnd(_state.context);
      Navigator.pop(_state.context); //pop form screen
      MyDialog.info(
          context: _state.context,
          title: "Edit Video Complete",
          content: "Video successfully edited");
    } catch (e) {
      MyDialog.circularProgressEnd(_state.context);
      MyDialog.info(
          context: _state.context,
          title: "Edit Video Error",
          content: e.toString());
    }
  }

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
