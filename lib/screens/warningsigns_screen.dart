import 'package:SDD_Project/controller/firebasecontroller.dart';
import 'package:SDD_Project/model/warningSign.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'views/mydialog.dart';

class WarningSigns extends StatefulWidget{

  static const routeName = '/signIn/homeScreen/warningSignScreen/';

  @override
  State<StatefulWidget> createState() {
    return _WarningSignState();
  }
}

class _WarningSignState extends State<WarningSigns>{

  _Controller con;
  List<WarningSign> signs;
  FirebaseUser user;
  int selectedIndex = -1;
  int rank = 1;
  var formKey = GlobalKey<FormState>();

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
    signs ??= arg['signs'];

    return Scaffold(
      appBar: AppBar(
        title: Text("Warning Signs"),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: selectedIndex != -1 ? popupUpdateForm : null,
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: selectedIndex != -1 ? con.deleteWarning : null,
          ),
        ],
      ),
      body: signs.length == 0
      ? Text(
        "No Warning Signs Set",
        style: TextStyle(fontSize: 30),
      )
      : ListView.builder(
        itemCount: signs.length,
        itemBuilder:  (BuildContext context, int index) => Card(
          elevation: 6,
            child: Container(
              color: selectedIndex == index ? Colors.blue[200] : Colors.white,
              child: ListTile(
                onTap: () => render((){
                  selectedIndex = -1;
                }),
                onLongPress: () => render((){
                  selectedIndex = index;
                }),
                title: Text(signs[index].description),
                trailing: Text(signs[index].rank.toString()),
              ),
            ),
        )
        ),

      floatingActionButton: FloatingActionButton(
        onPressed: () => popupForm(),
        child: Icon(Icons.add),
      ),
    );
  }

  popupUpdateForm() {
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState){
              return Form(
                key: formKey,
                child: Container(
                  height: MediaQuery.of(context).size.height * .6,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Add Warning Sign",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          decoration: InputDecoration(
                            hintText: "Description",
                          ),
                          initialValue: signs[selectedIndex].description,
                          validator: con.validateDescription,
                          onSaved: con.saveUpdateDescription,
                          maxLines: 5,
                          autocorrect: true,
                        ),
                        SizedBox(height: 20),
                        Text(
                          "Rank",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                        Row(
                          children: [
                            Text(
                                  '1',
                                  style: new TextStyle(fontSize: 16.0),
                                ),
                            Radio(
                                  value: 1, 
                                  groupValue: signs[selectedIndex].rank, 
                                  onChanged: (int value) { 
                                    setState(() {
                                      signs[selectedIndex].rank = value;
                                    });
                                  },
                                ),
                              Text(
                                  '2',
                                  style: new TextStyle(fontSize: 16.0),
                                ),
                            Radio(
                                  value: 2, 
                                  groupValue: signs[selectedIndex].rank, 
                                  onChanged: (int value) { 
                                    setState(() {
                                      signs[selectedIndex].rank = value;
                                    });
                                  },
                                ),
                          ],
                        ),
                        SizedBox(height: 30),
                        ElevatedButton(
                          onPressed: con.editWarning, 
                          child: Text('Submit'),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  popupForm() {
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState){
              return Form(
                key: formKey,
                child: Container(
                  height: MediaQuery.of(context).size.height * .6,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Add Warning Sign",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          decoration: InputDecoration(
                            hintText: "Description",
                          ),
                          validator: con.validateDescription,
                          onSaved: con.saveDescription,
                          maxLines: 5,
                          autocorrect: true,
                        ),
                        SizedBox(height: 20),
                        Text(
                          "Rank",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                        Row(
                          children: [
                            Text(
                                  '1',
                                  style: new TextStyle(fontSize: 16.0),
                                ),
                            Radio(
                                  value: 1, 
                                  groupValue: rank, 
                                  onChanged: (int value) { 
                                    setState(() {
                                      rank = value;
                                    });
                                  },
                                ),
                              Text(
                                  '2',
                                  style: new TextStyle(fontSize: 16.0),
                                ),
                            Radio(
                                  value: 2, 
                                  groupValue: rank, 
                                  onChanged: (int value) { 
                                    setState(() {
                                      rank = value;
                                    });
                                  },
                                ),
                          ],
                        ),
                        SizedBox(height: 30),
                        ElevatedButton(
                          onPressed: con.save, 
                          child: Text('Submit'),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class _Controller{
  _WarningSignState _state;
  _Controller(this._state);

  String description;
  int rank;

  void editWarning() async{
    if (!_state.formKey.currentState.validate()) {
      return;
    }
    _state.formKey.currentState.save();
    MyDialog.circularProgressStart(_state.context);

    try{
      await FirebaseController.updateWarningSign(_state.signs[_state.selectedIndex]);
      _state.render((){
        _state.selectedIndex = -1;
      });
      Navigator.of(_state.context).pop('dialog');
      MyDialog.circularProgressEnd(_state.context);
    }catch(e){
      MyDialog.circularProgressEnd(_state.context);
      MyDialog.info(
        title: "Edit Warning Sign Error",
        context: _state.context,
        content: e.toString()
      );
    }
    
  }

  void deleteWarning() async{
    try{
      await FirebaseController.deleteWarningSign(_state.signs[_state.selectedIndex].docId);
        MyDialog.info(
          title: "Success",
          context: _state.context,
          content: "The warning sign was successfully deleted!",
        );
      _state.render((){
        _state.signs.removeAt(_state.selectedIndex);
        _state.selectedIndex = -1;
      });
    }catch(e){
        MyDialog.info(
          title: "Deletion Error",
          context: _state.context,
          content: e.toString()
        );
    }
  }

  void save() async{
    if (!_state.formKey.currentState.validate()) {
      return;
    }
    _state.formKey.currentState.save();
    MyDialog.circularProgressStart(_state.context);

    try{
      var w = WarningSign(
        createdBy: _state.user.uid,
        description: description,
        rank: _state.rank
      );

      w.docId = await FirebaseController.addWarningSign(w);
      _state.signs.add(w);
      Navigator.of(_state.context).pop('dialog');
      MyDialog.circularProgressEnd(_state.context);

    }catch(e){
      MyDialog.circularProgressEnd(_state.context);
      MyDialog.info(
          title: "Warning Sign Add Error",
          context: _state.context,
          content: e.toString());
    }
    _state.render((){});
  }

  String validateDescription(String value){
    if(value == null || value.trim().length < 10){
      return 'Value must be at least 10 characters';
    }
    return null;
  }

  void saveDescription(String value){
    this.description = value.trim();
  }

  void saveUpdateDescription(String value){
    _state.signs[_state.selectedIndex].description = value;
  }

}