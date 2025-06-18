import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

class HiveService {
  static const String _userBoxKey = 'userBox';
  static const String _currentUserIdKey = 'currentUserId';

  // Initialize Hive
  Future<void> init() async {
    final directory = await getApplicationDocumentsDirectory();
    await Hive.initFlutter(directory.path);
    await Hive.openBox<Map>(_userBoxKey); // To store user data
  }

  // Cache user with their ID and set as current
  Future<void> cacheUser(Map<String, dynamic> userData) async {
    final box = Hive.box<Map>(_userBoxKey);
    final userId = userData['id'];
    if (userId == null) {
      throw Exception('User ID (_id) is required to cache user.');
    }

    await box.put(userId, userData); // Store the user
    await box.put(_currentUserIdKey, {'id': userId}); // Track current user
  }

  // Get the current logged-in user's data
  Map<String, dynamic>? getCachedUser() {
    final box = Hive.box<Map>(_userBoxKey);
    final currentIdMap = box.get(_currentUserIdKey);
    if (currentIdMap == null || !currentIdMap.containsKey('id')) return null;

    final userData = box.get(currentIdMap['id']);
    return userData?.cast<String, dynamic>();
  }

  // Get any user by ID
  Map<String, dynamic>? getUserById(String userId) {
    final box = Hive.box<Map>(_userBoxKey);
    return box.get(userId)?.cast<String, dynamic>();
  }

  // Get all users
  List<Map<String, dynamic>> getAllUsers() {
    final box = Hive.box<Map>(_userBoxKey);
    return box.keys
        .where((key) => key != _currentUserIdKey)
        .map((key) => box.get(key)!.cast<String, dynamic>())
        .toList();
  }

  // Clear the currently logged-in user only
  Future<void> clearCurrentUser() async {
    final box = Hive.box<Map>(_userBoxKey);
    final currentIdMap = box.get(_currentUserIdKey);
    if (currentIdMap != null && currentIdMap.containsKey('id')) {
      await box.delete(currentIdMap['id']); // delete actual user data
      await box.delete(_currentUserIdKey); // remove current user marker
    }
  }

  // Delete a specific user by ID
  Future<void> deleteUserById(String userId) async {
    final box = Hive.box<Map>(_userBoxKey);
    await box.delete(userId);
  }

  // Close the box
  Future<void> close() async {
    await Hive.close();
  }
}
