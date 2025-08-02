import 'package:chime/app/shared_pref/cooki_cache.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('CookieCache', () {
    const cookieValue = 'my_cookie=12345';
    const tokenValue = 'access_token_xyz';

    setUp(() {
      // Set initial mock values (optional, could be empty)
      SharedPreferences.setMockInitialValues({});
    });

    test('should save and retrieve cookie', () async {
      await CookieCache.saveCookie(cookieValue);
      final cookie = await CookieCache.getCookie();

      expect(cookie, equals(cookieValue));
    });

    test('should save and retrieve access token', () async {
      await CookieCache.saveAccessToken(tokenValue);
      final token = await CookieCache.getAccessToken();

      expect(token, equals(tokenValue));
    });

    test('should clear both cookie and token', () async {
      await CookieCache.saveCookie(cookieValue);
      await CookieCache.saveAccessToken(tokenValue);

      await CookieCache.clearAll();

      final cookie = await CookieCache.getCookie();
      final token = await CookieCache.getAccessToken();

      expect(cookie, isNull);
      expect(token, isNull);
    });
  });
}
