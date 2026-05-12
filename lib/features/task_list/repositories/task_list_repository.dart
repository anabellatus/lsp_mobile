import 'package:agen_nusantara/features/add_usual_task/models/task.dart';
import 'package:agen_nusantara/shared/services/database_service.dart';

class TaskListRepository {
  final DatabaseService _databaseService = DatabaseService();

  Future<List<Task>> getTasksByUsername(String username) async {
    try {
      final maps = await _databaseService.getTasksByUsername(username);
      return maps.map((map) => Task.fromMap(map)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> updateTaskStatus(int taskId, String newStatus) async {
    try {
      final result = await _databaseService.updateTaskStatus(taskId, newStatus);
      return result > 0;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> deleteTask(int taskId) async {
    try {
      final result = await _databaseService.deleteTask(taskId);
      return result > 0;
    } catch (e) {
      rethrow;
    }
  }
}
