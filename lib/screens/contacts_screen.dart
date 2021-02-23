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
  _Controller con;
  var formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    con = _Controller(this);
  }

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
      floatingActionButton: IconButton(
        icon: Icon(Icons.add),
        onPressed: () {
          //open up a popup form
          showDialog(
            barrierDismissible: true,
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                content: Form(
                  key: formKey,
                  child: Container(
                    height: MediaQuery.of(context).size.height / 2,
                    child: Column(
                      children: <Widget>[
                        Text("Enter contant info", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),),
                        Container(
                          //first name container
                          alignment: Alignment.bottomCenter,
                          width: MediaQuery.of(context).size.width / 2,
                          child: TextFormField(
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                                hintText: "First name",
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(gapPadding: 20.0)),
                            autocorrect: false,
                            //onSaved: add function to save,
                            //validator: add function to validate,
                          ),
                        ),
                        Container(
                          //last name container
                          alignment: Alignment.bottomCenter,
                          padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                          width: MediaQuery.of(context).size.width / 2,
                          child: TextFormField(
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                                hintText: "last name",
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(gapPadding: 20.0)),
                            autocorrect: false,
                            //onSaved: add function to save,
                            //validator: add function to validate,
                          ),
                        ),
                        Container(
                          //phone # container
                          alignment: Alignment.bottomCenter,
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                          width: MediaQuery.of(context).size.width / 2,
                          child: TextFormField(
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                                hintText: "phone number",
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(gapPadding: 20.0)),
                            autocorrect: false,
                            keyboardType: TextInputType.number,
                            //onSaved: add function to save,
                            //validator: add function to validate,
                          ),
                        ),
                        RaisedButton(
                          child: Text("Submit"),
                          onPressed: () {}, //change later to submit
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _Controller {
  _ContactScreen _state;
  _Controller(this._state);
}
