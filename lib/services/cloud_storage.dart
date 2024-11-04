import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class CloudStorageServices {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> uploadImage(File image) async {
    try {
      String fileName =
          'profilePictures/${DateTime.now().millisecondsSinceEpoch}.jpg';
      UploadTask uploadTask = _storage.ref().child(fileName).putFile(image);
      TaskSnapshot snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      throw Exception('Error uploading image: $e');
    }
  }
}
