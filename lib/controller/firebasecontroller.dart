import 'package:SDD_Project/model/diagnosis.dart';
import 'package:SDD_Project/model/hotline.dart';
import 'package:SDD_Project/model/medicalHistory.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:SDD_Project/model/contacts.dart';
import 'package:SDD_Project/model/prescription.dart';

class FirebaseController{

  static Future signIn(String email, String password) async{
    AuthResult auth = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email, 
      password: password
    );
    return auth.user;
  }

  static Future<List<Prescription>> getPrescriptions(String uid) async{

    QuerySnapshot querySnapshot = await Firestore.instance
        .collection(Prescription.COLLECTION)
        .where(Prescription.CREATED_BY, isEqualTo: uid)
        .orderBy(Prescription.FILLED_DATE)
        .getDocuments();

    var results = <Prescription>[];
    if(querySnapshot != null && querySnapshot.documents.length != 0){
      for(var doc in querySnapshot.documents){
        results.add(Prescription.deserialize(doc.data, doc.documentID));
      }
    }
    return results;
  }

  
  static Future<String> addPrescription(Prescription prescription) async{

    DocumentReference ref = await Firestore.instance
        .collection(Prescription.COLLECTION)
        .add(prescription.serialize());
    return ref.documentID;

  }

  static Future<void> updatePrescription(Prescription prescription) async{
    await Firestore.instance
        .collection(Prescription.COLLECTION)
        .document(prescription.docId)
        .setData(prescription.serialize());
  }
  
  static Future<void> deletePrescription(String docId) async{
    await Firestore.instance
      .collection(Prescription.COLLECTION)
      .document(docId)
      .delete();
  }

  static Future<List<Hotline>> getHotlines(String uid) async{

    QuerySnapshot querySnapshot = await Firestore.instance
        .collection(Hotline.COLLECTION)
        .where(Hotline.CREATED_BY, isEqualTo: uid)
        .orderBy(Hotline.NAME)
        .getDocuments();

    var results = <Hotline>[];
    if(querySnapshot != null && querySnapshot.documents.length != 0){
      for(var doc in querySnapshot.documents){
        results.add(Hotline.deserialize(doc.data, doc.documentID));
      }
    }
    return results;

  }

  static Future<String> addHotline(Hotline hotline) async{
    DocumentReference ref = await Firestore.instance
        .collection(Hotline.COLLECTION)
        .add(hotline.serialize());
    return ref.documentID;
  }

  static Future<String> addDiagnosis(Diagnosis diagnosis) async{
    DocumentReference ref = await Firestore.instance
        .collection(Diagnosis.COLLECTION)
        .add(diagnosis.serialize());
    return ref.documentID;
  }

  static Future<List<Diagnosis>> getDiagnoses(String uid) async{
      QuerySnapshot querySnapshot = await Firestore.instance
        .collection(Diagnosis.COLLECTION)
        .where(Diagnosis.CREATED_BY, isEqualTo: uid)
        .orderBy(Diagnosis.DIAGNOSED_AT)
        .getDocuments();

    var results = <Diagnosis>[];
    if(querySnapshot != null && querySnapshot.documents.length != 0){
      for(var doc in querySnapshot.documents){
        results.add(Diagnosis.deserialize(doc.data, doc.documentID));
      }
    }
    return results;
  }

  static Future<void> deleteDiagnosis(String docId) async{
    await Firestore.instance
          .collection(Diagnosis.COLLECTION)
          .document(docId)
          .delete();
  }

  static Future<void> updateDiagnosis(Diagnosis diagnosis) async{
    await Firestore.instance
          .collection(Diagnosis.COLLECTION)
          .document(diagnosis.docId)
          .setData(diagnosis.serialize());
  }

  static Future<String> addFamilyHistory(MedicalHistory history) async{
    DocumentReference ref = await Firestore.instance
        .collection(MedicalHistory.COLLECTION)
        .add(history.serialize());
    return ref.documentID;
  }

  static Future<List<MedicalHistory>> getFamilyHistory(String uid) async{
    QuerySnapshot querySnapshot = await Firestore.instance
        .collection(MedicalHistory.COLLECTION)
        .where(MedicalHistory.CREATED_BY, isEqualTo: uid)
        .orderBy(MedicalHistory.DIAGNOSIS)
        .getDocuments();

    var results = <MedicalHistory>[];
    if(querySnapshot != null && querySnapshot.documents.length != 0){
      for(var doc in querySnapshot.documents){
        results.add(MedicalHistory.deserialize(doc.data, doc.documentID));
      }
    }
    return results;
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