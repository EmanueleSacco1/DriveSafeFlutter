// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      uid: json['uid'] as String? ?? '',
      email: json['email'] as String? ?? '',
      username: json['username'] as String? ?? '',
      favoriteCarBrand: json['favoriteCarBrand'] as String? ?? '',
      placeOfBirth: json['placeOfBirth'] as String? ?? '',
      streetAddress: json['streetAddress'] as String? ?? '',
      cityOfResidence: json['cityOfResidence'] as String? ?? '',
      yearOfBirth: (json['yearOfBirth'] as num?)?.toInt(),
      licenses: (json['licenses'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      registrationTimestamp: User._dateTimeFromMillisecondsSinceEpoch(
          (json['registrationTimestamp'] as num).toInt()),
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'uid': instance.uid,
      'email': instance.email,
      'username': instance.username,
      'favoriteCarBrand': instance.favoriteCarBrand,
      'placeOfBirth': instance.placeOfBirth,
      'streetAddress': instance.streetAddress,
      'cityOfResidence': instance.cityOfResidence,
      'yearOfBirth': instance.yearOfBirth,
      'licenses': instance.licenses,
      'registrationTimestamp': User._dateTimeToMillisecondsSinceEpoch(
          instance.registrationTimestamp),
    };
