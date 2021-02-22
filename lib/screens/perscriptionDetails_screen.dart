import 'package:SDD_Project/model/perscription.dart';
import 'package:flutter/material.dart';

class PerscriptionDetails extends StatefulWidget{

  static const routeName = 'signIn/homeScreen/perscriptionsScreen/perscription/';

  @override
  State<StatefulWidget> createState() {
    return _PerscriptionDetailsState();
  }

}

class _PerscriptionDetailsState extends State<PerscriptionDetails>{

  Perscription perscription;

  @override
  Widget build(BuildContext context) {

  Map arg = ModalRoute.of(context).settings.arguments;
    perscription ??= arg['perscription'];

    return Scaffold(
      appBar: AppBar(
        title: Text('Perscription'),
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
              Text('Pharmacy Name: ${perscription.pharmacyName}'),
              SizedBox(height: 10.0,),
              Text('Pharmacy Address: ${perscription.pharmacyAddress}'),
              SizedBox(height: 10.0,),
              Text('Pharmacy Number: ${perscription.pharmacyNumber}'),
              SizedBox(height: 10.0,),
              Text('Perscription Number: ${perscription.perscriptionNumber}'),
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
              Text('Drug Name: ${perscription.drugName}'),
              SizedBox(height: 10.0,),
              Text('Drug Strength: ${perscription.drugStrength}mg'),
              SizedBox(height: 10.0,),
              Text('Drug Instructions: ${perscription.drugInstructions}'),
              SizedBox(height: 10.0,),
              Text('Drug Description: ${perscription.drugDescription}'),
              SizedBox(height: 10.0,),
              Text(
                'Perscription Information',
                style: TextStyle(fontSize: 26.0, fontWeight: FontWeight.bold),
              ),
              Divider(
                color: Colors.grey,
                height: 15,
                thickness: 2,
              ),
              SizedBox(height: 10.0,),
              Text('Perscriber: ${perscription.perscriber}'),
              SizedBox(height: 10.0,),
              Text('Pill Count: ${perscription.pillCount}'),
              SizedBox(height: 10.0,),
              Text('Refill Amount: ${perscription.refillAmount}'),
              SizedBox(height: 10.0,),
              Text('Pill Count: ${perscription.pillCount}'),
              SizedBox(height: 10.0,),
              Text('Perscribed On: ${perscription.perscribedOn.day}/${perscription.perscribedOn.month}/${perscription.perscribedOn.year}'),
              SizedBox(height: 10.0,),
              Text('Filled On: ${perscription.filledDate.day}/${perscription.filledDate.month}/${perscription.filledDate.year}'),
              SizedBox(height: 10.0,),
              Text('Reorder Date: ${perscription.reorderDate.day}/${perscription.reorderDate.month}/${perscription.reorderDate.year}'),
              SizedBox(height: 10.0,),
              Text('Expiration Date: ${perscription.expiration.day}/${perscription.expiration.month}/${perscription.expiration.year}'),
            ],
      ),
      ),
    );
  }

}