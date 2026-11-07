import 'dart:io';

import 'package:shopnepal/core/logger/logger.dart';
import 'package:shopnepal/core/network/http.dart';
import 'package:shopnepal/features/extraction/data/datasources/extraction_remote_datasource.dart';
import 'package:shopnepal/features/extraction/data/models/extraction_model.dart';
import 'package:shopnepal/features/extraction/domain/entities/extraction.dart';
import 'package:shopnepal/features/extraction/domain/repositories/extraction_repository.dart';

class ExtractionRepositoryImpl implements ExtractionRepository {
  final ApiProvider apiProvider;
  late ExtractionRemoteDataSource remoteDataSource;

  ExtractionRepositoryImpl({required this.apiProvider}) {
    remoteDataSource = ExtractionRemoteDataSource(apiProvider: apiProvider);
  }

  @override
  Future<DataResponse<ExtractedSheet>> extract(File file) async {
    try {
      final res = await remoteDataSource.extract(file);
      final rawSheet = res['data']?['data'] ?? res['data'];
      if (rawSheet is! Map) {
        return DataResponse.error('Invalid extraction payload');
      }
      final sheet = ExtractedSheetModel.fromMap(Map<String, dynamic>.from(rawSheet));
      return DataResponse.success(sheet);
    } on CustomException catch (e) {
      Log.e(e);
      return DataResponse.error(
        e.message?.toString() ?? e.toString(),
        e.statusCode,
        e.code,
      );
    } catch (e) {
      Log.e(e);
      return DataResponse.error(e.toString());
    }
  }
}