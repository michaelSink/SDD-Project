import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class aboutMedthods {
  bool isLoggedIn() {
    if (FirebaseAuth.instance.currentUser() != null) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> addData(aboutData) async {
    if (isLoggedIn()) {
      Firestore.instance.collection('aboutUs').add(aboutData).catchError((e) {
        print(e);
      });

      // Firestore.instance.runTransaction((Transaction noteTransaction) async {
      //   CollectionReference reference =
      //       await Firestore.instance.collection('notes');

      //   reference.add(noteData);
      // });
    } else {
      print('You need to be logged in');
    }
  }

  getData() async {
    return await Firestore.instance.collection('aboutUs').snapshots();
  }

  updateData(selectedDoc, newValues) {
    Firestore.instance
        .collection('aboutUs')
        .document(selectedDoc)
        .updateData(newValues)
        .catchError((e) {
      print(e);
    });
  }

  deleteData(docId) {
    Firestore.instance
        .collection('aboutUs')
        .document(docId)
        .delete()
        .catchError((e) {
      print(e);
    });
  }
}
