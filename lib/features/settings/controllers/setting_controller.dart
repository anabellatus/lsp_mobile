import 'package:agen_nusantara/configs/routes/route.dart';
import 'package:agen_nusantara/features/settings/repositories/setting_repository.dart';
import 'package:agen_nusantara/shared/services/user_session_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingController extends GetxController {
  static SettingController get to => Get.find();

  late UserSessionService _userSessionService;
  final SettingRepository _settingRepository = SettingRepository();

  var formKey = GlobalKey<FormState>();
  var currentPasswordCtrl = TextEditingController();
  var currentPasswordValue = "".obs;
  var newPasswordCtrl = TextEditingController();
  var newPasswordValue = "".obs;
  var isPassword = true.obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _userSessionService = UserSessionService.instance;
  }

  Future<void> changePassword() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    isLoading.value = true;

    try {
      String? username = _userSessionService.username;
      if (username == null) {
        throw Exception('User tidak login');
      }

      String currentPassword = currentPasswordCtrl.text;
      String newPassword = newPasswordCtrl.text;

      bool success = await _settingRepository.changePassword(
        username,
        currentPassword,
        newPassword,
      );

      if (success) {
        Get.snackbar(
          'Success',
          'Password berhasil diubah',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );

        currentPasswordCtrl.clear();
        newPasswordCtrl.clear();
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal mengubah password: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    } finally {
      isLoading.value = false;
    }
  }

  void toggleShowPassword() {
    if (isPassword.value == true) {
      isPassword.value = false;
    } else {
      isPassword.value = true;
    }
  }

  Future<void> logout() async {
    await _userSessionService.clearUser();
    Get.offAllNamed(Routes.login);
  }

  @override
  void dispose() {
    currentPasswordCtrl.dispose();
    newPasswordCtrl.dispose();
    super.dispose();
  }
}
