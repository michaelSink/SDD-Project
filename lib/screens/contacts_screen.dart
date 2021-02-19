import 'package:flutter/material.dart';

class ContactScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ContactScreen();
  }

}

class _ContactScreen extends State<ContactScreen>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("People I Know"),
      ),
      body: SingleChildScrollView(
        child: Text("Body")
      ),
    );
  }

}