import 'dart:convert';
import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';

class ImageConvert {
  static Future<String> convertFileToBase64(XFile file) async {
    var bytes = await file.readAsBytes();
    return base64Encode(bytes);
  }

  static Uint8List decodeBase64(String baseString) {
    return base64Decode(baseString);
  }
}