import 'package:SDD_Project/screens/signin_screen.dart';
import 'package:flutter/material.dart';

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
      }

    );

  }

}