import 'package:agen_nusantara/features/login/model/user.dart';
import 'package:agen_nusantara/shared/services/database_service.dart';
import 'package:get/get.dart';

class UserSessionService extends GetxService {
  static UserSessionService get instance => Get.find();

  late DatabaseService _databaseService;
  final Rx<User?> _currentUser = Rx<User?>(null);

  User? get currentUser => _currentUser.value;
  String? get username => _currentUser.value?.username;
  bool get isLoggedIn => _currentUser.value != null;

  Future<void> initialize() async {
    _databaseService = DatabaseService();
    await _loadUserFromDatabase();
  }

  Future<void> _loadUserFromDatabase() async {
    try {
      User? user = await _databaseService.getFirstUser();
      if (user != null) {
        _currentUser.value = user;
      }
    } catch (e) {
      print('Error loading user from database: $e');
    }
  }

  Future<void> setUser(User user) async {
    _currentUser.value = user;
  }

  Future<void> clearUser() async {
    _currentUser.value = null;
  }

  User? getUser() {
    return _currentUser.value;
  }
}
