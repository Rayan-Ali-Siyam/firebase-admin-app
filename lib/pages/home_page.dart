import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fire_admin_app2/controllers/home_page_ctrl.dart';
import 'package:fire_admin_app2/pages/firestore_items_page.dart';
import 'package:fire_admin_app2/pages/storage_items_page.dart';
import 'package:fire_admin_app2/pages/users_list_page.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  StreamSubscription<User?>? listener;
  @override
  void initState() {
    listener = FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        Navigator.of(context).pushNamedAndRemoveUntil(
          "/sign-in",
          (Route<dynamic> route) => false,
        );
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    listener!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final HomePageCtrl ctrl = Get.put(HomePageCtrl());

    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin DashBoard"),
      ),
      body: Row(
        children: [
          Obx(
            () => NavigationRail(
              onDestinationSelected: (index) =>
                  ctrl.onDestinationSelected(index),
              trailing: IconButton(
                icon: const Icon(Icons.logout),
                tooltip: "Logout",
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                },
              ),
              labelType: NavigationRailLabelType.selected,
              destinations: const [
                NavigationRailDestination(
                  icon: Icon(Icons.people_outline),
                  label: Text("Users"),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.storage_outlined),
                  label: Text("Firestore"),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.image_outlined),
                  label: Text("Storage"),
                ),
              ],
              selectedIndex: ctrl.selectedIndex.value,
            ),
          ),
          Expanded(
            child: PageView(
              controller: ctrl.pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: const [
                UsersListPage(),
                FirestoreItemsPage(),
                StorageItemsPage(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
