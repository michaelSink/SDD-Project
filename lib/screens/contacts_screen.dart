import 'package:SDD_Project/controller/firebasecontroller.dart';
import 'package:SDD_Project/model/contacts.dart';
import 'package:SDD_Project/screens/views/mydialog.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

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
  String user;

  render(fn) => setState(fn);

  popupForm() {
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Form(
            key: formKey,
            child: Container(
              height: MediaQuery.of(context).size.height / 2,
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Text(
                      "Enter contact info",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
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
                    ElevatedButton(
                      child: Text("Submit"),
                      onPressed: () {
                        con.submit();
                      }, //change later to submit
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  popupDialog(String action, String number) {
    showDialog(
        barrierDismissible: true,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text("Do you want to ${action} this person?"),
            actions: <Widget>[
              ElevatedButton(
                  onPressed: () async {
                    await launch("tel:${number}");
                    Navigator.of(context).pop();
                  },
                  child: Text("Yes")),
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("No"))
            ],
          );
        });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    con = _Controller(this);
  }

  @override
  Widget build(BuildContext context) {
    Map args = ModalRoute.of(context).settings.arguments;
    user ??= args['user'];
    contacts ??= args['contacts'];

    print(contacts.length);

    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("People I Know"),
      ),
      body: contacts.length == 0
          ? Text("No Contacts, please add some")
          : ListView.builder(
              itemCount: contacts.length,
              itemBuilder: (BuildContext context, int index) => Container(
                child: Card(
                  child: ListTile(
                    leading: Icon(Icons.person),
                    title: Text(contacts[index].firstName +
                        " " +
                        contacts[index].lastName),
                    trailing: Container(
                        width: 100,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            IconButton(
                              icon: Icon(Icons.phone),
                              onPressed: () {
                                popupDialog("call", contacts[index].phoneNum);
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.phone_android),
                              onPressed: () async {
                                popupDialog("text", contacts[index].phoneNum);
                              },
                            ),
                          ],
                        )),
                    onTap: () {},
                  ),
                ),
              ),
            ),
      floatingActionButton: IconButton(
        icon: Icon(Icons.add),
        onPressed: () {
          //open up a popup form
          popupForm();
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
        owner: _state.user,
        relation: "contact",
      );

      c.docID = await FirebaseController.addContact(c);
      //print("here"); debug
      _state.contacts.insert(0, c);
      MyDialog.circularProgressEnd(_state.context); //pop circular from add
      Navigator.pop(_state.context); //pop dialog box from form
      _state.render(() {});
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
