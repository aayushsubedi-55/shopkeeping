import 'package:equatable/equatable.dart';

// common cubit state which is used overall the app
// note: do not create any unwanted state while creating new cubit

abstract class MainState<T> {
  const MainState();
}

class CommonState extends Equatable implements MainState {
  const CommonState({this.statusCode});
  final int? statusCode;
  @override
  List<Object?> get props => [];
}

class CommonInitial extends CommonState {}

// use it for loading
class CommonLoading extends CommonState {}

// use it for loading

class CommonDummyLoading extends CommonState {}

// use it for error
class CommonError extends CommonState {
  final String message;
  final String? code;
  const CommonError({required this.message, int? statusCode, this.code})
      : super(statusCode: statusCode);
  bool get isNoConnection => statusCode == 1000;
  @override
  List<Object?> get props => [message, code];
}

// use it , it response has no data or empty
class CommonNoData extends CommonState {
  const CommonNoData();
  @override
  List<Object?> get props => [];
}

// use it for success if response data is in List<T>

class CommonDataFetchSuccess<T> extends CommonState {
  final List<T> data;
  const CommonDataFetchSuccess({required this.data});

  @override
  List<T> get props => [...data];
}

// use it for success if you dont want any data in ui

class CommonSuccess extends CommonState {}

// use it for success if response data is any type generic
class CommonStateSuccess<T> extends CommonState {
  final T data;
  const CommonStateSuccess({required this.data});

  CommonStateSuccess<T> copyWith({
    T? data,
  }) {
    return CommonStateSuccess<T>(
      data: data ?? this.data,
    );
  }

  @override
  List<Object?> get props => [data];
}
