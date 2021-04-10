import 'package:SDD_Project/controller/firebasecontroller.dart';
import 'package:SDD_Project/model/prescription.dart';
import 'package:SDD_Project/screens/views/mydialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'editprescription_screen.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

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
  bool active;
  List<PendingNotificationRequest> pendingNotifications;
  Icon notification;

  void render(fn) => setState(fn);

 Future<void> scheduleNotification() async {
    var expirationTime = prescription.expiration.add(Duration(days: -5));
    var reorderTime = prescription.reorderDate.add(Duration(days: -5));
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'channel id',
      'channel name',
      'channel description',
      styleInformation: BigTextStyleInformation(''),
      icon: '@mipmap/ic_launcher',
      largeIcon: DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
    );
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics, iOS: iOSPlatformChannelSpecifics);
    //Expiration Notification
    await flutterLocalNotificationsPlugin.schedule(
        (prescription.expiration.millisecondsSinceEpoch / 1000).floor(),
        'Notification for ${prescription.drugName}',
        'Remember your prescription is expiring on ${prescription.expiration.month}/${prescription.expiration.day}/${prescription.expiration.year}',
        expirationTime,
        platformChannelSpecifics);
    // Reorder Notification
    await flutterLocalNotificationsPlugin.schedule(
        (prescription.reorderDate.millisecondsSinceEpoch / 1000).floor(),
        'Notification for ${prescription.drugName}',
        'Remember to reorder your prescription by ${prescription.reorderDate.month}/${prescription.reorderDate.day}/${prescription.reorderDate.year}',
        reorderTime,
        platformChannelSpecifics);

  }

  @override
  void initState() {
    super.initState();
    con = _Controller(this);
    var initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    var initialIOSSettings = new IOSInitializationSettings();
    var initSettings = InitializationSettings(
      android: initializationSettingsAndroid, 
      iOS: initialIOSSettings,
    );

    flutterLocalNotificationsPlugin.initialize(initSettings);
    getNotifications();
  }

  void getNotifications() async{
    pendingNotifications = await flutterLocalNotificationsPlugin.pendingNotificationRequests();

    active = false;
    for(var x in pendingNotifications){
      if(x.id == (prescription.expiration.millisecondsSinceEpoch / 1000).floor() || x.id == (prescription.reorderDate.millisecondsSinceEpoch / 1000).floor()){
        active = true;
      }
    }

    if(pendingNotifications != null && active){
      setState((){
        notification = Icon(Icons.notifications_active);
      });
    }else{
      setState((){
        notification = Icon(Icons.notifications_none);
      });
    }
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
          IconButton(
            icon: notification != null ? notification: Icon(Icons.ac_unit),
            onPressed: con.setNotificaiton,
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

  void setNotificaiton() async{

    try{
      if(!_state.active){
        _state.scheduleNotification();
          MyDialog.info(
            context: _state.context,
            title: 'Success',
            content: 'Notification set for ${_state.prescription.expiration.month}/${_state.prescription.expiration.day - 5}/${_state.prescription.expiration.year}',
          );
        _state.render((){
          _state.active = true;
          _state.notification = Icon(Icons.notifications_active);
        });
      }else{
        await flutterLocalNotificationsPlugin.cancel((_state.prescription.expiration.millisecondsSinceEpoch / 1000).floor());
        await flutterLocalNotificationsPlugin.cancel((_state.prescription.reorderDate.millisecondsSinceEpoch / 1000).floor());
        MyDialog.info(
          context: _state.context,
          title: 'Success',
          content: 'Notification for ${_state.prescription.expiration.month}/${_state.prescription.expiration.day - 5}/${_state.prescription.expiration.year} cancelled',
        );
        _state.render((){
          _state.active = false;
          _state.notification = Icon(Icons.notifications_none);
        });
      }
    }catch(e){
        MyDialog.info(
          context: _state.context,
          title: 'Error Setting Notification',
          content: e.toString(),
        );
    }

  }

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