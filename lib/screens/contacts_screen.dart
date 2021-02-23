import 'package:SDD_Project/model/contacts.dart';
import 'package:flutter/material.dart';

class ContactScreen extends StatefulWidget {
  static const routeName = '/homescreen/contactScreen';

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ContactScreen();
  }
}

class _ContactScreen extends State<ContactScreen> {
  List<Contacts> contacts;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("People I Know"),
      ),
      body: SingleChildScrollView(
          child: contacts == null
              ? Text("No Contacts, please add some")
              : ListView.builder(
                  itemBuilder: (BuildContext context, int index) {})),
    );
  }
}
