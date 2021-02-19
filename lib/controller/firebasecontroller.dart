import 'package:SDD_Project/model/perscription.dart';
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

  static Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  static Future<String> addPerscription(Perscription perscription) async{

    DocumentReference ref = await Firestore.instance
        .collection(Perscription.COLLECTION)
        .add(perscription.serialize());
    return ref.documentID;

  }

  static Future<List<Perscription>> getPerscriptions(String uid) async{

    QuerySnapshot querySnapshot = await Firestore.instance
        .collection(Perscription.COLLECTION)
        .where(Perscription.CREATED_BY, isEqualTo: uid)
        .orderBy(Perscription.FILLED_DATE)
        .getDocuments();

    var results = <Perscription>[];
    if(querySnapshot != null && querySnapshot.documents.length != 0){
      for(var doc in querySnapshot.documents){
        results.add(Perscription.deserialize(doc.data, doc.documentID));
      }
    }

    return results;

  }

}