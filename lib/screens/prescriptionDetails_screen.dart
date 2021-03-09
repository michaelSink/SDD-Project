import 'package:SDD_Project/controller/firebasecontroller.dart';
import 'package:SDD_Project/model/prescription.dart';
import 'package:flutter/material.dart';

import 'editprescription_screen.dart';

class PrescriptionDetails extends StatefulWidget{

  static const routeName = 'signIn/homeScreen/prescriptionssScreen/prescriptions/';

  @override
  State<StatefulWidget> createState() {
    return _PrescriptionDetailsState();
  }

}

class _PrescriptionDetailsState extends State<PrescriptionDetails>{

  Prescription prescription;
  _Controller con;

  void render(fn) => setState(fn);

  @override
  void initState() {
    super.initState();
    con = _Controller(this);
  }

  @override
  Widget build(BuildContext context) {

  Map arg = ModalRoute.of(context).settings.arguments;
    prescription ??= arg['prescription'];

    return Scaffold(
      appBar: AppBar(
        title: Text('Prescription'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: con.editPrescription,
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: con.deletePrescription,
          ),
        ],
      ),
      body: Card(
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
              Text('Pharmacy Name: ${prescription.pharmacyName}'),
              SizedBox(height: 10.0,),
              Text('Pharmacy Address: ${prescription.pharmacyAddress}'),
              SizedBox(height: 10.0,),
              Text('Pharmacy Number: ${prescription.pharmacyNumber}'),
              SizedBox(height: 10.0,),
              Text('Prescription Number: ${prescription.prescriptionNumber}'),
              SizedBox(height: 10.0,),
              Text(
                'Drug Information',
                style: TextStyle(fontSize: 26.0, fontWeight: FontWeight.bold),
              ),
              Divider(
                color: Colors.grey,
                height: 15,
                thickness: 2,
              ),
              SizedBox(height: 10.0,),
              Text('Drug Name: ${prescription.drugName}'),
              SizedBox(height: 10.0,),
              Text('Drug Strength: ${prescription.drugStrength}mg'),
              SizedBox(height: 10.0,),
              Text('Drug Instructions: ${prescription.drugInstructions}'),
              SizedBox(height: 10.0,),
              Text('Drug Description: ${prescription.drugDescription}'),
              SizedBox(height: 10.0,),
              Text(
                'Prescription Information',
                style: TextStyle(fontSize: 26.0, fontWeight: FontWeight.bold),
              ),
              Divider(
                color: Colors.grey,
                height: 15,
                thickness: 2,
              ),
              SizedBox(height: 10.0,),
              Text('Prescriber: ${prescription.prescriber}'),
              SizedBox(height: 10.0,),
              Text('Pill Count: ${prescription.pillCount}'),
              SizedBox(height: 10.0,),
              Text('Refill Amount: ${prescription.refillAmount}'),
              SizedBox(height: 10.0,),
              Text('Pill Count: ${prescription.pillCount}'),
              SizedBox(height: 10.0,),
              Text('Prescribed On: ${prescription.prescribedOn.day}/${prescription.prescribedOn.month}/${prescription.prescribedOn.year}'),
              SizedBox(height: 10.0,),
              Text('Filled On: ${prescription.filledDate.day}/${prescription.filledDate.month}/${prescription.filledDate.year}'),
              SizedBox(height: 10.0,),
              Text('Reorder Date: ${prescription.reorderDate.day}/${prescription.reorderDate.month}/${prescription.reorderDate.year}'),
              SizedBox(height: 10.0,),
              Text('Expiration Date: ${prescription.expiration.day}/${prescription.expiration.month}/${prescription.expiration.year}'),
            ],
      ),
      ),
    );
  }

}

class _Controller{

  _PrescriptionDetailsState _state;
  _Controller(this._state);

  void deletePrescription() async{
    await FirebaseController.deletePrescription(_state.prescription.docId);
    Navigator.pop(_state.context);
  }

  void editPrescription() async{
    await Navigator.pushNamed(_state.context, EditPrescription.routeName,
          arguments: {'prescription' : _state.prescription});
    _state.render((){});
  }

}