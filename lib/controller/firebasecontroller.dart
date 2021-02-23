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

}