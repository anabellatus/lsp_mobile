import 'package:agen_nusantara/configs/routes/route.dart';
import 'package:agen_nusantara/features/login/model/user.dart';
import 'package:agen_nusantara/features/login/repositories/login_repository.dart';
import 'package:agen_nusantara/shared/services/user_session_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  static LoginController get to => Get.find();

  var formKey = GlobalKey<FormState>();
  var usernameCtrl = TextEditingController();
  var usernameValue = "".obs;
  var passwordCtrl = TextEditingController();
  var passwordValue = "".obs;
  var isPassword = true.obs;
  var isLoading = false.obs;

  final LoginRepository _loginRepository = LoginRepository();

  Future<void> login() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    isLoading.value = true;

    try {
      String username = usernameCtrl.text.trim();
      String password = passwordCtrl.text;

      var user = await _loginRepository.login(username, password);

      if (user != null) {
        usernameValue.value = username;
        passwordValue.value = password;

        UserSessionService.instance.setUser(user);

        Get.snackbar(
          'Login Successful',
          'Welcome, $username!',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );

        Get.offAllNamed(Routes.home);
      } else {
        bool userExists = await _loginRepository.userExists(username);

        if (userExists) {
          Get.snackbar(
            'Login Failed',
            'Username atau password salah!',
            colorText: Colors.white,
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          );
        } else {
          try {
            bool registered = await _loginRepository.register(
              username,
              password,
            );

            if (registered) {
              usernameValue.value = username;
              passwordValue.value = password;

              User newUser = User(username: username, password: password);
              UserSessionService.instance.setUser(newUser);

              Get.snackbar(
                'Register & Login Successful',
                'Akun baru berhasil dibuat. Selamat datang, $username!',
                backgroundColor: Colors.green,
                colorText: Colors.white,
                duration: const Duration(seconds: 3),
              );

              Get.offAllNamed(Routes.home);
            }
          } catch (e) {
            Get.snackbar(
              'Registration Failed',
              'Error: $e',
              backgroundColor: Colors.red,
              colorText: Colors.white,
              duration: const Duration(seconds: 3),
            );
          }
        }
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Terjadi kesalahan: $e',
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
}
