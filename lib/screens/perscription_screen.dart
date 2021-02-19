import 'package:SDD_Project/model/perscription.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'addperscription_screen.dart';

class PerscriptionScreen extends StatefulWidget{

  static const routeName = '/signIn/homeScreen/perscriptionScreen/';

  @override
  State<StatefulWidget> createState() {
    return _PerscriptionState();
  }

}

class _PerscriptionState extends State<PerscriptionScreen>{

  FirebaseUser user;
  List<Perscription> perscriptions;
  _Controller con;

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
    perscriptions ??= arg['perscriptions'];

    return Scaffold(
      appBar: AppBar(
        title: Text('Perscriptions'),
      ),
      body: perscriptions.length == 0
        ? Text(
            'No Perscriptions',
            style: TextStyle(fontSize: 30.0),
          )
        : ListView.builder(
            itemCount: perscriptions.length,
            itemBuilder: (BuildContext context, int index) => Container(
              padding: EdgeInsets.all(8.0),
              child: Card(
                elevation: 8.0,
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
                      Text('Pharmacy Name: ${perscriptions[index].pharmacyName}'),
                      SizedBox(height: 10.0,),
                      Text('Pharmacy Address: ${perscriptions[index].pharmacyAddress}'),
                      SizedBox(height: 10.0,),
                      Text('Pharmacy Number: ${perscriptions[index].pharmacyNumber}'),
                      SizedBox(height: 10.0,),
                      Text('Perscription Number: ${perscriptions[index].perscriptionNumber}'),
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
                      Text('Drug Name: ${perscriptions[index].drugName}'),
                      SizedBox(height: 10.0,),
                      Text('Drug Strength: ${perscriptions[index].drugStrength}mg'),
                      SizedBox(height: 10.0,),
                      Text('Drug Instructions: ${perscriptions[index].drugInstructions}'),
                      SizedBox(height: 10.0,),
                      Text('Drug Description: ${perscriptions[index].drugDescription}'),
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
                      Text('Perscriber: ${perscriptions[index].perscriber}'),
                      SizedBox(height: 10.0,),
                      Text('Pill Count: ${perscriptions[index].pillCount}'),
                      SizedBox(height: 10.0,),
                      Text('Refill Amount: ${perscriptions[index].refillAmount}'),
                      SizedBox(height: 10.0,),
                      Text('Pill Count: ${perscriptions[index].pillCount}'),
                      SizedBox(height: 10.0,),
                      Text('Perscribed On: ${perscriptions[index].perscribedOn.day}/${perscriptions[index].perscribedOn.month}/${perscriptions[index].perscribedOn.year}'),
                      SizedBox(height: 10.0,),
                      Text('Filled On: ${perscriptions[index].filledDate.day}/${perscriptions[index].filledDate.month}/${perscriptions[index].filledDate.year}'),
                      SizedBox(height: 10.0,),
                      Text('Reorder Date: ${perscriptions[index].reorderDate.day}/${perscriptions[index].reorderDate.month}/${perscriptions[index].reorderDate.year}'),
                      SizedBox(height: 10.0,),
                      Text('Expiration Date: ${perscriptions[index].expiration.day}/${perscriptions[index].expiration.month}/${perscriptions[index].expiration.year}'),
                    ],
                ),
              ),
            ),
          ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: con.addScreen,
      ),
    );
  }

}

class _Controller{

  _PerscriptionState _state;
  _Controller(this._state);

  void addScreen() async{

    await Navigator.pushNamed(_state.context, AddPerscriptionScreen.routeName,
      arguments: {'user' : _state.user, 'perscriptions': _state.perscriptions});
    _state.render((){});

  }

}