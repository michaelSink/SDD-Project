import 'package:SDD_Project/controller/firebasecontroller.dart';
import 'package:SDD_Project/model/perscription.dart';
import 'package:SDD_Project/screens/views/mydialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddPerscriptionScreen extends StatefulWidget{

  static const routeName = 'signIn/homeScreen/perscriptionScreen/addPerscription/';

  @override
  State<StatefulWidget> createState() {
    return _AddPerscriptionState();
  }

}

class _AddPerscriptionState extends State<AddPerscriptionScreen>{

  _Controller con;
  FirebaseUser user;
  List<Perscription> perscriptions;
  var formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    con = _Controller(this);
  }

  @override
  Widget build(BuildContext context) {

    Map arg = ModalRoute.of(context).settings.arguments;
    user ??= arg['user'];
    perscriptions ??= arg['perscriptions'];

    return Scaffold(
      appBar: AppBar(
        title: Text('Add Perscription'),
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: con.save,
          ),
        ],
      ),
      body: Form(

        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                'Pharmacy Information', 
                style: TextStyle(fontSize: 26.0, fontWeight: FontWeight.bold),
              ),
              Divider(
                color: Colors.grey,
                height: 15,
                thickness: 2,
              ),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Pharmacy Name',
                ),
                autocorrect: false,
                validator: con.validatorPharmacyName,
                onSaved: con.onSavedPharmacyName,
              ),
              SizedBox(height: 10.0,),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Pharmacy Address',
                ),
                autocorrect: false,
                validator: con.validatorPharmacyAddress,
                onSaved: con.onSavedPharmacyAddress,
              ),
              SizedBox(height: 10.0,),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Pharmacy Number e.g. 123-456-7777',
                ),
                autocorrect: false,
                validator: con.validatorPharmacyNumber,
                onSaved: con.onSavedPharmacyNumber,
              ),
              SizedBox(height: 10.0,),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Perscription Number',
                ),
                autocorrect: false,
                validator: con.validatorPerscriptionNumber,
                onSaved: con.onSavedPerscriptionNumber,
              ),
              SizedBox(height: 30.0),
              Text(
                'Drug Information', 
                style: TextStyle(fontSize: 26.0, fontWeight: FontWeight.bold),
              ),
              Divider(
                color: Colors.grey,
                height: 15,
                thickness: 2,
              ),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Drug Name',
                ),
                autocorrect: false,
                validator: con.validatorDrugName,
                onSaved: con.onSavedDrugName,
              ),
              SizedBox(height: 10.0,),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Drug Strength',
                  suffix: Text('mg'),
                ),
                autocorrect: false,
                validator: con.validatorDrugStrength,
                onSaved: con.onSavedDrugStrength,
              ),
              SizedBox(height: 10.0,),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Drug Instructions',
                ),
                autocorrect: false,
                validator: con.validatorDrugInstructions,
                onSaved: con.onSavedDrugInstructions,
              ),
              SizedBox(height: 10.0,),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Drug Description',
                ),
                autocorrect: false,
                validator: con.validatorDrugDescription,
                onSaved: con.onSavedDrugDescription,
              ),
              SizedBox(height: 30.0,),
              Text(
                'Perscription Information', 
                style: TextStyle(fontSize: 26.0, fontWeight: FontWeight.bold),
              ),
              Divider(
                color: Colors.grey,
                height: 15,
                thickness: 2,
              ),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Pill Count',
                ),
                autocorrect: false,
                validator: con.validatorPillCount,
                onSaved: con.onSavedPillCount,
              ),
              SizedBox(height: 10.0,),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Reorder Date e.g. YYYY-MM-DD',
                  suffix: Text('YYYY-MM-DD'),
                ),
                autocorrect: false,
                validator: con.validatorDateAfterToday,
                onSaved: con.onSavedReorderDate,
              ),
              SizedBox(height: 10.0,),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Refill Amount',
                ),
                autocorrect: false,
                validator: con.validatorRefillAmount,
                onSaved: con.onSavedRefillAmount,
              ),
              SizedBox(height: 10.0,),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Perscriber',
                ),
                autocorrect: false,
                validator: con.validatorPerscriber,
                onSaved: con.onSavedPerscriber,
              ),
              SizedBox(height: 10.0,),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Filled Date e.g. YYYY-MM-DD',
                  suffix: Text('YYYY-MM-DD'),
                ),
                autocorrect: false,
                validator: con.validatorDateBeforeToday,
                onSaved: con.onSavedFilledDate,
              ),
              SizedBox(height: 10.0,),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Expiration Date e.g. YYYY-MM-DD',
                  suffix: Text('YYYY-MM-DD'),
                ),
                autocorrect: false,
                validator: con.validatorDateAfterToday,
                onSaved: con.onSavedExpiration,
              ),
              SizedBox(height: 10.0,),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Perscribed On e.g. YYYY-MM-DD',
                  suffix: Text('YYYY-MM-DD'),
                ),
                autocorrect: false,
                validator: con.validatorDateBeforeToday,
                onSaved: con.onSavedPerscribedOn,
              ),
            ],
          ),
        ),

      ),
    );
  }

}

class _Controller{

  _AddPerscriptionState _state;
  _Controller(this._state);

  String pharmacyName;
  String pharmacyAddress;
  String pharmacyNumber;
  String perscriptionNumber;

  String drugName;
  String drugStrength;
  String drugInstructions;
  String drugDescription;

  int pillCount;
  DateTime reorderDate;
  int refillAmount;
  String perscriber;
  DateTime filledDate;
  DateTime expiration;
  DateTime perscribedOn;

  void save() async {

      if (!_state.formKey.currentState.validate()) {
        return;
      }

      _state.formKey.currentState.save();

      try{
        
        MyDialog.circularProgressStart(_state.context);

        Perscription p = Perscription(
          createdBy: _state.user.uid,
          pharmacyName: pharmacyName,
          pharmacyAddress: pharmacyAddress,
          pharmacyNumber: pharmacyNumber,
          perscriptionNumber: perscriptionNumber,
          drugName: drugName,
          drugStrength: drugStrength,
          drugInstructions: drugInstructions,
          drugDescription: drugDescription,
          pillCount: pillCount,
          reorderDate: reorderDate,
          refillAmount: refillAmount,
          perscriber: perscriber,
          filledDate: filledDate,
          expiration: expiration,
          perscribedOn: perscribedOn,
        );

        p.docId = await FirebaseController.addPerscription(p);
        _state.perscriptions.insert(0, p);

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

  //Saving methods
  //Pharmacy saving
  void onSavedPharmacyName(String value){
    pharmacyName = value.trim();
  }

  void onSavedPharmacyAddress(String value){
    pharmacyAddress = value.trim();
  }

  void onSavedPharmacyNumber(String value){
    pharmacyNumber = value.trim();
  }

  void onSavedPerscriptionNumber(String value){
    perscriptionNumber = value.trim();
  }
  
  //Drug saving
  void onSavedDrugName(String value){
    drugName = value.trim();
  }

  void onSavedDrugStrength(String value){
    drugStrength = value.trim();
  }

  void onSavedDrugInstructions(String value){
    drugInstructions = value.trim();
  }

  void onSavedDrugDescription(String value){
    drugDescription = value.trim();
  }

  //Perscription saving
  void onSavedPillCount(String value){
    pillCount = int.parse(value);
  }

  void onSavedReorderDate(String value){
    reorderDate = DateTime.parse(value.trim());
  }

  void onSavedRefillAmount(String value){
    refillAmount = int.parse(value);
  }

  void onSavedPerscriber(String value){
    perscriber = value.trim();
  }

  void onSavedFilledDate(String value){
    filledDate = DateTime.parse(value.trim());
  }

  void onSavedExpiration(String value){
    expiration = DateTime.parse(value.trim());
  }

  void onSavedPerscribedOn(String value){
    perscribedOn = DateTime.parse(value.trim());
  }

  //Date validation
  RegExp dateExp = new RegExp("[0-9]{4}[-][0-9]{2}[-][0-9]{2}");
  RegExp phopeExp = new RegExp("[0-9]{3}[-][0-9]{3}[-][0-9]{4}");

  String validatorDate(String value){

    if(value == null || value.trim().length != 10 || !dateExp.hasMatch(value.trim())){

      return 'Invalid Date';

    }

    return null;

  }

  String validatorDateAfterToday(String value){

    String dateValidation = validatorDate(value);
    if(dateValidation != null){

      return dateValidation;

    }else if(!DateTime.parse(value.trim()).isAfter(DateTime.now())){

      return 'Date Is Not After Today';

    }

    return null;

  }

  String validatorDateBeforeToday(String value){

    String dateValidation = validatorDate(value);
    if(dateValidation != null){

      return dateValidation;

    }else if(DateTime.parse(value.trim()).isAfter(DateTime.now())){

      return 'Date Is Not Before Today, or Today';

    }

    return null;

  }

  //Pharmacy Validators
  String validatorPharmacyName(String value){

    if(value == null || value.trim().length < 3){

      return 'Minimum 3 Characters';

    }

    return null;

  }

  String validatorPharmacyAddress(String value){

    if(value == null || value.trim().length < 8){

      return 'Invalid Pharmacy Address';

    }

    return null;

  }

  String validatorPharmacyNumber(String value){

    if(value == null || value.trim().length != 12 || !phopeExp.hasMatch(value.trim())){

      return 'Invalid Phone Number';

    }

    return null;

  }

  String validatorPerscriptionNumber(String value){

    if(value == null || value.trim().length < 4){

      return 'Invalid Perscription Number';
    
    }

    int hyphenCount = 0;
    for(int i = 0; i < value.trim().length; i++){

      if(value[i] == '-'){
        hyphenCount++;
      }else{
        try{
          int.parse(value[i]);
        }catch(e){
          return 'Perscription Number Must Contain Only Numbers and/or Hyphens';
        }

      }

    }

    if(hyphenCount > 3){

      return 'Perscription Number Can Only Have at Most 3 Hyphens';

    }

    return null;

  }

  //Drug validators
  String validatorDrugName(String value){

    if(value == null || value.trim().length < 5){

      return 'Invalid Drug Name';

    }

    return null;

  }

  String validatorDrugStrength(String value){

    if(value == null || value.trim().length < 1 || value.trim().length > 4){

      return 'Invalid Drug Strength';

    }

    try{

      int.parse(value);

    }catch(e){

      return 'Invalid Drug Strength';

    }

    return null;

  }

  String validatorDrugInstructions(String value){

    if(value == null || value.trim().length < 7){

      return 'Invalid Drug Instructions';

    }

    return null;

  }

  String validatorDrugDescription(String value){

    if(value == null || value.trim().length < 10){

      return 'Invalid Drug Description';

    }

    return null;

  }

  //Perscription Validators
  String validatorPillCount(String value){

    if(value == null || value.trim().length < 1 || value.trim().length > 4){

      return 'Invalid Pill Count';

    }

    try{

      int.parse(value);

    }catch(e){

      return 'Invalid Pill Count';

    }

    return null;

  }

  String validatorRefillAmount(String value){

    if(value == null || value.trim().length < 1 || value.trim().length > 2){

      return 'Invalid Refill Amount';

    }

    try{
      int.parse(value.trim());
    }catch(e){
      return 'Invalid Refill Amount';
    }

    return null;

  }

  String validatorPerscriber(String value){

    if(value == null || value.trim().length < 6){

      return 'Invalid Perscriber';

    }

    return null;

  }

}