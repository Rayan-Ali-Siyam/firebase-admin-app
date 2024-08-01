import 'package:flutter/material.dart';
import 'package:fire_admin_app2/models/item_model.dart';
import 'package:fire_admin_app2/services/firestore_service.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:sizer/sizer.dart';

class FirestoreItemsPage extends StatefulWidget {
  const FirestoreItemsPage({super.key});

  @override
  State<FirestoreItemsPage> createState() => _FirestoreItemsPageState();
}

class _FirestoreItemsPageState extends State<FirestoreItemsPage> {
  @override
  void initState() {
    // // Fetching items for page open.
    // FirestoreService().fetchItems().then((items) {
    //   setState(() {
    //     items = items;
    //   });
    // });

    // listener for Firestore items update.
    // FirebaseFirestore.instance
    //     .collection("items")
    //     .snapshots()
    //     .listen((records) {
    //   setState(() {
    //     items = FirestoreService().mapItems(records);
    //   });
    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Firestore Items"),
        centerTitle: false,
      ),
      body: FirestoreListView<ItemModel>(
        query: FirestoreService().fetchItems(),
        itemBuilder: (context, snapshot) {
          ItemModel item = snapshot.data();

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
              title: Text(item.name ?? "Null"),
              subtitle: Text(item.quantity ?? ''),
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
        tooltip: "Add Item",
        onPressed: showItemDialog,
        child: const Icon(
          Icons.add,
        ),
      ),
    );
  }

  // showingDialog for creating Item.
  showItemDialog() {
    TextEditingController nameController = TextEditingController();
    TextEditingController quantityController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Container(
            height: 40.h,
            width: 30.w,
            padding: EdgeInsets.all(5.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Item details"),
                TextField(
                  controller: nameController,
                ),
                TextField(
                  controller: quantityController,
                ),
                TextButton(
                  onPressed: () {
                    var name = nameController.text.trim();
                    var quantity = quantityController.text.trim();
                    FirestoreService().addItem(name, quantity);
                    Navigator.pop(context);
                  },
                  child: const Text("Add"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
