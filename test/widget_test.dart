import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:flutter_demo/main.dart';
import 'package:flutter_demo/core/common_controller.dart';
import 'package:flutter_demo/core/managers/storage_manager.dart';

void main() {
  testWidgets('BillKart app smoke test', (WidgetTester tester) async {
    TestWidgetsFlutterBinding.ensureInitialized();
    try {
      await StorageManager.init();
    } catch (_) {}
    if (!Get.isRegistered<CommonController>()) {
      Get.put(CommonController());
    }

    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that BillKart app starts up successfully.
    expect(find.byType(MyApp), findsOneWidget);
  });
}
