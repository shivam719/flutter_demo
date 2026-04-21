import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';



class DashboardController extends GetxController{
  var currentIndex = 0.obs;
  final List<Widget> pages = [/*HomeScreen(), ProfileScreen()*/];

  void changeIndex(int index) {
    currentIndex.value = index;
  }

  @override
  void onReady() {
    super.onReady();
  }



  @override
  void onClose() {
    super.onClose();
  }
}