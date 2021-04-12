import 'package:SDD_Project/controller/firebasecontroller.dart';
import 'package:SDD_Project/model/contacts.dart';
import 'package:SDD_Project/model/journal.dart';
import 'package:SDD_Project/model/mental_health.dart';
import 'package:SDD_Project/model/personalcare.dart';
import 'package:SDD_Project/model/location.dart';
import 'package:SDD_Project/model/vault.dart';
import 'package:SDD_Project/model/warningSign.dart';
import 'package:SDD_Project/screens/calender_screen.dart';
import 'package:SDD_Project/screens/communitySupport_screen.dart';
import 'package:SDD_Project/screens/contacts_screen.dart';
import 'package:SDD_Project/screens/feelgoodvault_screen.dart';
import 'package:SDD_Project/model/diagnosis.dart';
import 'package:SDD_Project/model/hotline.dart';
import 'package:SDD_Project/model/medicalHistory.dart';
import 'package:SDD_Project/screens/diagnosis_screen.dart';
import 'package:SDD_Project/screens/familyHistory_screen.dart';
import 'package:SDD_Project/screens/location_screen.dart';
import 'package:SDD_Project/screens/prescription_screen.dart';
import 'package:SDD_Project/screens/questionhome_screen.dart';
import 'package:SDD_Project/screens/signin_screen.dart';
import 'package:SDD_Project/screens/warningsigns_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:SDD_Project/screens/hotline_screen.dart';
import 'package:SDD_Project/screens/views/myimageview.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controller/firebasecontroller.dart';
import 'aboutpage_screen.dart';
import 'journal_screen.dart';
import 'mental_health_screen.dart';
import 'medicalInformation_screen.dart';
import 'resources_screen.dart';
import 'selfHelp_screen.dart';
import 'settings_screen.dart';
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
  List<PersonalCare> personalCare;

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

    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Home'),
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              Container(
                  child: UserAccountsDrawerHeader(
                accountName: Text(user.email),
                accountEmail: Text(
                  user.displayName ?? 'N/A',
                ),
                currentAccountPicture: CircleAvatar(
                  child: ClipOval(
                    child: user.photoUrl != null
                        ? MyImageView.network(
                            imageUrl: user.photoUrl, context: context)
                        : Image.asset('static/images/default-user.png'),
                  ),
                  backgroundColor: Theme.of(context).primaryColorDark,
                  foregroundColor: Theme.of(context).canvasColor,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    Colors.blue,
                    Colors.blue[200],
                  ], tileMode: TileMode.repeated),
                ),
              )),
              ListTile(
                leading: Icon(Icons.developer_board),
                title: Text('About page'),
                onTap: con.about,
              ),
              ListTile(
                leading: Icon(Icons.exit_to_app),
                title: Text('Question Form'),
                onTap: con.questionForm,
              ),
              Divider(
                color: Colors.black,
              ),
              ListTile(
                leading: Icon(Icons.settings),
                title: Text('Settings'),
                onTap: con.settings,
              ),
              ListTile(
                leading: Icon(Icons.exit_to_app),
                title: Text('Sign Out'),
                onTap: con.signOut,
              ),
            ],
          ),
        ),
        body: GridView.count(
          crossAxisCount: 2,
          padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
          children: [
            InkWell(
              onTap: con.medicalInformationScreen,
              child: Card(
                elevation: 6,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.local_hospital,
                      size: 35,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Medical Information",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: con.selfHelp,
              child: Card(
                elevation: 6,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.spa_outlined,
                      size: 35,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Self Help",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: con.communityScreen,
              child: Card(
                elevation: 6,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.people_outline,
                      size: 35,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Community Support",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: con.resourceScreen,
              child: Card(
                elevation: 6,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.book,
                      size: 35,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Resources",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
              backgroundColor: Colors.grey,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
              backgroundColor: Colors.grey,
            ),
          ],
          onTap: (value) => value == 1 ? con.settings() : null,
        ),
      ),
    );
  }
}

class _Controller {
  _HomeState _state;
  _Controller(this._state);

  void medicalInformationScreen() async {
    await Navigator.pushNamed(_state.context, MedicalInformation.routeName,
        arguments: {'user': _state.user});
  }

  void selfHelp() async {
    await Navigator.pushNamed(_state.context, SelfHelp.routeName,
        arguments: {'user': _state.user});
  }

  void communityScreen() async {
    await Navigator.pushNamed(_state.context, CommunitySupport.routeName,
        arguments: {'user': _state.user});
  }

  void resourceScreen() async {
    await Navigator.pushNamed(_state.context, ResourceScreen.routeName,
        arguments: {'user': _state.user});
  }

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

  void locationScreen() async {
    try {
      List<Location> locations =
          await FirebaseController.getLocations(_state.user.uid);

      await Navigator.pushNamed(_state.context, LocationScreen.routeName,
          arguments: {'locations': locations, 'user': _state.user});
    } catch (e) {
      MyDialog.info(
          title: 'Error', context: _state.context, content: e.toString());
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

  void warningScreen() async {
    try {
      List<WarningSign> signs =
          await FirebaseController.getWarningSigns(_state.user.uid);

      await Navigator.pushNamed(_state.context, WarningSigns.routeName,
          arguments: {'user': _state.user, 'signs': signs});
    } catch (e) {
      MyDialog.info(
          title: 'Error', context: _state.context, content: e.toString());
    }
  }

  void mentalHealthScreen() async {
    try {
      List<MentalHealth> mentalHealth =
          await FirebaseController.getMentalHealth(_state.user.uid);

      await Navigator.pushNamed(_state.context, MentalHealthScreen.routeName,
          arguments: {'user': _state.user, 'mentalHealth': mentalHealth});
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
      final prefs = await SharedPreferences.getInstance();
      prefs.setBool('remember', false);
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
      if (vault == null) {
        vault = Vault(owner: _state.user.email);
        vault.docId = await FirebaseController.createVault(vault);
      }

      await Navigator.pushNamed(_state.context, FeelGoodVault.routeName,
          arguments: {'user': _state.user.email, "vault": vault});
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

  // read all question's from firebase
  void questionForm() async {
    await Navigator.pushNamed(_state.context, QuestionHomeScreen.routeName,
        arguments: {
          'user': _state.user,
          'personalCareList': _state.personalCare
        });
    _state.render(() {});
  }

  void settings() async {
    await Navigator.pushNamed(_state.context, SettingsScreen.routeName,
        arguments: {'user': _state.user});
  }

  void about() {
    Navigator.pushNamed(_state.context, AboutPageScreen.routeName);
  }

  void calender() {
    Navigator.pushNamed(_state.context, CalenderScreen.routeName,
        arguments: {'user': _state.user});
  }
}
