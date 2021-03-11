import 'package:SDD_Project/screens/addFamilyHistory_screen.dart';
import 'package:SDD_Project/screens/addHotline_screen.dart';
import 'package:SDD_Project/screens/contacts_screen.dart';
import 'package:SDD_Project/screens/editprescription_screen.dart';
import 'package:SDD_Project/screens/familyHistory_screen.dart';
import 'package:SDD_Project/screens/home_screen.dart';
import 'package:SDD_Project/screens/hotline_screen.dart';
import 'package:SDD_Project/screens/diagnosis_screen.dart';
import 'package:SDD_Project/screens/journal_screen.dart';
import 'package:SDD_Project/screens/prescriptionDetails_screen.dart';
import 'package:SDD_Project/screens/signin_screen.dart';
import 'package:SDD_Project/screens/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:SDD_Project/screens/feelgoodvault_screen.dart';
import 'screens/adddiagnosis_screen.dart';
import 'screens/prescription_screen.dart';
import 'screens/addprescription_screen.dart';

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
        PrescriptionScreen.routeName: (context) => PrescriptionScreen(),
        AddPrescriptionScreen.routeName: (context) => AddPrescriptionScreen(),
        HotlineScreen.routeName: (context) => HotlineScreen(),
        PrescriptionDetails.routeName: (context) => PrescriptionDetails(),
        EditPrescription.routeName: (context) => EditPrescription(),
        AddHotline.routeName: (context) => AddHotline(),
        DiagnosisScreen.routeName: (context) => DiagnosisScreen(),
        AddDiagnosis.routeName: (context) => AddDiagnosis(),
        FamilyHistory.routeName: (context) => FamilyHistory(),
        AddFamilyHistory.routeName: (context) => AddFamilyHistory(),
        FeelGoodVault.routeName: (context) => FeelGoodVault(),
        JournalScreen.routeName: (context) => JournalScreen()
      }

    );

  }

}