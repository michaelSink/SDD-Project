import 'package:SDD_Project/controller/firebasecontroller.dart';
import 'package:SDD_Project/model/hotline.dart';
import 'package:SDD_Project/screens/views/mydialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddHotline extends StatefulWidget{

  static const routeName = '/signIn/homeScreen/hotlineScreen/hotlineAddScreen';

  @override
  State<StatefulWidget> createState() {
    return _AddHotlineState();
  }
}

class _AddHotlineState extends State<AddHotline>{
  
  List<Hotline> hotlines;
  FirebaseUser user;
  _Controller con;
  var formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    con = _Controller(this);
  }

  @override
  Widget build(BuildContext context) {

    Map arg = ModalRoute.of(context).settings.arguments;
    hotlines ??= arg['hotlines'];
    user ??= arg['user'];

    return Scaffold(
      appBar: AppBar(
        title: Text('Add Hotline'),
      ),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Name',
                ),
                autocorrect: false,
                validator: con.validatorName,
                onSaved: con.onSavedName,
              ),
              Divider(height: 8.0,),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Purpose',
                ),
                autocorrect: false,
                validator: con.validatorPurpose,
                onSaved: con.onSavedPurpose,
              ),
              Divider(height: 8.0,),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Description',
                ),
                autocorrect: false,
                validator: con.validatorDescription,
                onSaved: con.onSavedDescription,
              ),
              Divider(height: 8.0,),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Availability',
                ),
                autocorrect: false,
                validator: con.validatorAvailability,
                onSaved: con.onSavedAvailability,
              ),
              Divider(height: 8.0,),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Phone Number',
                ),
                autocorrect: false,
                validator: con.validatorPhoneNumber,
                onSaved: con.onSavedPhoneNumber,
              ),
              Divider(height: 8.0,),
              RaisedButton(
                child: Text('Submit'),
                onPressed: con.save,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Controller{
  _AddHotlineState _state;
  _Controller(this._state);

  String name;
  String purpose;
  String description;
  String availability;
  String phoneNumber;

void save() async {

      if (!_state.formKey.currentState.validate()) {
        return;
      }

      _state.formKey.currentState.save();

      try{
        
        MyDialog.circularProgressStart(_state.context);

        Hotline h = new Hotline(
          name: name,
          purpose: purpose,
          description: description,
          availability: availability,
          phoneNumber: phoneNumber,
          createdBy: _state.user.uid,
        );

        h.docId = await FirebaseController.addHotline(h);
        _state.hotlines.insert(0, h);

        MyDialog.circularProgressEnd(_state.context);
        Navigator.pop(_state.context);

      }catch(e){

        MyDialog.circularProgressEnd(_state.context);
        MyDialog.info(
          context: _state.context,
          title: 'Error uploading perscription.',
          content: e.message ?? e.toString(),
        );

      }

  }

  RegExp phopeExp = new RegExp("[0-9]{3}[-][0-9]{3}[-][0-9]{4}");

  //Saving methods
  void onSavedName(String value){
    this.name = value;
  }

  void onSavedPurpose(String value){
    this.purpose = value;
  }

  void onSavedDescription(String value){
    this.description = value;
  }

  void onSavedAvailability(String value){
    this.availability = value;
  }

  void onSavedPhoneNumber(String value){
    this.phoneNumber = value;
  }

  //Validator methods
  String validatorName(String value){
    if(value == null || value.trim().length < 5){
      return "Name must be at least 5 characters";
    }
    return null;
  }

  String validatorPurpose(String value){
    if(value == null || value.trim().length < 4){
      return "Purpose must be at least 4 characters";
    }
    return null;
  }

  String validatorDescription(String value){
    if(value == null || value.trim().length < 10){
      return "Description must be at least 10 characters";
    }
    return null;
  }

  String validatorAvailability(String value){
    if(value == null || value.trim().length < 4){
      return "Availability must be at least 4 characters";
    }
    return null;
  }

  String validatorPhoneNumber(String value){
    if(value == null || value.trim().length != 12 || !phopeExp.hasMatch(value.trim())){

      return 'Invalid Phone Number';

    }

    return null;
  }

}