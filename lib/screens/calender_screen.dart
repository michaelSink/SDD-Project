import 'package:SDD_Project/controller/event_firestore_service.dart';
import 'package:SDD_Project/controller/firebasecontroller.dart';
import 'package:SDD_Project/model/app_event.dart';
import 'package:SDD_Project/model/personalcare.dart';
import 'package:SDD_Project/screens/signin_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import 'aboutpage_screen.dart';
import 'addeventpage_screen.dart';
import 'questionhome_screen.dart';

class CalenderScreen extends StatefulWidget {
  static const routeName = '/signInScreen/homeScreen';

  @override
  State<StatefulWidget> createState() {
    return _CalenderState();
  }
}

class _CalenderState extends State<CalenderScreen> {
  CalendarController _calendarController = CalendarController();
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
    Map args = ModalRoute.of(context).settings.arguments;
    user ??= args['user'];
    personalCare ??= args['personalCareList'];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text('Home'),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(user.displayName ?? 'N/A'),
              accountEmail: Text(user.email),
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Sign Out'),
              onTap: con.signOut,
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('About page'),
              onTap: con.about,
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Question Form'),
              onTap: con.questionForm,
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Card(
              clipBehavior: Clip.antiAlias,
              margin: const EdgeInsets.all(8.0),
              child: TableCalendar(
                calendarController: _calendarController,
                weekendDays: [6],
                headerStyle: HeaderStyle(
                    decoration: BoxDecoration(
                  color: Colors.red,
                )),
                calendarStyle: CalendarStyle(),
                builders: CalendarBuilders(),
              ),
            ),
            StreamBuilder(
              stream: eventDBS.streamList(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  final events = snapshot.data;
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                      itemCount: events.length,
                      itemBuilder: (BuildContext context, int index) {
                        AppEvent event = events[index];
                        return ListTile(title: Text(event.title),
                        subtitle: Text(DateFormat("EEEE, dd MMMM, yyyy").format(event.date)),
                        // onTap: () => Navigator.pushNamed(context, EventDetails.routeName,
                        // arguments: event),
                        );
                      });
                }
                return CircularProgressIndicator();
              },
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(context, AddEventPageScreen.routeName,
              arguments: _calendarController.selectedDay);
        },
      ),
    );
  }
}

class _Controller {
  _CalenderState _state;
  _Controller(this._state);

  // read all question's from firebase
  void questionForm() async {
    await Navigator.pushNamed(_state.context, QuestionHomeScreen.routeName,
        arguments: {
          'user': _state.user,
          'personalCareList': _state.personalCare
        });
    _state.render(() {});
  }

  void about() {
    Navigator.pushNamed(_state.context, AboutPageScreen.routeName);
  }

  void signOut() async {
    try {
      await FirebaseController.signOut();
    } catch (e) {
      print('signOut exception: ${e.message}');
    }
    Navigator.pushReplacementNamed(_state.context, SignInScreen.routeName);
  }
}
