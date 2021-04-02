import 'dart:io';

import 'package:SDD_Project/controller/firebasecontroller.dart';
import 'package:SDD_Project/model/vault.dart';
import 'package:SDD_Project/screens/addfeelgoodvault_screen.dart';
import 'package:SDD_Project/screens/editfeelgoodpage.dart';
import 'package:flutter/material.dart';

import 'views/mydialog.dart';

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
  int indexToDelete;

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
        indexToDelete = null;
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
            actions: con.actions(view, indexToDelete)),
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
  var searchKey = GlobalKey<FormState>();
  String searchWord;

  Widget buildList(view) {
    Widget returnWidget;

    switch (view) {
      case 1:
        if (_state.vault.pictures == null ||
            _state.vault.pictures.length == 0) {
          returnWidget = Text("Please Add to your pics");
        } else {
          returnWidget = ListView.builder(
              itemCount: _state.vault.pictures.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  margin: EdgeInsets.all(10),
                  child: ListTile(
                    title: Image.network(_state.vault.pictures[index].photoURL),
                    subtitle:
                        Center(child: Text(_state.vault.pictures[index].name)),
                    onLongPress: () {
                      _state.setState(() {
                        _state.indexToDelete != index
                            ? _state.indexToDelete = index
                            : _state.indexToDelete = null;
                      });
                    },
                    selected: _state.indexToDelete == index ? true : false,
                    selectedTileColor: Colors.blue[100],
                  ),
                );
              });
        }
        break;
      case 2:
        if (_state.vault.quotes == null || _state.vault.quotes.length == 0) {
          returnWidget = Text("Please Add to your quotes");
        } else {
          returnWidget = ListView.builder(
              itemCount: _state.vault.quotes.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(_state.vault.quotes[index]),
                  contentPadding: EdgeInsets.all(5),
                  horizontalTitleGap: 2.0,
                  onLongPress: () {
                    _state.setState(() {
                      _state.indexToDelete != index
                          ? _state.indexToDelete = index
                          : _state.indexToDelete = null;
                    });
                  },
                  selected: _state.indexToDelete == index ? true : false,
                  selectedTileColor: Colors.blue[100],
                );
              });
        }
        break;
      case 3:
        if (_state.vault.songs == null || _state.vault.songs.length == 0) {
          returnWidget = Text("Please Add to your songs");
        } else {
          returnWidget = ListView.builder(
              itemCount: _state.vault.songs.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(_state.vault.songs[index].name),
                  subtitle: Text(_state.vault.songs[index].category),
                  onLongPress: () {
                    _state.setState(() {
                      _state.indexToDelete != index
                          ? _state.indexToDelete = index
                          : _state.indexToDelete = null;
                    });
                  },
                  selected: _state.indexToDelete == index ? true : false,
                  selectedTileColor: Colors.blue[100],
                );
              });
        }
        break;
      case 4:
        if (_state.vault.stories == null || _state.vault.stories.length == 0) {
          returnWidget = Text("Please Add to your stories");
        } else {
          returnWidget = ListView.builder(
              itemCount: _state.vault.stories.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text("Story #" + (index + 1).toString()),
                  subtitle: Text(
                      _state.vault.stories[index].substring(0, 50) + "..."),
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            content: SingleChildScrollView(
                                child: Text(_state.vault.stories[index])),
                          );
                        });
                  },
                  //add index to list
                  onLongPress: () {
                    _state.setState(() {
                      _state.indexToDelete != index
                          ? _state.indexToDelete = index
                          : _state.indexToDelete = null;
                    });
                  },
                  selected: _state.indexToDelete == index ? true : false,
                  selectedTileColor: Colors.blue[100],
                );
              });
        }
        break;
      case 5:
        if (_state.vault.videos == null || _state.vault.videos.length == 0) {
          returnWidget = Text("Please Add to your videos");
        } else {
          returnWidget = ListView.builder(
              itemCount: _state.vault.videos.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(_state.vault.videos[index].name),
                  subtitle: Text(_state.vault.videos[index].category),
                  onLongPress: () {
                    _state.setState(() {
                      _state.indexToDelete != index
                          ? _state.indexToDelete = index
                          : _state.indexToDelete = null;
                    });
                  },
                  selected: _state.indexToDelete == index ? true : false,
                  selectedTileColor: Colors.blue[100],
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

  void delete(view) async {
    if (_state.indexToDelete == null) {
      print("No item selected to delete");
      return;
    }
    switch (_state.view) {
      case 1:
        deletePic();
        break;
      case 2:
        deleteQuote();
        break;
      case 3:
        deleteSong();
        break;
      case 4:
        deleteStory();
        break;
      case 5:
        deleteVideo();
        break;
    }
  }

  void deletePic() async {
    print("delete pic");
    MyDialog.circularProgressStart(_state.context);
    try {
      //print(_state.vault.pictures[_state.indexToDelete].docId);
      //print(_state.vault.docId);
      await FirebaseController.deletePicture(
          _state.vault.pictures[_state.indexToDelete], _state.vault.docId);
      _state.vault.pictures.removeAt(_state.indexToDelete);
      MyDialog.circularProgressEnd(_state.context);
      _state.render(() {
        _state.indexToDelete = null;
      });
    } catch (e) {
      MyDialog.circularProgressEnd(_state.context);
      MyDialog.info(
          context: _state.context,
          title: "Delete Picture Error",
          content: e.toString());
    }
  }

  void deleteQuote() async {
    print("delete quote");
    MyDialog.circularProgressStart(_state.context);
    try {
      await FirebaseController.deleteQuote(_state.user, _state.indexToDelete);
      _state.vault.quotes.removeAt(_state.indexToDelete);
      MyDialog.circularProgressEnd(_state.context);
      _state.render(() {
        _state.indexToDelete = null;
      });
    } catch (e) {
      MyDialog.circularProgressEnd(_state.context);
      MyDialog.info(
          context: _state.context,
          title: "Delete Quote Error",
          content: e.toString());
    }
  }

  void deleteSong() async {
    print("delete song");
    MyDialog.circularProgressStart(_state.context);
    try {
      await FirebaseController.deleteSong(
          _state.vault.songs[_state.indexToDelete], _state.vault.docId);
      _state.vault.songs.removeAt(_state.indexToDelete);
      MyDialog.circularProgressEnd(_state.context);
      _state.render(() {
        _state.indexToDelete = null;
      });
    } catch (e) {
      MyDialog.circularProgressEnd(_state.context);
      MyDialog.info(
          context: _state.context,
          title: "Delete Picture Error",
          content: e.toString());
    }
  }

  void deleteStory() async {
    print("delete story at " + _state.indexToDelete.toString());
    MyDialog.circularProgressStart(_state.context);
    try {
      await FirebaseController.deleteStory(_state.user, _state.indexToDelete);
      _state.vault.stories.removeAt(_state.indexToDelete);
      MyDialog.circularProgressEnd(_state.context);
      _state.render(() {
        _state.indexToDelete = null;
      });
    } catch (e) {
      MyDialog.circularProgressEnd(_state.context);
      MyDialog.info(
          context: _state.context,
          title: "Delete Story Error",
          content: e.toString());
    }
  }

  void deleteVideo() async {
    print("delete video");
    MyDialog.circularProgressStart(_state.context);
    try {
      await FirebaseController.deleteVideo(
          _state.vault.videos[_state.indexToDelete], _state.vault.docId);
      _state.vault.videos.removeAt(_state.indexToDelete);
      MyDialog.circularProgressEnd(_state.context);
      _state.render(() {
        _state.indexToDelete = null;
      });
    } catch (e) {
      MyDialog.circularProgressEnd(_state.context);
      MyDialog.info(
          context: _state.context,
          title: "Delete Video Error",
          content: e.toString());
    }
  }

  //action buttons on the appbar
  List<Widget> actions(int view, int index) {
    if (view == 0) {
      return [Container()];
    } else if (index != null) {
      return [
        IconButton(
            icon: Icon(Icons.edit),
            onPressed: () async {
              await Navigator.pushNamed(
                  _state.context, EditFeelGoodVault.routeName, arguments: {
                'user': _state.user,
                'view': view,
                'index': index,
                'vault': _state.vault
              });
              _state.render((){});
            }),
        IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              delete(view);
            })
      ];
    } else {
      return [
        Container(
          padding: EdgeInsets.all(10),
          width: 150.0,
          child: Form(
            key: searchKey,
            child: TextFormField(
              decoration: InputDecoration(
                hintText: "Search Name",
                fillColor: Colors.white,
                filled: true,
              ),
              autocorrect: false,
              onSaved: (_) {},
            ),
          ),
        ),
        IconButton(icon: Icon(Icons.search), onPressed: () {})
      ];
    }
  }
}
