import 'dart:convert';
import 'package:crypto/crypto.dart';

String encryptPass(String pass, String key) {
  var k = utf8.encode(key);
  var bytes = utf8.encode(pass);

  var hmacSha256 = Hmac(sha256, k); // HMAC-SHA256
  var encryptPass = hmacSha256.convert(bytes);

  // print("HMAC digest as bytes: ${encryptPass.bytes}");
  // print("HMAC digest as hex string: $encryptPass");
  return encryptPass.toString();
}
