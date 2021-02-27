import 'package:SDD_Project/controller/firebasecontroller.dart';
import 'package:SDD_Project/model/contacts.dart';
import 'package:SDD_Project/screens/views/mydialog.dart';
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

  render(fn) => setState(fn);

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
                        Text(
                          "Enter contact info",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w500),
                        ),
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
                            onSaved: con.saveFirstName,
                            validator: con.validateFirstName,
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
                            onSaved: con.saveLastName,
                            validator: con.validateLastName,
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
                            onSaved: con.savePhoneNum,
                            validator: con.validatePhoneNum,
                          ),
                        ),
                        RaisedButton(
                          child: Text("Submit"),
                          onPressed: () {
                            con.submit();
                          }, //change later to submit
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
  String firstName, lastName, phoneNum;

  //validators
  String validateFirstName(String s) {
    if (s == null || s.trim() == "") {
      return "Please enter a name";
    } else {
      return null;
    }
  }

  String validateLastName(String s) {
    if (s == null || s.trim() == "") {
      return "Please enter a name";
    } else {
      return null;
    }
  }

  String validatePhoneNum(String s) {
    if (s == null || s.length != 10) {
      return "Please enter a phone number 000 000 0000";
    } else {
      return null;
    }
  }

  //save functions
  void saveFirstName(String s) {
    firstName = s;
  }

  void saveLastName(String s) {
    lastName = s;
  }

  void savePhoneNum(String s) {
    phoneNum = s;
  }

  void submit() async {
    if (!_state.formKey.currentState.validate()) {
      return;
    }

    _state.formKey.currentState.save();
    MyDialog.circularProgressStart(_state.context);
    try {
      var c = Contacts(
        firstName: firstName,
        lastName: lastName,
        phoneNum: phoneNum,
      );

      c.docID = await FirebaseController.addContact(c);
      print("here");
      //_state.contacts.insert(0, c); deal with later
      MyDialog.circularProgressEnd(_state.context);  //pop circular from add
      Navigator.pop(_state.context);  //pop dialog box from form
      MyDialog.info(
          title: "Contact Added",
          context: _state.context,
          content: "Contact successfully added");
      return;
    } catch (e) {
      MyDialog.circularProgressEnd(_state.context);
      MyDialog.info(
          title: "Contact Add Error",
          context: _state.context,
          content: e.message.toString());
      return;
    }
  }
}
