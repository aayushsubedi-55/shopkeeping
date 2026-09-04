import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

/// One-time / infrequent media access via the system pickers.
///
/// Android Photo Picker and iOS PHPicker do not require persistent
/// READ_MEDIA_* / photo-library permissions. Only the camera needs a permission.
class MediaPicker {
  static final ImagePicker _picker = ImagePicker();

  static Future<XFile?> pickImageFromCamera() async {
    final granted = await _requestCameraPermission();
    if (!granted) {
      return null;
    }

    return _picker.pickImage(source: ImageSource.camera, imageQuality: 80);
  }

  static Future<XFile?> pickImageFromGallery() async {
    // Do not request READ_MEDIA_IMAGES / photos permission. The platform
    // photo picker grants one-time access for the selected item only, which
    // is what Google Play requires for infrequent media access.
    return _picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
  }

  static Future<bool> _requestCameraPermission() async {
    if (Platform.isAndroid || Platform.isIOS) {
      final status = await Permission.camera.request();
      return status.isGranted;
    }
    return true;
  }
}
