import 'dart:io';
import 'package:SDD_Project/model/personalcare.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'question_screen.dart';

class QuestionHomeScreen extends StatefulWidget {
  static const routeName = '/homeScreen/questionHomeScreen';

  @override
  State<StatefulWidget> createState() {
    return _QuestionHomeState();
  }
}

class _QuestionHomeState extends State<QuestionHomeScreen> {
  _Controller con;
  File image;
  var formKey = GlobalKey<FormState>();
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
        title: Text('Question Form'),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add_comment),
        onPressed: con.add_comment,
      ),
      body: personalCare == null
      ? Text('No Question Form', style: TextStyle(fontSize: 30.0),)
      : ListView.builder(
        itemCount: personalCare.length,
        itemBuilder: (BuildContext context, int index) => ListTile(
          leading: Image.network(personalCare[index].photoURL),
          trailing: Icon(Icons.keyboard_arrow_right),
          title: Text(personalCare[index].name),
          subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(personalCare[index].age),
            Text(personalCare[index].race),
            Text(personalCare[index].sex),
            Text(personalCare[index].religiousAffiliation),
            Text(personalCare[index].sexualOrientation),
            Text(personalCare[index].militaryHistory),
            Text('Created by : ${personalCare[index].createdBy}'),
            Text('Updated at : ${personalCare[index].updatedAt}'),
          ],
            ),
        ))
    );
  }
}

class _Controller {
  _QuestionHomeState _state;
  _Controller(this._state);

  void add_comment() async {
    await Navigator.pushNamed(_state.context, QuestionFormScreen.routeName,
        arguments: {
          'user': _state.user,
          'personalCareList': _state.personalCare
        });
    _state.render(() {});
  }
  


}
