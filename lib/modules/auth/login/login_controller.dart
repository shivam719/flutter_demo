import 'package:flutter_demo/modules/auth/data/auth_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../core/common_controller.dart';
import '../../../core/network/ui_state.dart';
import '../../../core/utils/extensions.dart';
import '../../../route/app_routes.dart';

class LoginController extends GetxController{

  final AuthRepo repo;
  LoginController({required this.repo});

  final mobileNumberController = TextEditingController();
  final passwordController = TextEditingController();
  final isLoading = false.obs;
  final formKey = GlobalKey<FormState>();

  void login() {
    Get.offAllNamed(AppRoutes.dashboard);
    return;
    if (formKey.currentState?.validate() == false) return;

    repo.login(
      {
        "username": mobileNumberController.text.trim(),
        "password": passwordController.text,
        "deviceId": "deviceId",
        "newPassword": null

      },
          (state) {
        isLoading.value = state.isLoading;
        state.handleWithErrorBox(showLoader: false, (data) async {
          TextInput.finishAutofillContext();
          await CommonController.to.setUserData(data);
          Get.offAllNamed(AppRoutes.dashboard);
        });
      },
    );
  }

}