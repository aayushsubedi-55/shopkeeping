import 'dart:convert';
import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String id;

  final String firstName;
  final String lastName;
  final String? email;
  final String phone;
  final String gender;

  final String? profilePicture;
  final String? country;
  final String? state;
  final String? city;
  final String accessToken;
  final DateTime? dateOfBirth;
  final bool isEmailVerified;
  final bool isPhoneVerified;
  final bool hasGoogleAuth;
  final bool hasAppleAuth;
  final String? referralCode;

  const UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.email,
    required this.phone,
    required this.gender,
    this.profilePicture,
    this.country,
    this.state,
    this.city,
    required this.accessToken,
    this.dateOfBirth,
    this.isEmailVerified = false,
    this.isPhoneVerified = false,
    this.hasGoogleAuth = false,
    this.hasAppleAuth = false,
    this.referralCode,
  });

  bool get isOAuthUser => hasGoogleAuth || hasAppleAuth;

  /// Only treat as verified when the contact exists on the account.
  bool get hasVerifiedPhone => isPhoneVerified && phone.trim().isNotEmpty;

  bool get hasVerifiedEmail =>
      isEmailVerified && (email?.trim().isNotEmpty ?? false);

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

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [
      id,
      firstName,
      lastName,
      email,
      phone,
      gender,
      profilePicture,
      country,
      state,
      city,
      accessToken,
      dateOfBirth,
      isEmailVerified,
      isPhoneVerified,
      hasGoogleAuth,
      hasAppleAuth,
      referralCode,
    ];
  }
}
