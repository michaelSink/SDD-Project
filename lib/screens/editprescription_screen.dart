import 'package:SDD_Project/controller/firebasecontroller.dart';
import 'package:SDD_Project/model/prescription.dart';
import 'package:SDD_Project/screens/views/mydialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EditPrescription extends StatefulWidget{

  static const routeName = 'signIn/homeScreen/prescriptionssScreen/prescriptions/editPrescription';

  @override
  State<StatefulWidget> createState() {
    return _EditPrescriptionState();
  }

}

class _EditPrescriptionState extends State<EditPrescription>{

 _Controller con;
  FirebaseUser user;
  Prescription prescription;
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
    prescription ??= arg['prescription'];

    return Scaffold(
      appBar: AppBar(
        title: Text('Add Prescription'),
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
                initialValue: prescription.pharmacyName,
                autocorrect: false,
                validator: con.validatorPharmacyName,
                onSaved: con.onSavedPharmacyName,
              ),
              SizedBox(height: 10.0,),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Pharmacy Address',
                ),
                initialValue: prescription.pharmacyAddress,
                autocorrect: false,
                validator: con.validatorPharmacyAddress,
                onSaved: con.onSavedPharmacyAddress,
              ),
              SizedBox(height: 10.0,),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Pharmacy Number e.g. 123-456-7777',
                ),
                initialValue: prescription.pharmacyNumber,
                autocorrect: false,
                validator: con.validatorPharmacyNumber,
                onSaved: con.onSavedPharmacyNumber,
              ),
              SizedBox(height: 10.0,),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Prescription Number',
                ),
                initialValue: prescription.prescriptionNumber,
                autocorrect: false,
                validator: con.validatorPrescriptionNumber,
                onSaved: con.onSavedPrescriptionNumber,
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
                initialValue: prescription.drugName,
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
                initialValue: prescription.drugStrength,
                autocorrect: false,
                validator: con.validatorDrugStrength,
                onSaved: con.onSavedDrugStrength,
              ),
              SizedBox(height: 10.0,),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Drug Instructions',
                ),
                initialValue: prescription.drugInstructions,
                autocorrect: false,
                validator: con.validatorDrugInstructions,
                onSaved: con.onSavedDrugInstructions,
              ),
              SizedBox(height: 10.0,),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Drug Description',
                ),
                initialValue: prescription.drugDescription,
                autocorrect: false,
                validator: con.validatorDrugDescription,
                onSaved: con.onSavedDrugDescription,
              ),
              SizedBox(height: 30.0,),
              Text(
                'Prescription Information', 
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
                initialValue: prescription.pillCount.toString(),
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
                initialValue: "${prescription.reorderDate.year.toString()}-${prescription.reorderDate.month.toString().padLeft(2, '0')}-${prescription.reorderDate.day.toString().padLeft(2,'0')}",
                autocorrect: false,
                validator: con.validatorDate,
                onSaved: con.onSavedReorderDate,
              ),
              SizedBox(height: 10.0,),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Refill Amount',
                ),
                initialValue: prescription.refillAmount.toString(),
                autocorrect: false,
                validator: con.validatorRefillAmount,
                onSaved: con.onSavedRefillAmount,
              ),
              SizedBox(height: 10.0,),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Prescriber',
                ),
                initialValue: prescription.prescriber,
                autocorrect: false,
                validator: con.validatorPrescriber,
                onSaved: con.onSavedPrescriber,
              ),
              SizedBox(height: 10.0,),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Filled Date e.g. YYYY-MM-DD',
                  suffix: Text('YYYY-MM-DD'),
                ),
                initialValue: "${prescription.filledDate.year.toString()}-${prescription.filledDate.month.toString().padLeft(2, '0')}-${prescription.filledDate.day.toString().padLeft(2,'0')}",
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
                initialValue: "${prescription.expiration.year.toString()}-${prescription.expiration.month.toString().padLeft(2, '0')}-${prescription.expiration.day.toString().padLeft(2,'0')}",
                autocorrect: false,
                validator: con.validatorDate,
                onSaved: con.onSavedExpiration,
              ),
              SizedBox(height: 10.0,),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Prescribed On e.g. YYYY-MM-DD',
                  suffix: Text('YYYY-MM-DD'),
                ),
                initialValue: "${prescription.prescribedOn.year.toString()}-${prescription.prescribedOn.month.toString().padLeft(2, '0')}-${prescription.prescribedOn.day.toString().padLeft(2,'0')}",
                autocorrect: false,
                validator: con.validatorDateBeforeToday,
                onSaved: con.onSavedPrescribedOn,
              ),
            ],
          ),
        ),

      ),
    );
  }

}

class _Controller{
  _EditPrescriptionState _state;
  _Controller(this._state);

  void save() async {

      if (!_state.formKey.currentState.validate()) {
        return;
      }

      _state.formKey.currentState.save();

      try{
        
        MyDialog.circularProgressStart(_state.context);
        await FirebaseController.updatePrescription(_state.prescription);
        MyDialog.circularProgressEnd(_state.context);
        Navigator.pop(_state.context);

      }catch(e){

        MyDialog.circularProgressEnd(_state.context);
        MyDialog.info(
          context: _state.context,
          title: 'Error uploading prescription.',
          content: e.message ?? e.toString(),
        );

      }

  }

  //Saving methods
  //Pharmacy saving
  void onSavedPharmacyName(String value){
    _state.prescription.pharmacyName = value.trim();
  }

  void onSavedPharmacyAddress(String value){
    _state.prescription.pharmacyAddress = value.trim();
  }

  void onSavedPharmacyNumber(String value){
    _state.prescription.pharmacyNumber = value.trim();
  }

  void onSavedPrescriptionNumber(String value){
    _state.prescription.prescriptionNumber = value.trim();
  }
  
  //Drug saving
  void onSavedDrugName(String value){
    _state.prescription.drugName = value.trim();
  }

  void onSavedDrugStrength(String value){
    _state.prescription.drugStrength = value.trim();
  }

  void onSavedDrugInstructions(String value){
    _state.prescription.drugInstructions = value.trim();
  }

  void onSavedDrugDescription(String value){
    _state.prescription.drugDescription = value.trim();
  }

  //Prescription saving
  void onSavedPillCount(String value){
    _state.prescription.pillCount = int.parse(value);
  }

  void onSavedReorderDate(String value){
    _state.prescription.reorderDate = DateTime.parse(value.trim());
  }

  void onSavedRefillAmount(String value){
    _state.prescription.refillAmount = int.parse(value);
  }

  void onSavedPrescriber(String value){
    _state.prescription.prescriber = value.trim();
  }

  void onSavedFilledDate(String value){
    _state.prescription.filledDate = DateTime.parse(value.trim());
  }

  void onSavedExpiration(String value){
    _state.prescription.expiration = DateTime.parse(value.trim());
  }

  void onSavedPrescribedOn(String value){
    _state.prescription.prescribedOn = DateTime.parse(value.trim());
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

  String validatorPrescriptionNumber(String value){

    if(value == null || value.trim().length < 4){

      return 'Invalid Prescription Number';
    
    }

    int hyphenCount = 0;
    for(int i = 0; i < value.trim().length; i++){

      if(value[i] == '-'){
        hyphenCount++;
      }else{
        try{
          int.parse(value[i]);
        }catch(e){
          return 'Prescription Number Must Contain Only Numbers and/or Hyphens';
        }

      }

    }

    if(hyphenCount > 3){

      return 'Prescription Number Can Only Have at Most 3 Hyphens';

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

  //Prescription Validators
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

  String validatorPrescriber(String value){

    if(value == null || value.trim().length < 6){

      return 'Invalid Prescriber';

    }

    return null;

  }

}