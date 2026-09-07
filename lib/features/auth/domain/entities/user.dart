import 'package:equatable/equatable.dart';

/// The signed-in staff user. Pure domain value object — no JSON, no Flutter.
class User extends Equatable {
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

  const User({
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
