import 'dart:convert';

import 'package:shopnepal/features/auth/domain/entities/user.dart';

/// DTO for [User]: adds JSON (de)serialization on top of the pure entity.
class UserModel extends User {
  const UserModel({
    required super.id,
    required super.firstName,
    required super.lastName,
    super.email,
    required super.phone,
    required super.gender,
    super.profilePicture,
    super.country,
    super.state,
    super.city,
    required super.accessToken,
    super.dateOfBirth,
    super.isEmailVerified = false,
    super.isPhoneVerified = false,
    super.hasGoogleAuth = false,
    super.hasAppleAuth = false,
    super.referralCode,
  });

  UserModel copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    String? gender,
    String? profilePicture,
    String? country,
    String? state,
    String? city,
    String? accessToken,
    DateTime? dateOfBirth,
    bool? isEmailVerified,
    bool? isPhoneVerified,
    bool? hasGoogleAuth,
    bool? hasAppleAuth,
    String? referralCode,
  }) {
    return UserModel(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      gender: gender ?? this.gender,
      profilePicture: profilePicture ?? this.profilePicture,
      country: country ?? this.country,
      state: state ?? this.state,
      city: city ?? this.city,
      accessToken: accessToken ?? this.accessToken,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      isPhoneVerified: isPhoneVerified ?? this.isPhoneVerified,
      hasGoogleAuth: hasGoogleAuth ?? this.hasGoogleAuth,
      hasAppleAuth: hasAppleAuth ?? this.hasAppleAuth,
      referralCode: referralCode ?? this.referralCode,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phone': phone,
      'gender': gender,
      'profilePicture': profilePicture,
      'country': country,
      'state': state,
      'city': city,
      'accessToken': accessToken,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'isEmailVerified': isEmailVerified,
      'isPhoneVerified': isPhoneVerified,
      'hasGoogleAuth': hasGoogleAuth,
      'hasAppleAuth': hasAppleAuth,
      if (referralCode != null) 'referralCode': referralCode,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    final rawReferral =
        map['referralCode'] ?? map['myReferralCode'] ?? map['inviteCode'];
    final referral = rawReferral?.toString().trim();
    return UserModel(
      id: map['id'] ?? "",
      firstName: map['firstName'] ?? "",
      lastName: map['lastName'] ?? "",
      email: map['email'] != null ? map['email'] ?? "" : null,
      phone: map['phone'] ?? "",
      gender: map['gender'] ?? "",
      profilePicture: map['profilePicture'] != null
          ? map['profilePicture'] ?? ""
          : null,
      country: map['country'] != null ? map['country'] ?? "" : null,
      state: map['state'] != null ? map['state'] ?? "" : null,
      city: map['city'] != null ? map['city'] ?? "" : null,
      accessToken: map['accessToken'] ?? "",
      dateOfBirth: map['dateOfBirth'] != null
          ? DateTime.tryParse(map['dateOfBirth'].toString())
          : null,
      isEmailVerified: _readBool(map['isEmailVerified']),
      isPhoneVerified: _readBool(map['isPhoneVerified']),
      hasGoogleAuth: _readBool(map['hasGoogleAuth']),
      hasAppleAuth: _readBool(map['hasAppleAuth']),
      referralCode: (referral == null || referral.isEmpty) ? null : referral,
    );
  }

  static bool _readBool(dynamic value) {
    if (value == true || value == 1) return true;
    if (value is String) {
      final normalized = value.trim().toLowerCase();
      return normalized == 'true' || normalized == '1';
    }
    return false;
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
