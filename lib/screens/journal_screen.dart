import 'package:SDD_Project/controller/firebasecontroller.dart';
import 'package:SDD_Project/model/journal.dart';
import 'package:SDD_Project/screens/views/mydialog.dart';
import 'package:flutter/material.dart';

class JournalScreen extends StatefulWidget {
  static const routeName = '/homescreen/journalScreen';

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _JournalScreen();
  }
}

class _JournalScreen extends State<JournalScreen> {
  List<Journal> journals;
  _Controller con;
  var formKey = GlobalKey<FormState>();
  String user;
  List<int> selectedIndex = [];
  Map<int, String> journalsToDelete;

  render(fn) => setState(fn);

  //-----popup forms for the body-----//

  //form for new journal
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
                      "Enter Journal",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                    ),
                    Container(
                      //title container
                      alignment: Alignment.bottomCenter,
                      width: MediaQuery.of(context).size.width / 2,
                      child: TextFormField(
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                            hintText: "Title",
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(gapPadding: 20.0)),
                        autocorrect: false,
                        onSaved: con.saveTitle,
                        validator: con.validateTitle,
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
                            hintText: "date",
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(gapPadding: 20.0)),
                        autocorrect: false,
                        keyboardType: TextInputType.datetime,
                        onSaved: con.saveDate,
                        validator: con.validateDate,
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
                            hintText: "entry",
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(gapPadding: 20.0)),
                        autocorrect: false,
                        onSaved: con.saveEntry,
                        validator: con.validateEntry,
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
    journals ??= args['journal'];

    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("My Journals"),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.delete), onPressed: con.delete)
        ],
      ),
      body: journals.length == 0
          ? Text("No Journals, please add some")
          : ListView.builder(
              itemCount: journals.length,
              itemBuilder: (BuildContext context, int index) => Container(
                child: Card(
                  child: ListTile(
                    leading: Icon(Icons.person),
                    title: Text(
                        journals[index].title + " " + journals[index].date),
                    trailing: Container(
                        width: MediaQuery.of(context).size.width / 4,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [],
                        )),
                    selected: selectedIndex.contains(index) ? true : false,
                    selectedTileColor: Colors.blue[100],
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              content: ListTile(
                                title: Text(journals[index].title),
                                subtitle: Text(journals[index].date +
                                    "\n" +
                                    journals[index].entry),
                              ),
                            );
                          });
                    },
                    onLongPress: () {
                      //uodated list of journals selected for deletion
                      selectedIndex.contains(index)
                          ? selectedIndex.remove(index)
                          : selectedIndex.add(index);
                      render(() {});
                    },
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

//start of controller for firebase and button functions
class _Controller {
  _JournalScreen _state;
  _Controller(this._state);
  String title, date, entry;

  //validators
  String validateTitle(String s) {
    if (s == null || s.trim() == "") {
      return "Please enter a title";
    } else {
      return null;
    }
  }

  String validateDate(String s) {
    if (s == null || s.trim() == "") {
      return "Please enter a date";
    } else {
      return null;
    }
  }

  String validateEntry(String s) {
    if (s == null || s.trim() == "") {
      return "Please enter text for the entry";
    } else {
      return null;
    }
  }

  //save functions
  void saveTitle(String s) {
    title = s;
  }

  void saveDate(String s) {
    date = s;
  }

  void saveEntry(String s) {
    entry = s;
  }

  //to add a new journal
  void submit() async {
    if (!_state.formKey.currentState.validate()) {
      return;
    }

    _state.formKey.currentState.save();
    MyDialog.circularProgressStart(_state.context);
    try {
      var j = Journal(
        title: title,
        date: date,
        entry: entry,
        owner: _state.user,
      );

      j.docID = await FirebaseController.addJournal(j);
      //print("here"); debug
      MyDialog.circularProgressEnd(_state.context); //pop circular from add
      Navigator.pop(_state.context); //pop dialog box from form
      _state.render(() {
        _state.journals.add(j);
      });
      MyDialog.info(
          title: "Journal Added",
          context: _state.context,
          content: "Journal successfully added");
      return;
    } catch (e) {
      MyDialog.circularProgressEnd(_state.context);
      MyDialog.info(
          title: "Journal Add Error",
          context: _state.context,
          content: e.message.toString());
      return;
    }
  }

  //deleting journals from the index
  void delete() async {
    if (_state.selectedIndex.length == 0) {
      return;
    }
    MyDialog.circularProgressStart(_state.context);
    try {
      for (int i = 0; i < _state.selectedIndex.length; i++) {
        await FirebaseController.deleteJournal(
            _state.journals.elementAt(_state.selectedIndex[i]));
        _state.journals.removeAt(_state.selectedIndex[i]);
      }

      MyDialog.circularProgressEnd(_state.context);
      _state.render(() {
        _state.selectedIndex = [];
      });
      MyDialog.info(
          title: "Journal Deleted",
          context: _state.context,
          content: "Journal successfully deleted");
    } catch (e) {
      MyDialog.info(
          title: "Error Deleting Journal",
          context: _state.context,
          content: e.toString());
      MyDialog.circularProgressEnd(_state.context);
      return;
    }
  }
}
