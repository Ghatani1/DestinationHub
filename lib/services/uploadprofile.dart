import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class Profile {
  Future<String?> uploadProfileToFirebase(File imageFile) async {
    try {
      final path = 'profile/${DateTime.now()}.png';
      final file = File(imageFile.path);
      final ref = firebase_storage.FirebaseStorage.instance.ref().child(path);
      await ref.putFile(file);
      final url = await ref.getDownloadURL();
      return url;
    } catch (e) {
      print('Error Uploading image to Firebase Storage: $e');
      return null;
    }
  }
}
