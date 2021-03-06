import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FeelGoodVault extends StatefulWidget {
  static const routeName = "/homescreen/feelgoodvault";
  
  @override
  State<StatefulWidget> createState() {
    return _FeelGoodVault();
  }
}

class _FeelGoodVault extends State<FeelGoodVault> {
  String user;
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Map args = ModalRoute.of(context).settings.arguments;
    user ??= args['user'];

    return Scaffold(
      appBar: AppBar(
        title: Text("Feel Good Vault"),
      ),
      body: Text("Vault info"),
    );
  }
}
