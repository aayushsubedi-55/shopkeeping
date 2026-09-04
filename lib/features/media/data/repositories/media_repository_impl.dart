import 'dart:io';

import 'package:dio/dio.dart';
import 'package:shopnepal/core/network/http.dart';
import 'package:shopnepal/features/media/data/datasources/media_remote_datasource.dart';
import 'package:shopnepal/features/media/domain/repositories/media_repository.dart';

class MediaRepositoryImpl implements MediaRepository {
  final ApiProvider apiProvider;
  late MediaRemoteDataSource mediaRemoteDataSource;

  MediaRepositoryImpl({required this.apiProvider}) {
    mediaRemoteDataSource = MediaRemoteDataSource(apiProvider: apiProvider);
  }

  @override
  Future<DataResponse<String>> uploadMedia({required File file}) async {
    try {
      final fileName = file.path.split('/').last;
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(file.path, filename: fileName),
      });

      final res = await mediaRemoteDataSource.uploadMedia(formData);

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
