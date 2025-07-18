import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

// This line is necessary for automatic code generation.
// Run 'flutter pub run build_runner build' after creating/modifying this file.
part 'user.g.dart';

/// Represents a user in the application.
///
/// This data class is used to store user information, typically for
/// services like Firebase Firestore.
@JsonSerializable()
class User {
  /// The unique identifier for the user.
  ///
  /// In Firestore, this often corresponds to the document ID.
  /// While Firestore can manage document IDs separately, including it
  /// in the model can be useful, especially if the ID is part of the document's JSON.
  /// In Flutter, the document ID is often handled externally to the model object itself.
  /// For consistency with a potential Kotlin equivalent using `@DocumentId`, it's included here.
  final String uid;

  /// The user's email address.
  final String email;

  /// The user's chosen username.
  final String username;

  /// The user's favorite car brand.
  final String favoriteCarBrand;

  /// The user's place of birth.
  final String placeOfBirth;

  /// The user's street address.
  final String streetAddress;

  /// The user's city of residence.
  final String cityOfResidence;

  /// The user's year of birth. Optional.
  final int? yearOfBirth;

  /// A list of licenses held by the user (e.g., driver's license types).
  final List<String> licenses;

  /// The timestamp of when the user registered, as a [DateTime] object.
  ///
  /// This is converted to/from milliseconds since epoch for Firestore compatibility
  /// (equivalent to a Long in Kotlin representing `System.currentTimeMillis()`).
  @JsonKey(fromJson: _dateTimeFromMillisecondsSinceEpoch, toJson: _dateTimeToMillisecondsSinceEpoch)
  final DateTime registrationTimestamp;

  /// Creates a [User] instance.
  ///
  /// All fields are initialized with provided values or defaults.
  /// [registrationTimestamp] defaults to the current time if not provided.
  User({
    this.uid = '',
    this.email = '',
    this.username = '',
    this.favoriteCarBrand = '',
    this.placeOfBirth = '',
    this.streetAddress = '',
    this.cityOfResidence = '',
    this.yearOfBirth,
    this.licenses = const [], // Defaults to an empty list
    DateTime? registrationTimestamp,
  }) : registrationTimestamp = registrationTimestamp ?? DateTime.now();

  /// Factory constructor to create a [User] instance from a JSON map.
  ///
  /// This uses the `_$UserFromJson` function generated by `json_serializable`.
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  /// Converts the [User] instance into a JSON map.
  ///
  /// This uses the `_$UserToJson` function generated by `json_serializable`.
  Map<String, dynamic> toJson() => _$UserToJson(this);

  /// Converts an integer representing milliseconds since epoch to a [DateTime] object.
  ///
  /// Used by `json_serializable` for the `registrationTimestamp` field.
  static DateTime _dateTimeFromMillisecondsSinceEpoch(int milliseconds) =>
      DateTime.fromMillisecondsSinceEpoch(milliseconds);

  /// Converts a [DateTime] object to an integer representing milliseconds since epoch.
  ///
  /// Used by `json_serializable` for the `registrationTimestamp` field.
  static int _dateTimeToMillisecondsSinceEpoch(DateTime dateTime) =>
      dateTime.millisecondsSinceEpoch;

  /// Creates a copy of this [User] instance with the given fields replaced
  /// with new values.
  ///
  /// This is similar to the `copy` method in Kotlin data classes.
  User copyWith({
    String? uid,
    String? email,
    String? username,
    String? favoriteCarBrand,
    String? placeOfBirth,
    String? streetAddress,
    String? cityOfResidence,
    int? yearOfBirth,
    List<String>? licenses,
    DateTime? registrationTimestamp,
  }) {
    return User(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      username: username ?? this.username,
      favoriteCarBrand: favoriteCarBrand ?? this.favoriteCarBrand,
      placeOfBirth: placeOfBirth ?? this.placeOfBirth,
      streetAddress: streetAddress ?? this.streetAddress,
      cityOfResidence: cityOfResidence ?? this.cityOfResidence,
      yearOfBirth: yearOfBirth ?? this.yearOfBirth,
      licenses: licenses ?? this.licenses,
      registrationTimestamp: registrationTimestamp ?? this.registrationTimestamp,
    );
  }
}
