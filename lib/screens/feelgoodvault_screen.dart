import 'dart:io';

import 'package:SDD_Project/controller/firebasecontroller.dart';
import 'package:SDD_Project/model/vault.dart';
import 'package:SDD_Project/screens/addfeelgoodvault_screen.dart';
import 'package:flutter/material.dart';

class FeelGoodVault extends StatefulWidget {
  static const routeName = "/homescreen/feelgoodvault";

  @override
  State<StatefulWidget> createState() {
    return _FeelGoodVault();
  }
}

class _FeelGoodVault extends State<FeelGoodVault> {
  String user;
  bool viewSelected;
  int view;
  _Controller con;
  Vault vault;
  String vaultKey;
  File image;

  @override
  void initState() {
    super.initState();
    viewSelected = false;
    view = 0;
    con = _Controller(this);
  }

  @override
  void setState(fn) {
    super.setState(fn);
    //print("View is " + viewSelected.toString() + " view = " + view.toString());
  }

  render(fn) => setState(fn);

  Future<bool> _onWillPop() async {
    bool result;
    if (view == 0) {
      result = true;
    } else {
      setState(() {
        view = 0;
        viewSelected = false;
      });
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    Map args = ModalRoute.of(context).settings.arguments;
    user ??= args['user'];
    vault ??= args['vault'];

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Feel Good Vault"),
        ),
        body: viewSelected == false
            ? Column(
                children: <Widget>[
                  Card(
                    elevation: 5,
                    margin: EdgeInsets.all(15),
                    child: ListTile(
                      leading: Icon(Icons.camera_alt),
                      title: Text("Pictures"),
                      onTap: () => setState(() {
                        viewSelected = true;
                        vaultKey = "pictures";
                        view = 1;
                      }),
                    ),
                  ),
                  Card(
                    elevation: 5,
                    margin: EdgeInsets.all(15),
                    child: ListTile(
                      leading: Icon(Icons.format_quote_outlined),
                      title: Text("Quotes"),
                      onTap: () => setState(() {
                        viewSelected = true;
                        vaultKey = "quotes";
                        view = 2;
                      }),
                    ),
                  ),
                  Card(
                    elevation: 5,
                    margin: EdgeInsets.all(15),
                    child: ListTile(
                      leading: Icon(Icons.music_note_outlined),
                      title: Text("Songs"),
                      onTap: () => setState(() {
                        viewSelected = true;
                        vaultKey = "songs";
                        view = 3;
                      }),
                    ),
                  ),
                  Card(
                    elevation: 5,
                    margin: EdgeInsets.all(15),
                    child: ListTile(
                      leading: Icon(Icons.video_collection_outlined),
                      title: Text("Stories"),
                      onTap: () => setState(() {
                        viewSelected = true;
                        vaultKey = "stories";
                        view = 4;
                      }),
                    ),
                  ),
                  Card(
                    elevation: 5,
                    margin: EdgeInsets.all(15),
                    child: ListTile(
                      leading: Icon(Icons.book_outlined),
                      title: Text("Videos"),
                      onTap: () => setState(() {
                        viewSelected = true;
                        vaultKey = "videos";
                        view = 5;
                      }),
                    ),
                  ),
                ],
              )
            : con.buildList(view),
        floatingActionButton: IconButton(
          icon: Icon(Icons.add),
          onPressed: () {
            //open form to add new item to vault
            showDialog(
              barrierDismissible: true,
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Center(
                      child:
                          Container(child: Text("Which do you want to add?"))),
                  actions: <Widget>[
                    Center(
                        child: Container(
                      child: ElevatedButton(
                          onPressed: () {
                            //print("pic");
                            con.getForm(1);
                          },
                          child: Text("Pictures")),
                      width: 150,
                    )),
                    Center(
                        child: Container(
                      child: ElevatedButton(
                          onPressed: () {
                            //print("quote");
                            con.getForm(2);
                          },
                          child: Text("Quotes")),
                      width: 150,
                    )),
                    Center(
                        child: Container(
                            child: ElevatedButton(
                                onPressed: () {
                                  //print("song");
                                  con.getForm(3);
                                },
                                child: Text("Songs")),
                            width: 150)),
                    Center(
                        child: Container(
                            child: ElevatedButton(
                                onPressed: () {
                                  //print("story");
                                  con.getForm(4);
                                },
                                child: Text("Stories")),
                            width: 150)),
                    Center(
                        child: Container(
                            child: ElevatedButton(
                                onPressed: () {
                                  //print("video");
                                  con.getForm(5);
                                },
                                child: Text("Videos")),
                            width: 150)),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _Controller {
  _FeelGoodVault _state;
  _Controller(this._state);

  Widget buildList(view) {
    Widget returnWidget;

    switch (view) {
      case 1:
        if (_state.vault.pictures == null) {
          returnWidget = Text("Please Add to your pics");
        } else {
          returnWidget = ListView.builder(
              itemCount: _state.vault.pictures.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  child: Text("Item in pictures"),
                );
              });
        }
        break;
      case 2:
        if(_state.vault.quotes == null){
           returnWidget = Text("Please Add to your quotes");
        }else{
           returnWidget = ListView.builder(
              itemCount: _state.vault.quotes.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  child: Text("Item in quotes"),
                );
              });
        }
        break;
      case 3:
       if(_state.vault.songs == null){
           returnWidget = Text("Please Add to your songs");
        }else{
           returnWidget = ListView.builder(
              itemCount: _state.vault.songs.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  child: Text("Item in songs"),
                );
              });
        }
        break;
      case 4:
       if(_state.vault.stories == null){
           returnWidget = Text("Please Add to your stories");
        }else{
           returnWidget = ListView.builder(
              itemCount: _state.vault.stories.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  child: Text("Item in stories"),
                );
              });
        }
        break;
      case 5:
       if(_state.vault.videos == null){
           returnWidget = Text("Please Add to your videos");
        }else{
           returnWidget = ListView.builder(
              itemCount: _state.vault.videos.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  child: Text("Item in videos"),
                );
              });
        }
        break;
    }

    return returnWidget;
  }

  void getForm(view) async {
    print(view);
    await Navigator.pushNamed(_state.context, AddFeelGoodVault.routeName,
        arguments: {'user': _state.user, 'view': view, 'vault': _state.vault});
    _state.vault = await FirebaseController.getVault(_state.user);
    _state.setState(() {});
  }
}
