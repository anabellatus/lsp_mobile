import 'package:agen_nusantara/features/add_usual_task/models/task.dart';
import 'package:agen_nusantara/features/task_list/repositories/task_list_repository.dart';
import 'package:agen_nusantara/shared/services/user_session_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TaskListController extends GetxController {
  static TaskListController get to => Get.find();

  late UserSessionService _userSessionService;
  final TaskListRepository _taskListRepository = TaskListRepository();

  var tasks = <Task>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _userSessionService = UserSessionService.instance;
    loadTasks();
  }

  Future<void> loadTasks() async {
    isLoading.value = true;
    try {
      String? username = _userSessionService.username;
      if (username == null) {
        throw Exception('User tidak login');
      }

      final taskList = await _taskListRepository.getTasksByUsername(username);
      tasks.value = taskList;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal memuat tugas: $e',
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 2),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> toggleTaskStatus(Task task) async {
    try {
      String newStatus = task.status == 'pending' ? 'completed' : 'pending';
      bool success = await _taskListRepository.updateTaskStatus(
        task.id!,
        newStatus,
      );

      if (success) {
        final index = tasks.indexWhere((t) => t.id == task.id);
        if (index >= 0) {
          final updatedTask = Task(
            id: task.id,
            username: task.username,
            title: task.title,
            description: task.description,
            dueDate: task.dueDate,
            taskType: task.taskType,
            status: newStatus,
            createdAt: task.createdAt,
          );
          tasks[index] = updatedTask;
        }

        Get.snackbar(
          'Success',
          newStatus == 'completed'
              ? 'Tugas ditandai selesai'
              : 'Tugas ditandai belum selesai',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 1),
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal mengubah status tugas: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    }
  }

  Future<void> deleteTaskItem(Task task) async {
    try {
      bool success = await _taskListRepository.deleteTask(task.id!);

      if (success) {
        tasks.removeWhere((t) => t.id == task.id);
        Get.snackbar(
          'Success',
          'Tugas berhasil dihapus',
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 1),
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal menghapus tugas: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    }
  }
}
