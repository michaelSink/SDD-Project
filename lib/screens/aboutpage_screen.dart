import 'package:SDD_Project/controller/aboutdb.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AboutPageScreen extends StatefulWidget {
  static const routeName = '/homeScreen/aboutPageScreen';
  @override
  State<StatefulWidget> createState() {
    return _AboutPageState();
  }
}

class _AboutPageState extends State<AboutPageScreen> {
  String summary;
  String features;

  Stream aboutus;

  aboutMedthods aboutObj = new aboutMedthods();

  Future<bool> addDialog(BuildContext context) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Edit Info', style: TextStyle(fontSize: 15.0)),
            content: Column(
              children: <Widget>[
                TextFormField(
                  style:TextStyle(fontSize: 14.0),
                  decoration: InputDecoration(
                    hintText: 'Enter Summary'
                    ),
                    autocorrect: true,
                    keyboardType: TextInputType.multiline,
                    maxLines: 3,
                  onChanged: (value) {
                    this.summary = value;
                  },
                ),
                SizedBox(
                  height: 5.0,
                ),
                TextFormField(
                  style:TextStyle(fontSize: 14.0),
                  decoration: InputDecoration(
                    hintText: 'Enter Features'
                    ),
                    autocorrect: true,
                    keyboardType: TextInputType.multiline,
                    maxLines: 5,
                  onChanged: (value) {
                    this.features = value;
                  },
                )
              ],
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Add'),
                textColor: Colors.blue,
                onPressed: () {
                  Navigator.of(context).pop();
                  aboutObj.addData({
                    'summary': this.summary,
                    'features': this.features
                  }).then((result) {
                    dialogTrigger(context);
                  }).catchError((e) {
                    print(e);
                  });
                },
              )
            ],
          );
        });
  }

  Future<bool> updateDialog(BuildContext context, selectedDoc) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('update Info', style: TextStyle(fontSize: 15.0)),
            content: Column(
              children: <Widget>[
                TextFormField(
                  style:TextStyle(fontSize: 14.0),
                  decoration: InputDecoration(
                    hintText: 'Enter Summary'
                    ),
                    autocorrect: true,
                    keyboardType: TextInputType.multiline,
                    maxLines: 3,
                  onChanged: (value) {
                    this.summary = value;
                  },
                ),
                SizedBox(
                  height: 5.0,
                ),
                TextFormField(
                  style:TextStyle(fontSize: 14.0),
                  decoration: InputDecoration(
                    hintText: 'Enter Features'
                    ),
                    autocorrect: true,
                    keyboardType: TextInputType.multiline,
                    maxLines: 5,
                  onChanged: (value) {
                    this.features = value;
                  },
                )
              ],
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Update'),
                textColor: Colors.blue,
                onPressed: () {
                  Navigator.of(context).pop();
                  aboutObj
                      .updateData(selectedDoc, {
                        'summary': this.summary,
                        'features': this.features
                      })
                      .then((result) {})
                      .catchError((e) {
                        print(e);
                      });
                },
              )
            ],
          );
        });
  }

  Future<bool> dialogTrigger(BuildContext context) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('About Us', style: TextStyle(fontSize: 15.0)),
            content: Text('Added'),
            actions: <Widget>[
              FlatButton(
                child: Text('Alright'),
                textColor: Colors.blue,
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  @override
  void initState() {
    aboutObj.getData().then((results) {
      setState(() {
        aboutus = results;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blue[900],
        appBar: AppBar(
          backgroundColor: Colors.blue[900],
          title: Text('About Us'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                addDialog(context);
              },
            ),
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () {
                aboutObj.getData().then((results) {
                  setState(() {
                    aboutus = results;
                  });
                });
              },
            ),
          ],
        ),
        body: _aboutusList(),
        );
  }

  Widget _aboutusList() {
    if (aboutus != null) {
      return StreamBuilder(
          stream: aboutus,
          builder: (context, snapshot) {
            return ListView.builder(
                itemCount: snapshot.data.documents.length,
                padding: EdgeInsets.all(5.0),
                itemBuilder: (context, i) {
                  return Card(
                    color: Colors.white,
                    child: new ListTile(
                      title: Text(
                          snapshot.data.documents[i].data['summary'] ?? ''),
                      subtitle: Text(
                          snapshot.data.documents[i].data['features'] ?? ''),
                      onTap: () {
                        updateDialog(
                            context, snapshot.data.documents[i].documentID);
                      },
                      onLongPress: () {
                        aboutObj
                            .deleteData(snapshot.data.documents[i].documentID);
                      },
                    ),
                  );
                });
          });
    } else {
      return Text('Loading, please wait...');
    }
  }
}
