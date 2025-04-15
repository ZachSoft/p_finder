// lib/repositories/firebase_repository.dart
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:p_finder/Models/PropertyModel.dart';
import 'package:p_finder/Models/UserModel.dart';


class FirebaseRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

    // Authentication Methods
    Future<UserCredential> signUp(String email, String password) async {
      try {
        return await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
      } catch (e) {
        _showErrorSnackbar("Sign Up Failed: ${e.toString()}");
        rethrow;
      }
    }

    Future<UserCredential> login(String email, String password) async {
      try {
        return await _auth.signInWithEmailAndPassword(
            email: email, password: password);
      } catch (e) {
        _showErrorSnackbar("Login Failed: ${e.toString()}");
        rethrow;
      }
    }

    Future<void> logout() async {
      try {
        return await _auth.signOut();
      } catch (e) {
        _showErrorSnackbar("Logout Failed: ${e.toString()}");
        rethrow;
      }
    }

    // Firestore Methods for Users
    Future<void> createUser(UserModel user) async {
      try {
        await _firestore.collection('users').doc(user.uid).set(user.toJson());
      } catch (e) {
        _showErrorSnackbar("Create User Failed: ${e.toString()}");
        rethrow;
      }
    }

    Future<UserModel> getUser(String uid) async {
      try {
        DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();
        return UserModel.fromJson(doc.data() as Map<String, dynamic>);
      } catch (e) {
        _showErrorSnackbar("Get User Failed: ${e.toString()}");
        rethrow;
      }
    }

    // Firestore Methods for Properties
    Future<void> createProperty(PropertyModel property) async {
      try {
        await _firestore
            .collection('properties')
            .doc(property.id)
            .set(property.toJson());
      } catch (e) {
        _showErrorSnackbar("Create Property Failed: ${e.toString()}");
        rethrow;
      }
    }

    Future<List<PropertyModel>> getProperties() async {
      try {
        QuerySnapshot snapshot = await _firestore.collection('properties').get();
        return snapshot.docs
            .map(
                (doc) => PropertyModel.fromJson(doc.data() as Map<String, dynamic>))
            .toList();
      } catch (e) {
        _showErrorSnackbar("Get Properties Failed: ${e.toString()}");
        rethrow;
      }
    }

    // // Firebase Storage for Image Uploads
    // // Upload an image (in Base64) and return the download URL.
    // Future<String> uploadImage(String base64Image, String fileName) async {
    //   try {
    //     final ref = _storage.ref().child("images/$fileName");
    //     var bytes = base64Decode(base64Image);
    //     await ref.putData(bytes);
    //     return await ref.getDownloadURL();
    //   } catch (e) {
    //     _showErrorSnackbar("Upload Image Failed: ${e.toString()}");
    //     rethrow;
    //   }
    // }

    void _showErrorSnackbar(String message) {
      // Implement your snackbar here. For example, using Flutter's ScaffoldMessenger:
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
        ),
      );
    }
}