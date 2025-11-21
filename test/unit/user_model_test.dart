import 'package:flutter_test/flutter_test.dart';
import 'package:shop_flutter/data/models/user_model.dart';

void main() {
  group('UserModel', () {
    test('should create UserModel with all fields', () {
      const user = UserModel(
        uid: '123',
        email: 'test@example.com',
        displayName: 'Test User',
      );

      expect(user.uid, '123');
      expect(user.email, 'test@example.com');
      expect(user.displayName, 'Test User');
    });

    test('should create UserModel from JSON', () {
      final json = {
        'uid': '123',
        'email': 'test@example.com',
        'displayName': 'Test User',
      };

      final user = UserModel.fromJson(json);

      expect(user.uid, '123');
      expect(user.email, 'test@example.com');
      expect(user.displayName, 'Test User');
    });

    test('should convert UserModel to JSON', () {
      const user = UserModel(
        uid: '123',
        email: 'test@example.com',
        displayName: 'Test User',
      );

      final json = user.toJson();

      expect(json['uid'], '123');
      expect(json['email'], 'test@example.com');
      expect(json['displayName'], 'Test User');
    });

    test('should support equality comparison', () {
      const user1 = UserModel(
        uid: '123',
        email: 'test@example.com',
        displayName: 'Test User',
      );

      const user2 = UserModel(
        uid: '123',
        email: 'test@example.com',
        displayName: 'Test User',
      );

      expect(user1, equals(user2));
    });
  });
}
