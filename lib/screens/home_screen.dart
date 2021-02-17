import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget{

  static const routeName = './singIn/homeScreen/';

  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  } 

}

class _HomeState extends State<HomeScreen>{

  FirebaseUser user;

  @override
  Widget build(BuildContext context) {
    Map arg = ModalRoute.of(context).settings.arguments;
    user ??= arg['user'];

    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Text('Home Screen'),
    );
  }

}