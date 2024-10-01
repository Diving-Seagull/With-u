import 'package:crypto/crypto.dart';
import 'dart:convert';

import 'package:uuid/uuid.dart';

class ConvertUuid {
  static String nameUUIDFromBytes(String str) {
    Uuid uuid = Uuid();
    print(uuid.v5(Uuid.NAMESPACE_OID, str));
    return uuid.v5(Uuid.NAMESPACE_OID, str);
  }

}