import 'dart:io';

import 'package:dio/dio.dart';
import 'package:shopnepal/common/http/http.dart';
import 'package:shopnepal/features/media/resource/media_api_provider.dart';

class MediaRepository {
  final ApiProvider apiProvider;
  late MediaApiProvider mediaApiProvider;

  MediaRepository({required this.apiProvider}) {
    mediaApiProvider = MediaApiProvider(apiProvider: apiProvider);
  }

  Future<DataResponse<String>> uploadMedia({required File file}) async {
    try {
      final fileName = file.path.split('/').last;
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(file.path, filename: fileName),
      });

      final res = await mediaApiProvider.uploadMedia(formData);

      final url =
          res['data']?['data']?['url'] ??
          res['data']?['url'] ??
          res['url'] ??
          '';

      if (url is String && url.isNotEmpty) {
        return DataResponse.success(url);
      }

      return DataResponse.error('Media upload succeeded but URL not found');
    } on CustomException catch (e) {
      return DataResponse.error(
        e.message?.toString() ?? e.toString(),
        e.statusCode,
      );
    } catch (e) {
      return DataResponse.error(e.toString());
    }
  }
}
