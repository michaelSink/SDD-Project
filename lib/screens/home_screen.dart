import 'package:SDD_Project/controller/firebasecontroller.dart';
import 'package:SDD_Project/model/contacts.dart';
import 'package:SDD_Project/model/journal.dart';
import 'package:SDD_Project/model/location.dart';
import 'package:SDD_Project/model/vault.dart';
import 'package:SDD_Project/screens/calender_screen.dart';
import 'package:SDD_Project/screens/contacts_screen.dart';
import 'package:SDD_Project/screens/feelgoodvault_screen.dart';
import 'package:SDD_Project/model/diagnosis.dart';
import 'package:SDD_Project/model/hotline.dart';
import 'package:SDD_Project/model/medicalHistory.dart';
import 'package:SDD_Project/screens/diagnosis_screen.dart';
import 'package:SDD_Project/screens/familyHistory_screen.dart';
import 'package:SDD_Project/screens/location_screen.dart';
import 'package:SDD_Project/screens/prescription_screen.dart';
import 'package:SDD_Project/screens/signin_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:SDD_Project/screens/hotline_screen.dart';
import 'package:SDD_Project/screens/views/myimageview.dart';
import '../controller/firebasecontroller.dart';
import 'aboutpage_screen.dart';
import 'journal_screen.dart';
import 'signin_screen.dart';
import 'views/mydialog.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = './signIn/homeScreen/';

  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<HomeScreen> {
  _Controller con;
  FirebaseUser user;

  @override
  void initState() {
    super.initState();
    con = _Controller(this);
  }

  @override
  Widget build(BuildContext context) {
    Map arg = ModalRoute.of(context).settings.arguments;
    user ??= arg['user'];

    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Home'),
        ),
        drawer: Drawer(
          child: ListView(
            children: [
              UserAccountsDrawerHeader(
                currentAccountPicture: ClipOval(
                    child: user.photoUrl != null
                        ? MyImageView.network(
                            imageUrl: user.photoUrl, context: context)
                        : Image.asset('static/images/default-user.png')),
                accountEmail: Text(user.email),
                accountName: Text(user.displayName ?? 'N/A'),
              ),
              ListTile(
                leading: Icon(Icons.exit_to_app),
                title: Text('Sign Out'),
                onTap: con.signOut,
              ),
              ListTile(
                leading: Icon(Icons.developer_board),
                title: Text('About page'),
                onTap: con.about,
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            Card(
              child: ListTile(
                leading: Icon(Icons.person),
                title: Text('Contacts'),
                onTap: con.accessContacts,
              ),
            ),
            Card(
              child: ListTile(
                leading: Icon(Icons.local_hospital),
                title: Text('Prescriptions'),
                onTap: con.prescriptionScreen,
              ),
            ),
            Card(
              child: ListTile(
                leading: Icon(Icons.phone),
                title: Text('Hotlines'),
                onTap: con.hotlineScreen,
              ),
            ),
            Card(
              child: ListTile(
                leading: Icon(Icons.history),
                title: Text('Diagnoses'),
                onTap: con.diagnosisScreen,
              ),
            ),
            Card(
              child: ListTile(
                leading: Icon(Icons.people),
                title: Text('Family History'),
                onTap: con.familyScreen,
              ),
            ),
            Card(
              child: ListTile(
                leading: Icon(Icons.wb_sunny),
                title: Text('Feel Good Vault'),
                onTap: con.accessVault,
              ),
            ),
            Card(
              child: ListTile(
                leading: Icon(Icons.book),
                title: Text('Journal'),
                onTap: con.journalScreen,
              ),
            ),
            Card(
              child: ListTile(
                leading: Icon(Icons.calendar_today_rounded),
                title: Text('Calender'),
                onTap: con.calender,
              ),
            ),
            Card(
              child: ListTile(
                leading: Icon(Icons.house),
                title: Text('Socail Settings'),
                onTap: con.locationScreen,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Controller {
  _HomeState _state;
  _Controller(this._state);

  void prescriptionScreen() async {
    try {
      //Get perscriptions
      List<dynamic> prescriptions =
          await FirebaseController.getPrescriptions(_state.user.uid);

      await Navigator.pushNamed(_state.context, PrescriptionScreen.routeName,
          arguments: {'user': _state.user, 'prescriptions': prescriptions});
    } catch (e) {
      MyDialog.info(
        context: _state.context,
        content: e.message ?? e.toString(),
        title: 'Error',
      );
    }
  }

  void locationScreen() async{
    try{

      List<Location> locations = await FirebaseController.getLocations(_state.user.uid);

      await Navigator.pushNamed(_state.context, LocationScreen.routeName,
                arguments: {'locations' : locations, 'user' : _state.user});
    }catch(e){
      MyDialog.info(
        title: 'Error',
        context: _state.context,
        content: e.toString()
      );
    }
  }

  void familyScreen() async {
    try {
      List<MedicalHistory> history =
          await FirebaseController.getFamilyHistory(_state.user.uid);
      await Navigator.pushNamed(_state.context, FamilyHistory.routeName,
          arguments: {'user': _state.user, 'history': history});
    } catch (e) {
      MyDialog.info(
        context: _state.context,
        content: e.message ?? e.toString(),
        title: 'Error',
      );
    }
  }

  void diagnosisScreen() async {
    try {
      List<Diagnosis> diagnoses =
          await FirebaseController.getDiagnoses(_state.user.uid);

      await Navigator.pushNamed(_state.context, DiagnosisScreen.routeName,
          arguments: {'user': _state.user, 'diagnoses': diagnoses});
    } catch (e) {
      MyDialog.info(
        context: _state.context,
        content: e.toString(),
        title: 'Error',
      );
    }
  }

  void hotlineScreen() async {
    try {
      List<Hotline> hotlines =
          await FirebaseController.getHotlines(_state.user.uid);
      Navigator.pushNamed(_state.context, HotlineScreen.routeName,
          arguments: {'hotlines': hotlines, 'user': _state.user});
    } catch (e) {
      MyDialog.info(
        context: _state.context,
        title: 'Error getting hotlines',
        content: e.message ?? e.toString(),
      );
    }
  }

  void signOut() async {
    try {
      await FirebaseController.signOut();
    } catch (e) {
      print('signOut exception: ${e.message}');
    }
    Navigator.pushReplacementNamed(_state.context, SignInScreen.routeName);
  }

  void accessContacts() async {
    try {
      List<Contacts> contacts =
          await FirebaseController.getContacts(_state.user.email);
      await Navigator.pushNamed(_state.context, ContactScreen.routeName,
          arguments: {'user': _state.user.email, 'contacts': contacts});
    } catch (e) {
      MyDialog.info(
        context: _state.context,
        content: e.toString(),
        title: 'Error loading Contact Screen',
      );
    }
  }

  void accessVault() async {
    try {
      Vault vault = await FirebaseController.getVault(_state.user.email);
      if(vault == null){
        vault = Vault(owner: _state.user.email);
        vault.docId = await FirebaseController.createVault(vault);
      }

      await Navigator.pushNamed(_state.context, FeelGoodVault.routeName,arguments: {'user': _state.user.email, "vault": vault});
    } catch (e) {
      MyDialog.info(
        context: _state.context,
        content: e.toString(),
        title: 'Error loading Vault',
      );
    }
  }

  void journalScreen() async {
    try {
      List<Journal> journal =
          await FirebaseController.getJournal(_state.user.email);
      await Navigator.pushNamed(_state.context, JournalScreen.routeName,
          arguments: {'user': _state.user.email, 'journal': journal});
    } catch (e) {
      MyDialog.info(
        context: _state.context,
        content: e.toString(),
        title: 'Error loading Journal Screen',
      );
    }
  }

  void about() {
    Navigator.pushNamed(_state.context, AboutPageScreen.routeName);
  }

  void calender() {
    Navigator.pushNamed(_state.context, CalenderScreen.routeName);
  }
}
