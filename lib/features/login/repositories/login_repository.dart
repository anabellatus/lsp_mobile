import 'package:agen_nusantara/features/login/model/user.dart';
import 'package:agen_nusantara/shared/services/database_service.dart';

class LoginRepository {
  final DatabaseService _databaseService = DatabaseService();

  Future<bool> register(String username, String password) async {
    try {
      User? existingUser = await _databaseService.getUserByUsername(username);
      if (existingUser != null) {
        throw Exception('Username sudah terdaftar');
      }

      User newUser = User(username: username, password: password);
      int result = await _databaseService.insertUser(newUser);
      return result > 0;
    } catch (e) {
      rethrow;
    }
  }

  Future<User?> login(String username, String password) async {
    try {
      User? user = await _databaseService.getUserByCredentials(
        username,
        password,
      );
      return user;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> userExists(String username) async {
    try {
      User? user = await _databaseService.getUserByUsername(username);
      return user != null;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> updatePassword(String username, String newPassword) async {
    try {
      int result = await _databaseService.updateUserPassword(
        username,
        newPassword,
      );
      return result > 0;
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
