import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fire_admin_app2/models/image_model.dart';
import 'package:fire_admin_app2/services/firestore_service.dart';
import 'package:fire_admin_app2/services/storage_service.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:sizer/sizer.dart';

class StorageItemsPage extends StatelessWidget {
  const StorageItemsPage({super.key});

  @override
  Widget build(BuildContext context) {
    StorageService storage = StorageService();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Storage Items"),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: FirestoreQueryBuilder<ImageModel>(
          query: FirestoreService().fetchImages(),
          builder: (context, snapshot, _) {
            if (snapshot.isFetching) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Text('error ${snapshot.error}');
            }
            return Padding(
              padding: EdgeInsets.all(2.w),
              child: Wrap(
                alignment: WrapAlignment.start,
                runAlignment: WrapAlignment.center,
                spacing: 10,
                runSpacing: 20,
                children: [
                  for (QueryDocumentSnapshot<ImageModel> image in snapshot.docs)
                    FutureBuilder(
                      future: storage.downloadUrl(image.data().name),
                      builder: (context, AsyncSnapshot<String> snapshot) {
                        if (snapshot.connectionState == ConnectionState.done &&
                            snapshot.hasData) {
                          return Container(
                            height: 30.h,
                            width: 22.w,
                            color: Colors.grey[200],
                            child: Image.network(
                              snapshot.data!,
                              fit: BoxFit.contain,
                            ),
                          );
                        }
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Container(
                            height: 30.h,
                            width: 22.w,
                            alignment: Alignment.center,
                            child: const LinearProgressIndicator(),
                          );
                        }
                        return Container();
                      },
                    ),
                ],
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: "Add Item",
        onPressed: () async {
          final results = await FilePicker.platform.pickFiles(
            allowMultiple: false,
            type: FileType.custom,
            allowedExtensions: ["png", "jpg"],
          );

          if (results == null) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("No file selected"),
                ),
              );
            }
            return;
          }

          Uint8List fileBytes = results.files.first.bytes!;
          String fileName = results.files.first.name;

          storage.uploadFilefromWeb(fileName, fileBytes);
        },
        child: const Icon(
          Icons.add,
        ),
      ),
    );
  }
}
