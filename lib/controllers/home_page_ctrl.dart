import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';

class HomePageCtrl extends GetxController {
  RxInt selectedIndex = 0.obs;
  PageController pageController = PageController();

  onDestinationSelected(int index) {
    selectedIndex.value = index;
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 500),
      curve: Curves.fastOutSlowIn,
    );
  }
}
