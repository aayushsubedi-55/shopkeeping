import 'package:equatable/equatable.dart';

/// A goods supplier. Pure domain value object — no JSON, no Flutter.
class Supplier extends Equatable {
  final String id;
  final String name;
  final String? wechatId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Supplier({
    required this.id,
    required this.name,
    this.wechatId,
    this.createdAt,
    this.updatedAt,
  });

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [id, name, wechatId, createdAt, updatedAt];
}
