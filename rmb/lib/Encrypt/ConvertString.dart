import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pointycastle/export.dart';
import 'dart:typed_data';

// //write a function that get a public key and return a string
// String pubToStr(RSAPublicKey publicKey) {
//   final modulusBytes = Uint8List.fromList(publicKey.modulus
//           ?.toRadixString(16)
//           .padLeft(publicKey.modulus!.bitLength ~/ 4, '0')
//           .toUpperCase()
//           .codeUnits ??
//       []);
//   final exponentBytes = Uint8List.fromList(publicKey.exponent
//           ?.toRadixString(16)
//           .padLeft(publicKey.exponent!.bitLength ~/ 4, '0')
//           .toUpperCase()
//           .codeUnits ??
//       []);
//   final bytes = <int>[];
//   bytes.addAll(_encodeLength(modulusBytes.length));
//   bytes.addAll(modulusBytes);
//   bytes.addAll(_encodeLength(exponentBytes.length));
//   bytes.addAll(exponentBytes);
//   return base64Encode(bytes);
// }

String publicKeyToString(RSAPublicKey publicKey) {
  final modulusBytes = Uint8List.fromList(publicKey.modulus
          ?.toRadixString(16)
          .padLeft(publicKey.modulus!.bitLength ~/ 4, '0')
          .toUpperCase()
          .codeUnits ??
      []);
  final exponentBytes = Uint8List.fromList(publicKey.exponent
          ?.toRadixString(16)
          .padLeft(publicKey.exponent!.bitLength ~/ 4, '0')
          .toUpperCase()
          .codeUnits ??
      []);
  final bytes = <int>[];
  bytes.addAll(_encodeLength(modulusBytes.length));
  bytes.addAll(modulusBytes);
  bytes.addAll(_encodeLength(exponentBytes.length));
  bytes.addAll(exponentBytes);
  return base64Encode(bytes);
}

List<int> _encodeLength(int length) {
  if (length < 128) {
    return [length];
  } else {
    final bytesNeeded = (length.bitLength + 7) ~/ 8;
    final bytes = <int>[];
    bytes.add(bytesNeeded | 0x80);
    for (var i = bytesNeeded - 1; i >= 0; i--) {
      bytes.add((length >> (8 * i)) & 0xff);
    }
    return bytes;
  }
}

extension BigIntExtension on BigInt {
  List<int> toByteArray() {
    final byteCount = (this.bitLength + 7) ~/ 8;
    final result = List<int>.filled(byteCount, 0);
    var temp = this;
    for (var i = 0; i < byteCount; i++) {
      result[i] = temp.toUnsigned(8).toInt();
      temp = temp >> 8;
    }
    return result.reversed.toList();
  }
}
