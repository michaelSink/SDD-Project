import 'package:SDD_Project/screens/addeventpage_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalenderScreen extends StatefulWidget {
  static const routeName = "/homescreen/calender";

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _CalenderState();
  }
}

class _CalenderState extends State<CalenderScreen> {
  CalendarController _calendarController = CalendarController();
  _Controller con;
  FirebaseUser user;
  @override
  void initState() {
    super.initState();
    con = _Controller(this);
  }

  void render(fn) => setState(fn);

  @override
  Widget build(BuildContext context) {
    Map args = ModalRoute.of(context).settings.arguments;
    //user ??= args['user'];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('Calender'),
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
            )
          ],
        ),
      ),
       floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(context, AddEventPageScreen.routeName);
        },
      ),
    );
  }
}

class _Controller {
  _CalenderState _state;
  _Controller(this._state);
}
