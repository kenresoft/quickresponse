import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:quickresponse/utils/extensions.dart';

Future<String> uploadFileToStorage(File file, String storagePath, String fileName) async {
  try {
    Reference storageReference = FirebaseStorage.instance.ref(storagePath + fileName);

    UploadTask uploadTask = storageReference.putFile(file);

    await uploadTask.whenComplete(() => null);

    String downloadUrl = await storageReference.getDownloadURL();

    return downloadUrl;
  } catch (e) {
    print("Error uploading file: $e");
    return "";
  }
}

Future<void> addMediaMetadataToFirestore(String userId, String mediaType, String mediaUrl, String fileName) async {
  try {
    await FirebaseFirestore.instance.collection('media').doc(userId).collection(mediaType).doc(fileName).set({
      'url': mediaUrl,
      'name': fileName,
      'timestamp': FieldValue.serverTimestamp(),
    });
  } catch (e) {
    print("Error adding media metadata to Firestore: $e");
  }
}

Stream<QuerySnapshot> fetchMediaMetadataFromFirestore(String userId, String mediaType, int limit) {
  return FirebaseFirestore.instance.collection('media').doc(userId).collection(mediaType).orderBy('timestamp', descending: true).limit(limit).snapshots();
}

Future<void> updateMediaMetadataInFirestore(String userId, String mediaType, String documentId, Map<String, dynamic> data) async {
  try {
    await FirebaseFirestore.instance.collection('media').doc(userId).collection(mediaType).doc(documentId).update(data);
  } catch (e) {
    print("Error updating media metadata in Firestore: $e");
  }
}

Future<void> deleteMedia(String userId, String mediaType, String documentId) async {
  try {
    // Delete the media file from Firebase Storage
    await FirebaseStorage.instance.ref('media/$userId/$mediaType/$documentId'.log).delete();

    // Delete the media metadata from Firestore
    await FirebaseFirestore.instance.collection('media').doc(userId).collection(mediaType).doc(documentId).delete();
  } catch (e) {
    print("Error deleting media: $e");
  }
}
