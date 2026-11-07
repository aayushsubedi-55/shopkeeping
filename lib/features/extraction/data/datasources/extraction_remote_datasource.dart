import 'dart:io';

import 'package:dio/dio.dart';
import 'package:shopnepal/core/network/http.dart';

/// Thin URI builder over the shared [ApiProvider]. No parsing, no error
/// handling — that is the repository's job.
class ExtractionRemoteDataSource {
  final ApiProvider apiProvider;
  final String basePath = 'extract';

  ExtractionRemoteDataSource({required this.apiProvider});

  /// Extract order data from a supplier photo.
  /// Uses multipart/form-data with a 'file' field.
  Future<dynamic> extract(File file) async {
    final fileName = file.path.split('/').last;
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(file.path, filename: fileName),
    });
    return await apiProvider.post(basePath, formData);
  }
}