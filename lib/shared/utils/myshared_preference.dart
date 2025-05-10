import 'package:shared_preferences/shared_preferences.dart';
import 'package:encrypt/encrypt.dart';
class MysharedPreference {
  static Key? _key;
  static final _iv = IV.fromLength(16);

    static Key _getSessionKey() {
    _key ??= Key.fromSecureRandom(32);
      return _key!;
    }


  Future<String?> getPreferences(String key) async{
     
    final pref = await SharedPreferences.getInstance();
     final encryptedToken  = pref.getString(key);
     if (encryptedToken == null || _key == null) return '';

    try {
      final encrypter = Encrypter(AES(_key!));
      final decrypted = encrypter.decrypt(Encrypted.fromBase64(encryptedToken), iv: _iv);
      return decrypted;
    } catch (e) {
      print('Decryption error: $e');
      return '';
    }
  }

  Future<void> setPreferences(String key, String value) async{
    final s_key = _getSessionKey();
    final encrypter = Encrypter(AES(s_key));
    final encrypted = encrypter.encrypt(value, iv: _iv);
    final pref = await SharedPreferences.getInstance();
   await pref.setString(key, encrypted.base64);
  }

  Future<int?> getPreferencesI(String key) async{
    final pref = await SharedPreferences.getInstance();
    return pref.getInt(key);
  }

  Future<void> setPreferencesI(String key, int value) async{
    final pref = await SharedPreferences.getInstance();
   await pref.setInt(key, value);
  }

 Future<String?> getPreferencesWithoutEncrpytion(String key) async{
    final pref = await SharedPreferences.getInstance();
    return pref.getString(key);
  }

  Future<void> setPreferencesWithoutEncrpytion(String key, String value) async{
    final pref = await SharedPreferences.getInstance();
   await pref.setString(key, value);
  }

  Future<void> clearPreference() async{
  final pref =  await SharedPreferences.getInstance();
  await pref.clear();
  }
}