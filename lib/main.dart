import 'package:SDD_Project/screens/home_screen.dart';
import 'package:SDD_Project/screens/signin_screen.dart';
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
        PerscriptionScreen.routeName: (context) => PerscriptionScreen(),
        AddPerscriptionScreen.routeName: (context) => AddPerscriptionScreen(),
      }

    );

  }

}