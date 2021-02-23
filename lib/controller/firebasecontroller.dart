import 'package:SDD_Project/model/contacts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseController{

  static Future signIn(String email, String password) async{
    AuthResult auth = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email, 
      password: password
    );
    return auth.user;
  }

   static Future signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  static Future signUp(String email, String password) async {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  static Future<String> addContact(Contacts contact) async {
      DocumentReference ref = await Firestore()
      .collection(Contacts.COLLECTION).add(contact.serialize());
      return ref.documentID;
      
  }

}