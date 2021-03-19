import 'dart:io';

import 'package:SDD_Project/model/SDD-Project.dart';
import 'package:SDD_Project/model/diagnosis.dart';
import 'package:SDD_Project/model/hotline.dart';
import 'package:SDD_Project/model/medicalHistory.dart';
import 'package:SDD_Project/model/vault.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:SDD_Project/model/contacts.dart';
import 'package:SDD_Project/model/prescription.dart';
import 'package:SDD_Project/model/journal.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class FirebaseController {
  static Future signIn(String email, String password) async {
    AuthResult auth = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    return auth.user;
  }

  static Future<List<Prescription>> getPrescriptions(String uid) async {
    QuerySnapshot querySnapshot = await Firestore.instance
        .collection(Prescription.COLLECTION)
        .where(Prescription.CREATED_BY, isEqualTo: uid)
        .orderBy(Prescription.FILLED_DATE)
        .getDocuments();
    var results = <Prescription>[];
    if (querySnapshot != null && querySnapshot.documents.length != 0) {
      for (var doc in querySnapshot.documents) {
        results.add(Prescription.deserialize(doc.data, doc.documentID));
      }
    }
    return results;
  }

  static Future<String> addPrescription(Prescription prescription) async {
    DocumentReference ref = await Firestore.instance
        .collection(Prescription.COLLECTION)
        .add(prescription.serialize());
    return ref.documentID;
  }

  static Future<void> updatePrescription(Prescription prescription) async {
    await Firestore.instance
        .collection(Prescription.COLLECTION)
        .document(prescription.docId)
        .setData(prescription.serialize());
  }

  static Future<void> deletePrescription(String docId) async {
    await Firestore.instance
        .collection(Prescription.COLLECTION)
        .document(docId)
        .delete();
  }

  static Future<List<Hotline>> getHotlines(String uid) async {
    QuerySnapshot querySnapshot = await Firestore.instance
        .collection(Hotline.COLLECTION)
        .where(Hotline.CREATED_BY, isEqualTo: uid)
        .orderBy(Hotline.NAME)
        .getDocuments();
    var results = <Hotline>[];
    if (querySnapshot != null && querySnapshot.documents.length != 0) {
      for (var doc in querySnapshot.documents) {
        results.add(Hotline.deserialize(doc.data, doc.documentID));
      }
    }
    return results;
  }

  static Future<String> addHotline(Hotline hotline) async {
    DocumentReference ref = await Firestore.instance
        .collection(Hotline.COLLECTION)
        .add(hotline.serialize());
    return ref.documentID;
  }

  static Future<String> addDiagnosis(Diagnosis diagnosis) async {
    DocumentReference ref = await Firestore.instance
        .collection(Diagnosis.COLLECTION)
        .add(diagnosis.serialize());
    return ref.documentID;
  }

  static Future<List<Diagnosis>> getDiagnoses(String uid) async {
    QuerySnapshot querySnapshot = await Firestore.instance
        .collection(Diagnosis.COLLECTION)
        .where(Diagnosis.CREATED_BY, isEqualTo: uid)
        .orderBy(Diagnosis.DIAGNOSED_AT)
        .getDocuments();

    var results = <Diagnosis>[];
    if (querySnapshot != null && querySnapshot.documents.length != 0) {
      for (var doc in querySnapshot.documents) {
        results.add(Diagnosis.deserialize(doc.data, doc.documentID));
      }
    }
    return results;
  }

  static Future<String> addFamilyHistory(MedicalHistory history) async {
    DocumentReference ref = await Firestore.instance
        .collection(MedicalHistory.COLLECTION)
        .add(history.serialize());
    return ref.documentID;
  }

  static Future<List<MedicalHistory>> getFamilyHistory(String uid) async {
    QuerySnapshot querySnapshot = await Firestore.instance
        .collection(MedicalHistory.COLLECTION)
        .where(MedicalHistory.CREATED_BY, isEqualTo: uid)
        .orderBy(MedicalHistory.DIAGNOSIS)
        .getDocuments();

    var results = <MedicalHistory>[];
    if (querySnapshot != null && querySnapshot.documents.length != 0) {
      for (var doc in querySnapshot.documents) {
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
        .collection(Contacts.COLLECTION)
        .add(contact.serialize());
    return ref.documentID;
  }

  static Future<List<Contacts>> getContacts(String email) async {
    QuerySnapshot snapshot = await Firestore()
        .collection(Contacts.COLLECTION)
        .where("owner", isEqualTo: email)
        .orderBy("firstName")
        .getDocuments();

    List<Contacts> contacts = [];
    if (snapshot != null && snapshot.documents.length != 0) {
      for (var doc in snapshot.documents) {
        Contacts c = Contacts.deserialize(doc.data, doc.documentID);
        contacts.add(c);
      }
    }
    return contacts;
  }

  static Future deleteContacts(Contacts contact) async {
    await Firestore()
        .collection(Contacts.COLLECTION)
        .document(contact.docID)
        .delete();
  }

  static Future<Vault> getVault(email) async {
    QuerySnapshot snapshot = await Firestore()
        .collection("vault")
        .where("owner", isEqualTo: email)
        .getDocuments();
    Vault result;
    if (snapshot != null && snapshot.documents.length != 0) {
      var doc = snapshot.documents[0]; //possibly change later
      print(doc.data);
      result = Vault.deserialize(doc.data, doc.documentID);
      return result;
    }
    return null;
  }

  static Future<List<Journal>> getJournal(String email) async {
    QuerySnapshot snapshot = await Firestore()
        .collection(Journal.COLLECTION)
        .where("owner", isEqualTo: email)
        .orderBy("date")
        .getDocuments();

    List<Journal> journal = [];
    if (snapshot != null && snapshot.documents.length != 0) {
      for (var doc in snapshot.documents) {
        Journal j = Journal.deserialize(doc.data, doc.documentID);
        journal.add(j);
      }
    }
    return journal;
  }

  static Future<String> addJournal(Journal journal) async {
    DocumentReference ref = await Firestore.instance
        .collection(Journal.COLLECTION)
        .add(journal.serialize());
    return ref.documentID;
  }

  static Future deleteJournal(Journal journal) async {
    await Firestore()
        .collection(Journal.COLLECTION)
        .document(journal.docID)
        .delete();
  }

  static Future<List<PersonalCare>> getPersonalCare(String email) async {
    QuerySnapshot querySnapshot = await Firestore.instance
        .collection(PersonalCare.COLLECTION)
        .where(PersonalCare.CREATED_BY, isEqualTo: email)
        .getDocuments();

    var result = <PersonalCare>[];
    if (querySnapshot != null && querySnapshot.documents.length != 0) {
      for (var doc in querySnapshot.documents) {
        result.add(PersonalCare.deserialize(doc.data, doc.documentID));
      }
    }

    return result;
  }

  //3 functions for adding pic to storage, then adding information about pic to firestore, then firestore doc to vault array
  static Future<Map<String, String>> addPicToStorage(
      {@required File image, @required String email}) async {
    print("Start add Pic to Storate");
    String filePath = "${Picture.IMAGE_FOLDER}/$email/${DateTime.now()}";
    StorageUploadTask task =
        FirebaseStorage.instance.ref().child(filePath).putFile(image);

    var download = await task.onComplete;
    var url = await download.ref.getDownloadURL();
    return {"url": url, "path": filePath};
  }

  static Future<String> addPicToFirestore(Picture p) async {
    print("Start add Pic to firestore");
    DocumentReference ref =
        await Firestore.instance.collection(Vault.PICTURES).add(p.serialize());
    print("Leaving addPicToFirestore");
    return ref.documentID;
  }

  static Future addPicToVault(String id, String vaultId) async {
    String ref = "${Vault.PICTURES}/$id";
    print("Start add Pic ref to Vault");
    
    await Firestore.instance
        .collection(Vault.COLLECTION)
        .document(vaultId)
        .updateData({Vault.PICTURES: [ref]});
  }

  static Future<String> createVault(Vault v) async {
    DocumentReference ref = await Firestore.instance
        .collection(Vault.COLLECTION)
        .add(v.serialize());
    print("Inside create vault");
   
    return ref.documentID;
  }
}
