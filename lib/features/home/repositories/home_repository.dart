import 'package:agen_nusantara/features/login/model/user.dart';
import 'package:agen_nusantara/shared/services/database_service.dart';

class HomeRepository {
 
 final DatabaseService _databaseService = DatabaseService();

  Future<User?> getUser(String username) async {
    try {
      return await _databaseService.getUserByUsername(username);
    } catch (e) {
      rethrow;
    }
  }
}