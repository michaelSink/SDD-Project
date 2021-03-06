import 'package:SDD_Project/screens/contacts_screen.dart';
import 'package:SDD_Project/screens/feelgoodvault_screen.dart';
import 'package:SDD_Project/screens/home_screen.dart';
import 'package:SDD_Project/screens/hotline_screen.dart';
import 'package:SDD_Project/screens/perscriptionDetails_screen.dart';
import 'package:SDD_Project/screens/signin_screen.dart';
import 'package:SDD_Project/screens/signup_screen.dart';
import 'package:flutter/material.dart';
import 'screens/perscription_screen.dart';
import 'screens/addperscription_screen.dart';

void main(){

  runApp(AppRoutes());
  
}

class AppRoutes extends StatelessWidget{

  @override
  Widget build(BuildContext context) {

    return MaterialApp(

      initialRoute: SignInScreen.routeName,

      routes: {
        SignInScreen.routeName: (context) => SignInScreen(),
        HomeScreen.routeName: (context) => HomeScreen(),
        SignUpScreen.routeName: (context) => SignUpScreen(),
        ContactScreen.routeName: (context) => ContactScreen(),
        PerscriptionScreen.routeName: (context) => PerscriptionScreen(),
        AddPerscriptionScreen.routeName: (context) => AddPerscriptionScreen(),
        HotlineScreen.routeName: (context) => HotlineScreen(),
        PerscriptionDetails.routeName: (context) => PerscriptionDetails(),
        FeelGoodVault.routeName: (context) => FeelGoodVault()
      }

    );

  }

}