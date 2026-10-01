import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

enum Role { ADMIN, MANAGER, REPRESENTATIVE, DRIVER, VIEWER }

@freezed
abstract class User with _$User {
  const factory User({
    required int id,
    required String email,
    @Default([]) List<Role> roles,
    int? companyId,
    String? firstName,
    String? lastName,
    String? phone,
    @Default(true) bool active,
  }) = _User;
  const User._();

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  String get displayName {
    final name = [firstName, lastName].whereType<String>().where((s) => s.isNotEmpty).join(' ');
    return name.isEmpty ? email : name;
  }

  bool has(Role role) => roles.contains(role);
  bool get isRepresentative => has(Role.REPRESENTATIVE);
  bool get isDriver => has(Role.DRIVER);

  /// Only REPRESENTATIVE / DRIVER work in the app; everyone else is sent to the web.
  bool get canUseMobile => isRepresentative || isDriver;
}

@freezed
abstract class TokenResponse with _$TokenResponse {
  const factory TokenResponse({
    required String accessToken,
    @Default('Bearer') String tokenType,
    @Default(43200) int expiresIn,
  }) = _TokenResponse;

  factory TokenResponse.fromJson(Map<String, dynamic> json) => _$TokenResponseFromJson(json);
}
