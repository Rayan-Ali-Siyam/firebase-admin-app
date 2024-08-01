import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:fire_admin_app2/constants/firestore_collections.dart';
import 'package:fire_admin_app2/models/image_model.dart';
import 'package:fire_admin_app2/models/item_model.dart';
import 'package:fire_admin_app2/models/user_model.dart';

class FirestoreService {
  final FirebaseFirestore _instance = FirebaseFirestore.instance;

  Query<UserModel> fetchUsers() {
    Query<UserModel> users = _instance
        .collection(FirestoreCollections.users)
        // .where(UserFields.isAdmin, isNotEqualTo: true)
        .withConverter<UserModel>(
          fromFirestore: (snapshot, _) => UserModel.fromJson(snapshot.data()!),
          toFirestore: (user, _) => user.toJson(),
        )
        .orderBy(UserFields.isAdmin);
    return users;
  }

  Future<bool> isAdmin(String email) async {
    QuerySnapshot<UserModel> user = await _instance
        .collection(FirestoreCollections.users)
        .where(UserFields.email, isEqualTo: email)
        .where(UserFields.isAdmin, isEqualTo: true)
        .withConverter<UserModel>(
          fromFirestore: (snapshot, _) => UserModel.fromJson(snapshot.data()!),
          toFirestore: (user, _) => user.toJson(),
        )
        .get();

    return user.docs.isNotEmpty;
  }

  addUser(String email) {
    UserModel user = UserModel(email: email, isAdmin: false);
    _instance.collection(FirestoreCollections.users).add(user.toJson());
  }

  deleteUser(String email) {
    _instance.collection(FirestoreCollections.users).doc(email).delete();
  }

  Query<ItemModel> fetchItems() {
    Query<ItemModel> items = _instance
        .collection(FirestoreCollections.items)
        .withConverter<ItemModel>(
          fromFirestore: (snapshot, _) => ItemModel.fromJson(snapshot.data()!),
          toFirestore: (item, _) => item.toJson(),
        )
        .orderBy(ItemFields.name);
    return items;
  }

  addItem(String name, String quantity) {
    ItemModel item = ItemModel(name: name, quantity: quantity);
    _instance.collection(FirestoreCollections.items).add(item.toJson());
  }

  deleteItem(String id) {
    _instance.collection(FirestoreCollections.items).doc(id).delete();
  }

  Query<ImageModel> fetchImages() {
    Query<ImageModel> images = _instance
        .collection(FirestoreCollections.images)
        .withConverter<ImageModel>(
          fromFirestore: (snapshot, _) => ImageModel.fromJson(snapshot.data()!),
          toFirestore: (image, _) => image.toJson(),
        )
        .orderBy(ImageFields.name);
    return images;
  }

  addImage(String name, String url) {
    ImageModel image = ImageModel(name: name, url: url);
    _instance.collection(FirestoreCollections.images).add(image.toJson());
  }

  deleteImage(String id) {
    _instance.collection(FirestoreCollections.images).doc(id).delete();
  }
}
