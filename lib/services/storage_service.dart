import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:fire_admin_app2/constants/storage_collections.dart';
import 'package:fire_admin_app2/services/firestore_service.dart';

class StorageService {
  final FirebaseStorage _instance = FirebaseStorage.instance;

  Future<ListResult> listFiles() async {
    ListResult results = await _instance.ref(StorageFolders.test).listAll();

    return results;
  }

  Future<void> uploadFilefromWeb(
    String fileName,
    Uint8List fileBytes,
  ) async {
    // File file = File(filePath);

    try {
      await _instance
          .ref('${StorageFolders.test}/$fileName')
          .putData(fileBytes);

      FirestoreService().addImage(
          fileName, '${_instance.bucket + StorageFolders.test}/$fileName');
    } on FirebaseException catch (e) {
      print(e);
    }
  }

  Future<String> downloadUrl(String imageName) async {
    String downloadUrl = await _instance
        .ref("${StorageFolders.test}/$imageName")
        .getDownloadURL();

    return downloadUrl;
  }
}
