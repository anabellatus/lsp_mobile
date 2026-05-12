import 'package:agen_nusantara/features/login/model/user.dart';
import 'package:agen_nusantara/shared/services/database_service.dart';

class SettingRepository {
  final DatabaseService _databaseService = DatabaseService();

  Future<bool> verifyPassword(String username, String password) async {
    try {
      User? user = await _databaseService.getUserByCredentials(
        username,
        password,
      );
      return user != null;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> changePassword(
    String username,
    String oldPassword,
    String newPassword,
  ) async {
    try {
      bool isCorrect = await verifyPassword(username, oldPassword);

      if (!isCorrect) {
        throw Exception('Password saat ini tidak sesuai');
      }

      int result = await _databaseService.updateUserPassword(
        username,
        newPassword,
      );
      return result > 0;
    } catch (e) {
      rethrow;
    }
  }
}
