import 'package:SDD_Project/controller/firebasecontroller.dart';
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
  dynamic vault;
  String vaultKey;

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
                      title: Text("Videos"),
                      onTap: () => setState(() {
                        viewSelected = true;
                        vaultKey = "videos";
                        view = 4;
                      }),
                    ),
                  ),
                  Card(
                    elevation: 5,
                    margin: EdgeInsets.all(15),
                    child: ListTile(
                      leading: Icon(Icons.book_outlined),
                      title: Text("Stories"),
                      onTap: () => setState(() {
                        viewSelected = true;
                        vaultKey = "stories";
                        view = 5;
                      }),
                    ),
                  ),
                ],
              )
            : con.buildList(view),
      ),
    );
  }
}

class _Controller {
  _FeelGoodVault _state;
  _Controller(this._state);
  //var array;

  Widget buildList(view) {
    Widget returnWidget;
    _state.vault[_state.vaultKey].length == 0
        ? returnWidget = Text("Please enter some info")
        : returnWidget = ListView.builder(
            itemCount: _state.vault[_state.vaultKey].length, itemBuilder: (BuildContext context, int index) {
              return Container(
                child: Text(_state.vault[_state.vaultKey][index]),
              );
            });

    return returnWidget;
  }
}
