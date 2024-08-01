import 'package:flutter/material.dart';
import 'package:fire_admin_app2/models/user_model.dart';
import 'package:fire_admin_app2/services/firestore_service.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutterfire_ui/firestore.dart';

class UsersListPage extends StatelessWidget {
  const UsersListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Firestore Items"),
        centerTitle: false,
      ),
      body: FirestoreListView<UserModel>(
        query: FirestoreService().fetchUsers(),
        itemBuilder: (context, snapshot) {
          UserModel item = snapshot.data();

          return Slidable(
            endActionPane: ActionPane(
              motion: const ScrollMotion(),
              children: [
                SlidableAction(
                  onPressed: (c) {
                    FirestoreService().deleteItem(snapshot.id);
                  },
                  backgroundColor: Colors.red,
                  icon: Icons.delete,
                  label: "Delete",
                  spacing: 8,
                ),
              ],
            ),
            child: ListTile(
              title: Text(item.email),
              subtitle: Text("isAdmin: ${item.isAdmin.toString()}"),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return const Center(
            child: Text("Error"),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: "Add Admin",
        onPressed: () {},
        child: const Icon(
          Icons.add,
        ),
      ),
    );
  }
}
