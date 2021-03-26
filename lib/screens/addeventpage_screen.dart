import 'package:flutter/material.dart';



class AddEventPageScreen extends StatefulWidget {
  static const routeName = '/homeScreen/addEventPageScreen';
  @override
  State<StatefulWidget> createState() {
    return _AddEventPageState();
  }
}

class _AddEventPageState extends State<AddEventPageScreen> {
  // final _formKey = GlobalKey<FormBuilderState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Event'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
         
        ],
      ),
    );
  }
}
