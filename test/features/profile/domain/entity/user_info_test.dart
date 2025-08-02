import 'package:chime/features/profile/domain/entity/user_info.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('UserInfo', () {
    test('copyWith returns a new UserInfo with updated fields', () {
      final original = UserInfo(
        id: '123',
        age: '25',
        userName: 'oldName',
        phoneNumber: '1234567890',
        country: 'USA',
        gender: 'Male',
        relationshipStatus: 'Single',
      );

      final copy = original.copyWith(
        age: '26',
        userName: 'newName',
        country: 'Canada',
      );

      // Check that the copy has updated fields
      expect(copy.age, '26');
      expect(copy.userName, 'newName');
      expect(copy.country, 'Canada');

      // Check that other fields are unchanged
      expect(copy.id, original.id);
      expect(copy.phoneNumber, original.phoneNumber);
      expect(copy.gender, original.gender);
      expect(copy.relationshipStatus, original.relationshipStatus);

      // Check original remains unchanged
      expect(original.age, '25');
      expect(original.userName, 'oldName');
      expect(original.country, 'USA');
    });

    test('copyWith without parameters returns identical UserInfo', () {
      final original = UserInfo(
        id: '123',
        age: '25',
        userName: 'user',
        phoneNumber: '1234567890',
        country: 'USA',
        gender: 'Female',
        relationshipStatus: 'Married',
      );

      final copy = original.copyWith();

      expect(copy.id, original.id);
      expect(copy.age, original.age);
      expect(copy.userName, original.userName);
      expect(copy.phoneNumber, original.phoneNumber);
      expect(copy.country, original.country);
      expect(copy.gender, original.gender);
      expect(copy.relationshipStatus, original.relationshipStatus);

      expect(
        identical(copy, original),
        isFalse,
      ); // Should be different instances
    });
  });
}
