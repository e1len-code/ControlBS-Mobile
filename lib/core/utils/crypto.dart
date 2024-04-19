import 'package:controlbs_mobile/core/constants/key.dart';
import 'package:encrypt/encrypt.dart';

String decrypt(Encrypted encryptedData) {
  final key = Key.fromUtf8(keyString);
  final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
  final initVector = IV.fromUtf8(keyString.substring(0, 16));
  return encrypter.decrypt(encryptedData, iv: initVector);
}

Encrypted encrypt(String plainText) {
  final key = Key.fromUtf8(keyString);
  final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
  final initVector = IV.fromUtf8(keyString.substring(0, 16));
  Encrypted encryptedData = encrypter.encrypt(plainText, iv: initVector);
  return encryptedData;
}
