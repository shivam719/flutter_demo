import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'home_screen.dart';
import 'transaction_screen.dart';
import 'bill_kart_screen.dart';
import 'rewards_screen.dart';
import 'profile_screen.dart';

class DashboardController extends GetxController with GetTickerProviderStateMixin {
  var currentIndex = 0.obs;
  var homeAnimationKey = 0.obs;

  late AnimationController badgeController;
  late Animation<double> bounceAnim;
  late Animation<double> scaleAnim;

  @override
  void onInit() {
    super.onInit();
    badgeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    bounceAnim = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 0.0, end: -14.0), weight: 35),
      TweenSequenceItem(tween: Tween<double>(begin: -14.0, end: 3.0), weight: 35),
      TweenSequenceItem(tween: Tween<double>(begin: 3.0, end: 0.0), weight: 30),
    ]).animate(CurvedAnimation(parent: badgeController, curve: Curves.easeInOut));

    scaleAnim = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 1.3), weight: 35),
      TweenSequenceItem(tween: Tween<double>(begin: 1.3, end: 0.9), weight: 35),
      TweenSequenceItem(tween: Tween<double>(begin: 0.9, end: 1.0), weight: 30),
    ]).animate(CurvedAnimation(parent: badgeController, curve: Curves.easeInOut));

    // Play on init
    badgeController.forward(from: 0.0);
  }

  final List<Widget> pages = [
    const HomeScreen(),
    const TransactionScreen(),
    const BillKartScreen(),
    const RewardsScreen(),
    const ProfileScreen(),
  ];

  void changeIndex(int index) {
    currentIndex.value = index;
    if (index == 0) {
      homeAnimationKey.value++;
    }
    badgeController.forward(from: 0.0);
  }

  @override
  void onClose() {
    badgeController.dispose();
    super.onClose();
  }
}
