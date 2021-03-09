import 'package:firebase_auth/firebase_auth.dart';
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
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Map args = ModalRoute.of(context).settings.arguments;
    user ??= args['user'];

    return Scaffold(
      appBar: AppBar(
        title: Text("Feel Good Vault"),
      ),
      body: Column(
        children: <Widget>[
          Card(
            elevation: 5,
            margin: EdgeInsets.all(15),
            child: ListTile(
              leading: Icon(Icons.camera_alt),
              title: Text("Pictures"),
               onTap: (){},
            ),
          ),
          Card(
            elevation: 5,
            margin: EdgeInsets.all(15),
            child: ListTile(
              leading: Icon(Icons.format_quote_outlined),
              title: Text("Quotes"),
               onTap: (){},
            ),
          ),
          Card(
            elevation: 5,
            margin: EdgeInsets.all(15),
            child: ListTile(
              leading: Icon(Icons.music_note_outlined),
              title: Text("Songs"),
               onTap: (){},
            ),
          ),
          Card(
            elevation: 5,
            margin: EdgeInsets.all(15),
            child: ListTile(
              leading: Icon(Icons.video_collection_outlined),
              title: Text("Video"),
              onTap: (){},
            ),
          ),
          Card(
            elevation: 5,
            margin: EdgeInsets.all(15),
            child: ListTile(
              leading: Icon(Icons.book_outlined),
              title: Text("Stories"),
              onTap: (){},
            ),
          ),
        ],
      )
    );
  }
}
