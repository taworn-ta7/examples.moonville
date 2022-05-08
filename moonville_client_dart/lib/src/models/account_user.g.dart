// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccountUser _$AccountUserFromJson(Map<String, dynamic> json) => AccountUser(
      id: json['id'] as String? ?? '',
      email: json['email'] as String? ?? '',
      role: json['role'] as String? ?? '',
      name: json['name'] as String? ?? '',
      locale: json['locale'] as String? ?? '',
      theme: json['theme'] as int? ?? 0,
      disabled: json['disabled'] == null
          ? null
          : DateTime.parse(json['disabled'] as String),
      resigned: json['resigned'] == null
          ? null
          : DateTime.parse(json['resigned'] as String),
      begin: json['begin'] == null
          ? null
          : DateTime.parse(json['begin'] as String),
      end: json['end'] == null ? null : DateTime.parse(json['end'] as String),
      expire: json['expire'] == null
          ? null
          : DateTime.parse(json['expire'] as String),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$AccountUserToJson(AccountUser instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'role': instance.role,
      'name': instance.name,
      'locale': instance.locale,
      'theme': instance.theme,
      'disabled': instance.disabled?.toIso8601String(),
      'resigned': instance.resigned?.toIso8601String(),
      'begin': instance.begin?.toIso8601String(),
      'end': instance.end?.toIso8601String(),
      'expire': instance.expire?.toIso8601String(),
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
