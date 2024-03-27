import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class RecommendedService {
  Future<String?> uploadImageToFirebase(File imageFile) async {
    try {
      final path = 'place_images/${DateTime.now()}.png';
      final file = File(imageFile.path);
      final ref = firebase_storage.FirebaseStorage.instance.ref().child(path);
      await ref.putFile(file);
      final url = await ref.getDownloadURL();
      return url;
    } catch (e) {
      ('Error uploading image to firebase storage: $e');
      return null;
    }
  }

  Future<void> createRecommendation(Map<String, dynamic> recommendation) async {
    try {
      await FirebaseFirestore.instance
          .collection('Recommendations')
          .add(recommendation);
    } catch (e) {
      ('Error creating recommendation: $e');
    }
  }

  Future<void> updatePlace(placeId, updatedPlace) async {
    try {
      await FirebaseFirestore.instance
          .collection('Recommendations')
          .doc(placeId)
          .update(updatedPlace.toJson());
    } catch (e) {
      print('Error updating place: $e');
    }
  }
}
