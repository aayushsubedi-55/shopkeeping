import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopnepal/core/cubit/data_state.dart';
import 'package:shopnepal/core/network/data_response.dart';
import 'package:shopnepal/core/network/http.dart';
import 'package:shopnepal/features/extraction/domain/entities/extraction.dart';
import 'package:shopnepal/features/extraction/domain/repositories/extraction_repository.dart';

/// Cubit for extracting order data from supplier photos.
class ExtractionCubit extends Cubit<CommonState> {
  final ExtractionRepository repository;

  ExtractionCubit({required this.repository}) : super(CommonInitial());

  Future<void> extract(File file) async {
    if (!isClosed) emit(CommonLoading());
    final res = await repository.extract(file);

    if (res.status == Status.success && res.data != null) {
      if (!isClosed) emit(CommonStateSuccess<ExtractedSheet>(data: res.data!));
    } else {
      if (!isClosed) emit(CommonError(message: res.message ?? 'Extraction failed'));
    }
  }

  void reset() => emit(CommonInitial());
}