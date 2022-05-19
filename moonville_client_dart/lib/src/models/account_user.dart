import 'dart:typed_data';
import 'package:json_annotation/json_annotation.dart';

part 'account_user.g.dart';

@JsonSerializable()
class AccountUser {
  static const emailMax = 254;
  static const roleList = ['user', 'admin'];
  static const nameMin = 1;
  static const nameMax = 100;
  static const localeList = ['en', 'th'];
  static const themeMin = 0;
  static const themeMax = 15;
  static const passwordMin = 4;
  static const passwordMax = 20;

  // ----------------------------------------------------------------------

  // id
  String id;

  // email
  String email;

  // role
  String role;

  // ----------------------------------------------------------------------

  // display name
  String name;

  // current locale
  String locale;

  // current theme
  int theme;

  // ----------------------------------------------------------------------

  // disabled by admin or not
  DateTime? disabled;

  // resigned by user or not
  DateTime? resigned;

  // ----------------------------------------------------------------------

  // last login
  DateTime? begin;

  // last logout
  DateTime? end;

  // expiration time
  DateTime? expire;

  // ----------------------------------------------------------------------

  // created
  DateTime? createdAt;

  // updated
  DateTime? updatedAt;

  // icon
  @JsonKey(ignore: true)
  Uint8List? icon;

  // constructor
  AccountUser({
    this.id = '',
    this.email = '',
    this.role = '',
    this.name = '',
    this.locale = '',
    this.theme = 0,
    this.disabled,
    this.resigned,
    this.begin,
    this.end,
    this.expire,
    this.createdAt,
    this.updatedAt,
  });

  // from and to JSON
  factory AccountUser.fromJson(Map<String, dynamic> json) =>
      _$AccountUserFromJson(json);
  Map<String, dynamic> toJson() => _$AccountUserToJson(this);

  @override
  String toString() =>
      "$id [$role] $email, locale=$locale, theme=$theme, login=$begin";
}
