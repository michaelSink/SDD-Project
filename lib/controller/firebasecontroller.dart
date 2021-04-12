import 'dart:io';
import 'package:SDD_Project/model/diagnosis.dart';
import 'package:SDD_Project/model/hotline.dart';
import 'package:SDD_Project/model/location.dart';
import 'package:SDD_Project/model/medicalHistory.dart';
import 'package:SDD_Project/model/mental_health.dart';
import 'package:SDD_Project/model/personalcare.dart';
import 'package:SDD_Project/model/vault.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:SDD_Project/model/contacts.dart';
import 'package:SDD_Project/model/prescription.dart';
import 'package:SDD_Project/model/journal.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

class FirebaseController {
  static Future signIn(String email, String password) async {
    AuthResult auth = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    return auth.user;
  }


  static Future<List<String>> getImageText(File image) async{

    final inputImage = InputImage.fromFile(image);
    TextDetector _textDetector = GoogleMlKit.instance.textDetector();

    final text = await _textDetector.processImage(inputImage);
    List<String> recognizedText = [];

    for(TextBlock textBlob in text.textBlocks){
      for(TextLine textLine in textBlob.textLines){
        recognizedText.add(textLine.lineText);
      }
    }
    return recognizedText;
  }


  static Future<Map<String, String>> uploadLocationStorage({

    @required File image,
    String filePath,
    @required String uid,
  }) async {
    filePath ??= '${Location.IMAGE_FOLDER}/$uid/${DateTime.now()}';

    StorageUploadTask task =
        FirebaseStorage.instance.ref().child(filePath).putFile(image);

    var download = await task.onComplete;
    String url = await download.ref.getDownloadURL();
    return {'url': url, 'path': filePath};
  }

  static Future<String> addLocation(Location location) async {
    DocumentReference ref = await Firestore.instance
        .collection(Location.COLLECTION)
        .add(location.serialize());
    return ref.documentID;
  }

  static Future<List<Location>> getLocations(String uid) async {
    QuerySnapshot querySnapshot = await Firestore.instance
        .collection(Location.COLLECTION)
        .where(Location.CREATED_BY, isEqualTo: uid)
        .orderBy(Location.NAME)
        .getDocuments();

    var results = <Location>[];
    if (querySnapshot != null && querySnapshot.documents.length != 0) {
      for (var doc in querySnapshot.documents) {
        results.add(Location.deserialize(doc.data, doc.documentID));
      }
    }
    return results;
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

  static Future<void> deleteDiagnosis(String docId) async {
    await Firestore.instance
        .collection(Diagnosis.COLLECTION)
        .document(docId)
        .delete();
  }

  static Future<void> updateDiagnosis(Diagnosis diagnosis) async {
    await Firestore.instance
        .collection(Diagnosis.COLLECTION)
        .document(diagnosis.docId)
        .setData(diagnosis.serialize());
  }

  static Future<String> addFamilyHistory(MedicalHistory history) async {
    DocumentReference ref = await Firestore.instance
        .collection(MedicalHistory.COLLECTION)
        .add(history.serialize());
    return ref.documentID;
  }

  static Future<void> updateFamilyHistory(MedicalHistory history) async {
    await Firestore.instance
        .collection(MedicalHistory.COLLECTION)
        .document(history.docId)
        .setData(history.serialize());
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

  static Future<void> deleteHistory(String docId) async{
    await Firestore.instance
        .collection(MedicalHistory.COLLECTION)
        .document(docId)
        .delete();
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

  //==========================start of loading the vault and all its contents==============================
  static Future<Vault> getVault(email) async {
    QuerySnapshot snapshot = await Firestore()
        .collection(Vault.COLLECTION)
        .where("owner", isEqualTo: email)
        .getDocuments();

    Vault result;
    List<Picture> pics = [];
    List<Songs> songs = [];
    List<Videos> vids = [];
    List<Quotes> quotes = [];
    List<Stories> stories = [];
    if (snapshot != null && snapshot.documents.length != 0) {
      var doc = snapshot.documents[0]; //get the first vault from the search

      //start query for getting pics from the collection
      QuerySnapshot snap = await Firestore.instance
          .collection(Vault.COLLECTION)
          .document(doc.documentID)
          .collection(Vault.PICTURES)
          .getDocuments();
      if (snap != null && snap.documents.length != 0) {
        var doc2;
        for (int i = 0; i < snap.documents.length; i++) {
          doc2 = snap.documents[i];
          Picture p = Picture.deserialize(doc2.data, doc2.documentID);
          pics.add(p);
        }
      }
      //start query for songs
      QuerySnapshot snap2 = await Firestore.instance
          .collection(Vault.COLLECTION)
          .document(doc.documentID)
          .collection(Vault.SONGS)
          .getDocuments();
      if (snap2 != null && snap2.documents.length != 0) {
        var doc3;
        for (int i = 0; i < snap2.documents.length; i++) {
          doc3 = snap2.documents[i];
          Songs s = Songs.deserialize(doc3.data, doc3.documentID);
          songs.add(s);
        }
      }
      //start query for vids
      QuerySnapshot snap3 = await Firestore.instance
          .collection(Vault.COLLECTION)
          .document(doc.documentID)
          .collection(Vault.VIDEOS)
          .getDocuments();
      if (snap3 != null && snap3.documents.length != 0) {
        var doc4;
        for (int i = 0; i < snap3.documents.length; i++) {
          doc4 = snap3.documents[i];
          Videos v = Videos.deserialize(doc4.data, doc.documentID);
          vids.add(v);
        }
      }
      //query for quotes
      QuerySnapshot snap4 = await Firestore.instance
          .collection(Vault.COLLECTION)
          .document(doc.documentID)
          .collection(Vault.QUOTES)
          .getDocuments();
      if (snap4 != null && snap4.documents.length != 0) {
        var doc5;
        for (int i = 0; i < snap4.documents.length; i++) {
          doc5 = snap4.documents[i];
          Quotes q = Quotes.deserialize(doc5.data, doc.documentID);
          quotes.add(q);
        }
      }
      //queru for stories
      QuerySnapshot snap5 = await Firestore.instance
          .collection(Vault.COLLECTION)
          .document(doc.documentID)
          .collection(Vault.STORIES)
          .getDocuments();
      if (snap5 != null && snap5.documents.length != 0) {
        var doc6;
        for (int i = 0; i < snap5.documents.length; i++) {
          doc6 = snap5.documents[i];
          Stories s = Stories.deserialize(doc6.data, doc.documentID);
          stories.add(s);
        }
      }
      result = Vault.deserialize(
          doc.data, doc.documentID, pics, songs, vids, quotes, stories);
      return result;
    }
    return null;
  }
  //=============================end of load vault============================

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

  //=====================================start of functions for adding mementos============================================
  static Future<String> addQuote(String vaultId, Quotes q) async {
    print("Start add quote to Vault");
    DocumentReference doc = await Firestore.instance
        .collection(Vault.COLLECTION)
        .document(vaultId)
        .collection(Vault.QUOTES)
        .add(q.serialize());
    return doc.documentID;
  }

  static Future<String> addStory(String vaultId, Stories s) async {
    print("Start addStory");
    DocumentReference doc = await Firestore.instance
        .collection(Vault.COLLECTION)
        .document(vaultId)
        .collection(Vault.STORIES)
        .add(s.serialize());
    return doc.documentID;
  }

  //2 functions for adding pic to storage, then adding information about pic to firestore, then firestore doc to vault array
  static Future<Map<String, String>> addPicToStorage(
      {@required File image, @required String email}) async {
    print("Start add Pic to Storage");
    String filePath = "${Picture.IMAGE_FOLDER}/$email/${DateTime.now()}";
    StorageUploadTask task =
        FirebaseStorage.instance.ref().child(filePath).putFile(image);

    var download = await task.onComplete;
    var url = await download.ref.getDownloadURL();
    return {"url": url, "path": filePath};
  }

  static Future<String> addPicToVault(String vaultId, Picture p) async {
    print("Start add Pic ref to Vault");
    DocumentReference doc = await Firestore.instance
        .collection(Vault.COLLECTION)
        .document(vaultId)
        .collection(Vault.PICTURES)
        .add(p.serialize());
    return doc.documentID;
  }
  //End of adding pics

  static Future<String> addSong(String vaultId, Songs s) async {
    print("Start add song to Vault");
    DocumentReference doc = await Firestore.instance
        .collection(Vault.COLLECTION)
        .document(vaultId)
        .collection(Vault.SONGS)
        .add(s.serialize());
    return doc.documentID;
  }

  static Future<String> addVideo(String vaultId, Videos v) async {
    print("Start add video to Vault");
    DocumentReference doc = await Firestore.instance
        .collection(Vault.COLLECTION)
        .document(vaultId)
        .collection(Vault.VIDEOS)
        .add(v.serialize());
    return doc.documentID;
  }

  static Future<String> createVault(Vault v) async {
    CollectionReference ref = Firestore.instance.collection(Vault.COLLECTION);
    DocumentReference doc = await ref.add(v.serialize());
    print("Inside create vault");
    return doc.documentID;
  }
  //=====================================================================================

  static Future<List<Contacts>> searchContacts(
      String email, String searchKey) async {
    QuerySnapshot snapshot = await Firestore.instance
        .collection(Contacts.COLLECTION)
        .where(Contacts.OWNER, isEqualTo: email)
        .where(Contacts.FIRSTNAME, isEqualTo: searchKey)
        .getDocuments();

    var result = <Contacts>[];
    if (snapshot != null && snapshot.documents.length != 0) {
      for (var doc in snapshot.documents) {
        result.add(Contacts.deserialize(doc.data, doc.documentID));
      }
    }
    return result;
  }

  //=================functions for deleting mementos==============================
  static Future deleteStory(String vaultId, Stories s) async {
    await Firestore.instance
        .collection(Vault.COLLECTION)
        .document(vaultId)
        .collection(Vault.STORIES)
        .document(s.docId)
        .delete();
    return;
  }

  static Future deleteQuote(String vaultId, Quotes q) async {
    await Firestore.instance
        .collection(Vault.COLLECTION)
        .document(vaultId)
        .collection(Vault.QUOTES)
        .document(q.docId)
        .delete();
    return;
  }

  static Future deletePicture(Picture pic, String vaultId) async {
    await Firestore.instance
        .collection(Vault.COLLECTION)
        .document(vaultId)
        .collection(Vault.PICTURES)
        .document(pic.docId)
        .delete();

    await FirebaseStorage.instance.ref().child(pic.photoPath).delete();
    return;
  }

  static Future deleteSong(Songs s, String vaultId) async {
    await Firestore.instance
        .collection(Vault.COLLECTION)
        .document(vaultId)
        .collection(Vault.SONGS)
        .document(s.docId)
        .delete();
    return;
  }

  static Future deleteVideo(Videos v, String vaultId) async {
    await Firestore.instance
        .collection(Vault.COLLECTION)
        .document(vaultId)
        .collection(Vault.VIDEOS)
        .document(v.docId)
        .delete();
    return;
  }
  //===============================================================================

  static Future<String> addPersonalCare(PersonalCare personalCare) async {
    personalCare.updatedAt = DateTime.now();
    DocumentReference ref = await Firestore.instance
        .collection(PersonalCare.COLLECTION)
        .add(personalCare.serialize());
    return ref.documentID;
  }

  static Future<Map<String, String>> uploadStorage({
    @required File image,
    String filePath,
    @required String uid,
    @required Function listener,
  }) async {
    filePath ??= '${PersonalCare.IMAGE_FOLDER}/$uid/${DateTime.now()}';

    StorageUploadTask task =
        FirebaseStorage.instance.ref().child(filePath).putFile(image);

    task.events.listen((event) {
      double percentage = (event.snapshot.bytesTransferred.toDouble() /
              event.snapshot.totalByteCount.toDouble()) *
          100;
      listener(percentage);
    });
    var download = await task.onComplete;
    String url = await download.ref.getDownloadURL();
    return {'url': url, 'path': filePath};
  }

  //================================update functions for mementos======================================
  static Future updatePicture(String vaultId, Picture p) async {
    await Firestore.instance
        .collection(Vault.COLLECTION)
        .document(vaultId)
        .collection(Vault.PICTURES)
        .document(p.docId)
        .setData(p.serialize());
  }

  static Future updateVideo(String vaultId, Videos v) async {
    await Firestore.instance
        .collection(Vault.COLLECTION)
        .document(vaultId)
        .collection(Vault.VIDEOS)
        .document(v.docId)
        .setData(v.serialize());
  }

  static Future updateSong(String vaultId, Songs s) async {
    await Firestore.instance
        .collection(Vault.COLLECTION)
        .document(vaultId)
        .collection(Vault.SONGS)
        .document(s.docId)
        .setData(s.serialize());
  }

  static Future updateQuote(String vaultId, Quotes q) async {
    await Firestore.instance
        .collection(Vault.COLLECTION)
        .document(vaultId)
        .collection(Vault.QUOTES)
        .document(q.docId)
        .setData(q.serialize());
  }

  static Future updateStory(String vaultId, Stories s) async {
    await Firestore.instance
        .collection(Vault.COLLECTION)
        .document(vaultId)
        .collection(Vault.STORIES)
        .document(s.docId)
        .setData(s.serialize());
  }

  //==================================search functions for mementos====================================
  static Future<List<Picture>> searchPics(String vaultId, String key) async {
    QuerySnapshot snapshot = await Firestore.instance
        .collection(Vault.COLLECTION)
        .document(vaultId)
        .collection(Vault.PICTURES)
        .where(Picture.NAME, isEqualTo: key)
        .getDocuments();
    var result = <Picture>[];
    if (snapshot != null && snapshot.documents.length != 0) {
      for (var doc in snapshot.documents) {
        result.add(Picture.deserialize(doc.data, doc.documentID));
      }
    }
    return result;
  }

  static Future<List<Quotes>> searchQuotes(String vaultId, String key) async {
    QuerySnapshot snapshot = await Firestore.instance
        .collection(Vault.COLLECTION)
        .document(vaultId)
        .collection(Vault.QUOTES)
        .where(Quotes.CATEGORY, isEqualTo: key)
        .getDocuments();
    var result = <Quotes>[];
    if (snapshot != null && snapshot.documents.length != 0) {
      for (var doc in snapshot.documents) {
        result.add(Quotes.deserialize(doc.data, doc.documentID));
      }
    }
    return result;
  }

  static Future<List<Songs>> searchSongs(String vaultId, String key) async {
    QuerySnapshot snapshot = await Firestore.instance
        .collection(Vault.COLLECTION)
        .document(vaultId)
        .collection(Vault.SONGS)
        .where(Songs.CATEGORY, isEqualTo: key)
        .getDocuments();
    var result = <Songs>[];
    if (snapshot != null && snapshot.documents.length != 0) {
      for (var doc in snapshot.documents) {
        result.add(Songs.deserialize(doc.data, doc.documentID));
      }
    }
    return result;
  }

  static Future<List<Stories>> searchStories(String vaultId, String key) async {
    QuerySnapshot snapshot = await Firestore.instance
        .collection(Vault.COLLECTION)
        .document(vaultId)
        .collection(Vault.STORIES)
        .where(Stories.TITLE, isEqualTo: key)
        .getDocuments();
    var result = <Stories>[];
    if (snapshot != null && snapshot.documents.length != 0) {
      for (var doc in snapshot.documents) {
        result.add(Stories.deserialize(doc.data, doc.documentID));
      }
    }
    return result;
  }

  static Future<List<Videos>> searchVideos(String vaultId, String key) async {
    QuerySnapshot snapshot = await Firestore.instance
        .collection(Vault.COLLECTION)
        .document(vaultId)
        .collection(Vault.VIDEOS)
        .where(Videos.CATEGORY, isEqualTo: key)
        .getDocuments();
    var result = <Videos>[];
    if (snapshot != null && snapshot.documents.length != 0) {
      for (var doc in snapshot.documents) {
        result.add(Videos.deserialize(doc.data, doc.documentID));
      }
    }
    return result;
  }

  static Future updateContact(Contacts c) async {
    await Firestore.instance
        .collection(Contacts.COLLECTION)
        .document(c.docID)
        .setData(c.serialize());
  }

    static Future<String> addMentalHealth(MentalHealth mentalHealth) async {
    DocumentReference ref = await Firestore.instance
        .collection(MentalHealth.COLLECTION)
        .add(mentalHealth.serialize());
    return ref.documentID;
  }

  static Future<List<MentalHealth>> getMentalHealth(String uid) async {
    QuerySnapshot querySnapshot = await Firestore.instance
        .collection(MentalHealth.COLLECTION)
        .where(MentalHealth.CREATED_BY, isEqualTo: uid)
        .orderBy(MentalHealth.DESCRIPTION)
        .getDocuments();

    var results = <MentalHealth>[];
    if (querySnapshot != null && querySnapshot.documents.length != 0) {
      for (var doc in querySnapshot.documents) {
        results.add(MentalHealth.deserialize(doc.data, doc.documentID));
      }
    }
    return results;
  }

  static Future<void> deleteMentalHealth(String docId) async {
    await Firestore.instance
        .collection(MentalHealth.COLLECTION)
        .document(docId)
        .delete();
  }

  static Future<void> updateMentalHealth(MentalHealth mentalHealth) async {
    await Firestore.instance
        .collection(MentalHealth.COLLECTION)
        .document(mentalHealth.docId)
        .setData(mentalHealth.serialize());
  }

}
