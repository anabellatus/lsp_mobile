import 'package:agen_nusantara/features/add_usual_task/repositories/add_usual_task_repository.dart';
import 'package:agen_nusantara/shared/services/user_session_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddUsualTaskController extends GetxController {
  static AddUsualTaskController get to => Get.find();

  late UserSessionService _userSessionService;
  final AddUsualTaskRepository _addUsualTaskRepository =
      AddUsualTaskRepository();

  var formKey = GlobalKey<FormState>();
  var selectedDate = Rx<DateTime?>(null);
  var titleCtrl = TextEditingController();
  var descriptionCtrl = TextEditingController();
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _userSessionService = UserSessionService.instance;
  }

  Future<void> addTask() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    if (selectedDate.value == null) {
      Get.snackbar(
        'Error',
        'Silahkan pilih tanggal jatuh tempo',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isLoading.value = true;

    try {
      String? username = _userSessionService.username;
      if (username == null) {
        throw Exception('User tidak login');
      }

      String dueDate =
          '${selectedDate.value!.day} ${_getMonthName(selectedDate.value!.month)} ${selectedDate.value!.year}';
      String title = titleCtrl.text;
      String description = descriptionCtrl.text;

      bool success = await _addUsualTaskRepository.addTask(
        username,
        title,
        dueDate,
        description,
      );

      if (success) {
        Get.snackbar(
          'Sukses',
          'Tugas berhasil ditambahkan',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 5),
          snackPosition: SnackPosition.BOTTOM,
        );

        await Future.delayed(const Duration(milliseconds: 800));

        selectedDate.value = null;
        titleCtrl.clear();
        descriptionCtrl.clear();
        Get.back();
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal menambahkan tugas: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate.value ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (picked != null && picked != selectedDate.value) {
      selectedDate.value = picked;
    }
  }

  String _getMonthName(int month) {
    const months = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];
    return months[month - 1];
  }

  @override
  void dispose() {
    titleCtrl.dispose();
    descriptionCtrl.dispose();
    super.dispose();
  }
}
