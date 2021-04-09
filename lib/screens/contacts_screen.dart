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
  var searchKey = GlobalKey<FormState>();
  String user;
  int selectedIndex;
  Map<int, String> contactsToDelete;
  Contacts contactToEdit;

  render(fn) => setState(fn);

  //-----popup forms for the body-----//

  //form for new contact information
  popupForm(String mode) {
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
                        initialValue: contactToEdit == null
                            ? ""
                            : contactToEdit.firstName,
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
                        initialValue:
                            contactToEdit == null ? "" : contactToEdit.lastName,
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
                        initialValue:
                            contactToEdit == null ? "" : contactToEdit.phoneNum,
                        keyboardType: TextInputType.number,
                        onSaved: con.savePhoneNum,
                        validator: con.validatePhoneNum,
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
                            hintText: "relation",
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(gapPadding: 20.0)),
                        autocorrect: false,
                        initialValue:
                            contactToEdit == null ? "" : contactToEdit.relation,
                        onSaved: con.saveRelation,
                        validator: con.validateRelation,
                      ),
                    ),
                    mode == "add"
                        ? ElevatedButton(
                            child: Text("Submit"),
                            onPressed: () {
                              con.submit();
                            },
                          )
                        : ElevatedButton(
                            child: Text("Edit"),
                            onPressed: () {
                              con.update();
                              setState(() {});
                            },
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

  //popup for calling or texting a contact
  popupDialog(String action, Contacts contact) {
    showDialog(
        barrierDismissible: true,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text("Do you want to $action ${contact.firstName}?"),
            actions: <Widget>[
              ElevatedButton(
                  onPressed: () async {
                    String reach;
                    action == "call" ? reach = "tel" : reach = "sms";
                    await launch("$reach:${contact.phoneNum}");
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

  //---------------------------------//

  @override
  void initState() {
    super.initState();
    con = _Controller(this);
  }

  //body of the screen
  @override
  Widget build(BuildContext context) {
    Map args = ModalRoute.of(context).settings.arguments;
    user ??= args['user'];
    contacts ??= args['contacts'];

    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Contacts"),
        actions: selectedIndex == null
            ? <Widget>[
                Container(
                  padding: EdgeInsets.all(10),
                  width: 150.0,
                  child: Form(
                    key: searchKey,
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: "Search First Name",
                        fillColor: Colors.white,
                        filled: true,
                      ),
                      autocorrect: false,
                      onSaved: con.saveSearchKey,
                    ),
                  ),
                ),
                IconButton(icon: Icon(Icons.search), onPressed: con.search)
              ]
            : <Widget>[
                IconButton(icon: Icon(Icons.edit), onPressed: con.edit),
                IconButton(icon: Icon(Icons.delete), onPressed: con.delete)
              ],
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
                        width: MediaQuery.of(context).size.width / 4,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            IconButton(
                              icon: Icon(Icons.phone),
                              onPressed: () {
                                //open up a dialog box to confirm call
                                popupDialog("call", contacts[index]);
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.phone_android),
                              onPressed: () async {
                                //open up a dialog box to confirm text
                                popupDialog("text", contacts[index]);
                              },
                            ),
                          ],
                        )),
                    selected: index == selectedIndex ? true : false,
                    selectedTileColor: Colors.blue[100],
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            String number = contacts[index].phoneNum;
                            String first = number.substring(0, 3);
                            String second = number.substring(3, 6);
                            String third =
                                number.substring(6); //number formatting
                            return AlertDialog(
                              content: ListTile(
                                title: Text(contacts[index].firstName +
                                    " " +
                                    contacts[index].lastName),
                                //format number to (xxx) xxx-xxxx
                                subtitle: Text("(" +
                                    first +
                                    ")" +
                                    second +
                                    "-" +
                                    third +
                                    "\n" +
                                    contacts[index].relation),
                              ),
                            );
                          });
                    },
                    onLongPress: () {
                      //uodated list of contacts selected for deletion
                      selectedIndex == index
                          ? selectedIndex = null
                          : selectedIndex = index;
                      render(() {});
                    },
                  ),
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          //open up a popup form
          popupForm("add");
        },
      ),
    );
  }
}

//start of controller for firebase and button functions
class _Controller {
  _ContactScreen _state;
  _Controller(this._state);
  String firstName, lastName, phoneNum, relation, searchKey;

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
    if (s == null || s.length < 10) {
      return "Please enter 10 digit phone #";
    } else {
      return null;
    }
  }

  String validateRelation(String s) {
    if (s == null || s.trim() == "") {
      return "Please enter your relation to this person";
    } else {
      return null;
    }
  }

  //save functions
  //change input name to capitalize first letter
  void saveFirstName(String s) {
    String first = s.substring(0, 1);
    String last = s.substring(1);
    first = first.toUpperCase();
    last = last.toLowerCase();
    firstName = first + last;
  }

  //change input name to capitalize first letter
  void saveLastName(String s) {
    String first = s.substring(0, 1);
    String last = s.substring(1);
    first = first.toUpperCase();
    last = last.toLowerCase();
    lastName = first + last;
  }

  void saveRelation(String s) {
    relation = s;
  }

  void savePhoneNum(String s) {
    s = s.replaceAll("-", "");
    s = s.replaceAll("(", "");
    s = s.replaceAll(")", "");
    s = s.replaceAll(" ", "");
    //to keep all the phone #s consistent,
    //change (xxx)-xxx-xxxx; xxx-xxx-xxxx; xxx xxx xxxx to the format xxxxxxxxxx
    phoneNum = s;
  }

  void saveSearchKey(String s) {
    searchKey = s;
  }

  //to add a new contact
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
        relation: relation,
      );

      c.docID = await FirebaseController.addContact(c);
      //print("here"); debug
      MyDialog.circularProgressEnd(_state.context); //pop circular from add
      Navigator.pop(_state.context); //pop dialog box from form
      _state.render(() {
        _state.contacts.add(c);
      });
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

  void update() async {
    if (!_state.formKey.currentState.validate()) {
      return;
    }

    _state.formKey.currentState.save();
    MyDialog.circularProgressStart(_state.context);

    try {
      _state.contactToEdit = Contacts(
          firstName: firstName,
          lastName: lastName,
          phoneNum: phoneNum,
          owner: _state.contactToEdit.owner,
          relation: relation,
          docID: _state.contactToEdit.docID);
      await FirebaseController.updateContact(_state.contactToEdit);
      MyDialog.circularProgressEnd(_state.context);
      Navigator.pop(_state.context);
      _state.contacts.removeAt(_state.selectedIndex);
      _state.contacts.insert(_state.selectedIndex, _state.contactToEdit);
       MyDialog.info(
          title: "Contact Updated",
          context: _state.context,
          content: "Contact successfully updated");
    } catch (e) {
      MyDialog.info(
          title: "Contact Edit Error",
          context: _state.context,
          content: e.toString());
      MyDialog.circularProgressEnd(_state.context);
      return;
    }
    _state.render(() {
      _state.selectedIndex = null;
    });
  }

  //deleting contacts from the index
  void delete() async {
    if (_state.selectedIndex == null) {
      return;
    }
    MyDialog.circularProgressStart(_state.context);
    try {
      await FirebaseController.deleteContacts(
          _state.contacts.elementAt(_state.selectedIndex));
      _state.contacts.removeAt(_state.selectedIndex);
      MyDialog.circularProgressEnd(_state.context);
      _state.render(() {
        _state.selectedIndex = null;
      });
      MyDialog.info(
          title: "Contact Deleted",
          context: _state.context,
          content: "Contact successfully deleted");
    } catch (e) {
      MyDialog.info(
          title: "Contact Delete Error",
          context: _state.context,
          content: e.toString());
      MyDialog.circularProgressEnd(_state.context);
      return;
    }
  }

  void edit() async {
    if (_state.selectedIndex == null) {
      return;
    }
    _state.contactToEdit = _state.contacts.elementAt(_state.selectedIndex);
    _state.popupForm("edit");
  }

  void search() async {
    _state.searchKey.currentState.save();

    List<Contacts> result;
    if (searchKey == null || searchKey.trim().isEmpty) {
      result = await FirebaseController.getContacts(_state.user);
    } else {
      String first = searchKey.substring(0, 1);
      String last = searchKey.substring(1);
      first = first.toUpperCase();
      last = last.toLowerCase();
      searchKey = first + last;
      result = await FirebaseController.searchContacts(_state.user, searchKey);
    }

    _state.render(() => _state.contacts = result);
  }
}
