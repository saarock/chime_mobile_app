import 'package:chime/features/auth/data/model/user_api_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('UserApiModel', () {
    final userJson = {
      "_id": "123",
      "fullName": "John Doe",
      "userName": "johnny",
      "email": "john@example.com",
      "phoneNumber": "1234567890",
      "profilePicture": "http://example.com/pic.png",
      "age": "30",
      "gender": "Male",
      "relationshipStatus": "Single",
      "active": true,
      "country": "USA",
      "role": "user",
      "v": 1,
      "createdAt": "2023-01-01T00:00:00Z",
      "updatedAt": "2023-01-02T00:00:00Z",
    };

    test('copyWith returns updated UserApiModel', () {
      final user = UserApiModel.fromJson(userJson);

      final updatedUser = user.copyWith(
        fullName: "Jane Doe",
        age: 31,
        active: false,
      );

      expect(updatedUser.fullName, "Jane Doe");
      expect(updatedUser.age, 31);
      expect(updatedUser.active, false);

      // unchanged fields
      expect(updatedUser.id, user.id);
      expect(updatedUser.email, user.email);
    });

    test('Equatable props are considered', () {
      final user1 = UserApiModel.fromJson(userJson);
      final user2 = UserApiModel.fromJson(userJson);

      expect(user1, equals(user2));

      final user3 = user1.copyWith(fullName: "Different");
      expect(user1 == user3, isFalse);
    });
  });
}
