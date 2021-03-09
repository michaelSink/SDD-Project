import 'package:SDD_Project/model/hotline.dart';
import 'package:SDD_Project/screens/addHotline_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HotlineScreen extends StatefulWidget{

  static const routeName = '/signIn/homeScreen/hotlineScreen/';

  @override
  State<StatefulWidget> createState() {
    return _HotlineState();
  }

}

class _HotlineState extends State<HotlineScreen>{

  _Controller con;
  List<Hotline> hotlines;
  FirebaseUser user;
  int defaultIndex = 0;

  Future<void> _showMyDialog(String number, String name) async {
    print(number);
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Would you like to call the ${name}?'),
              ],
            ),
          ),
          actions: <Widget>[
            RaisedButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            RaisedButton(
              child: Text('Approve'),
              onPressed: () async {
                await launch("tel:${number.replaceAll('-', '')}");
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

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
    hotlines ??= arg['hotlines'];

    return Scaffold(
      appBar: AppBar(
        title: Text('Emergency Hotlines'),
      ),
      body: ListView.builder(
        itemCount: hotlines.length + 6,
        itemBuilder: (BuildContext context, int index) => 
        index < hotlines.length ?
          Container(
            margin: EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(width: 3, color: Colors.black),
                bottom: BorderSide(width: 3, color: Colors.black),
                left: BorderSide(width: 3, color: Colors.black),
                right: BorderSide(width: 3, color: Colors.black),
              ),
            ),
            child: Card(
              elevation: 8,
              child: InkWell(
                onTap: () => _showMyDialog(hotlines[index].phoneNumber, hotlines[index].name),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${hotlines[index].name}',
                      style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Purpose: ${hotlines[index].purpose}',
                      style: TextStyle(fontSize: 20),
                    ),
                    Divider(
                      color: Colors.grey,
                      height: 15,
                      thickness: 2,
                    ),
                    Text(
                      '${hotlines[index].description}',
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      'Available: ${hotlines[index].availability}',
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      'Call at: ${hotlines[index].phoneNumber}',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
          )
          : Container(
            margin: EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(width: 3, color: Colors.black),
                bottom: BorderSide(width: 3, color: Colors.black),
                left: BorderSide(width: 3, color: Colors.black),
                right: BorderSide(width: 3, color: Colors.black),
              ),
            ),
            child: Card(
              elevation: 8,
              child: InkWell(
                onTap: () => _showMyDialog(Hotline.defaultHotline[index - hotlines.length].phoneNumber, Hotline.defaultHotline[index - hotlines.length].name),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${Hotline.defaultHotline[index - hotlines.length].name}',
                      style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Purpose: ${Hotline.defaultHotline[index - hotlines.length].purpose}',
                      style: TextStyle(fontSize: 20),
                    ),
                    Divider(
                      color: Colors.grey,
                      height: 15,
                      thickness: 2,
                    ),
                    Text(
                      '${Hotline.defaultHotline[index - hotlines.length].description}',
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      'Available: ${Hotline.defaultHotline[index - hotlines.length].availability}',
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      'Call at: ${Hotline.defaultHotline[index - hotlines.length].phoneNumber}',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: con.addHotline,
        child: Icon(Icons.add),
      ),
    );
  }

}

class _Controller{
  _HotlineState _state;
  _Controller(this._state);

  void addHotline() async {
    await Navigator.pushNamed(_state.context, AddHotline.routeName, 
            arguments: {'hotlines' : _state.hotlines, 'user' : _state.user});
    _state.render((){});
  }

}