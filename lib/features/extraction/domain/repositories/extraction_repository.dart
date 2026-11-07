import 'dart:io';

import 'package:shopnepal/core/network/http.dart';
import 'package:shopnepal/features/extraction/domain/entities/extraction.dart';

abstract class ExtractionRepository {
  Future<DataResponse<ExtractedSheet>> extract(File file);
}