import 'package:agen_nusantara/features/login/model/user.dart';
import 'package:agen_nusantara/shared/services/database_service.dart';

class AddImportantTaskRepository {
  final DatabaseService _databaseService = DatabaseService();

  Future<bool> addTask(
    String username,
    String title,
    String dueDate,
    String description,
  ) async {
    try {
      await _databaseService.insertTask(
        username,
        title,
        description,
        dueDate,
        taskType: 'PENTING',
      );
      return true;
    } catch (e) {
      rethrow;
    }
  }

  Future<User?> getUser(String username) async {
    try {
      return await _databaseService.getUserByUsername(username);
    } catch (e) {
      rethrow;
    }
  }
}
