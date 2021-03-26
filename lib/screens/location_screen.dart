import 'package:SDD_Project/model/location.dart';
import 'package:SDD_Project/screens/addLocation_screen.dart';
import 'package:SDD_Project/screens/views/mydialog.dart';
import 'package:SDD_Project/screens/views/myimageview.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class LocationScreen extends StatefulWidget{

  static const routeName = '/signIn/homeScreen/locationScreen/';

  @override
  State<StatefulWidget> createState() {
    return _LocationScreenState();
  }
}

class _LocationScreenState extends State<LocationScreen>{

  _Controller con;
  FirebaseUser user;
  List<Location> locations;

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
    locations ??= arg['locations'];

    return Scaffold(
      appBar: AppBar(
        title: Text('Social Settings'),
      ),
      body: ListView.builder(
        itemCount: locations.length,
        itemBuilder: (BuildContext context, int index) => Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0)
          ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MyImageView.network(imageUrl: locations[index].photoURL, context: context),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    locations[index].name,
                    style: TextStyle( fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
                Divider(
                  color: Colors.black,
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    locations[index].description,
                    style: TextStyle( fontSize: 22, color: Colors.grey[800]),
                  ),
                ),
                ButtonBar(
                  alignment: MainAxisAlignment.start,
                  children: [
                    ElevatedButton(
                      onPressed: () => con.displayLocation(locations[index].location), 
                      child: Row(
                        children: [
                          Icon(Icons.my_location),
                          Text('Map')
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: con.addLocation,
        child: Icon(Icons.add),
      ),
    );
  }
}

class _Controller{

  _LocationScreenState _state;
  _Controller(this._state);

  void addLocation() async{

    try{

      await Navigator.pushNamed(_state.context, AddLocationScreen.routeName,
              arguments: {'user' : _state.user, 'locations' : _state.locations});
      _state.render((){});
    }catch(e){
      MyDialog.info(
        title: 'Error',
        context: _state.context,
        content: e.toString()
      );
    }
  }

  void displayLocation(String address) async{
    await canLaunch(
      "http://maps.google.com/maps?q=" + address) 
      ? 
      await launch("http://maps.google.com/maps?q=" + address) 
        : 
      MyDialog.info(
        content: "Cannot open link to map",
        context: _state.context,
        title: "Error",
      );
  }

}