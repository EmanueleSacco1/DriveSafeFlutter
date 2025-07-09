import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

/// A custom JSON converter for the Firebase `GeoPoint` type.
///
/// This allows `json_serializable` to handle the serialization
/// and deserialization of `GeoPoint` objects to and from JSON.
class GeoPointConverter implements JsonConverter<GeoPoint, Map<String, dynamic>> {
  /// Creates a constant instance of [GeoPointConverter].
  const GeoPointConverter();

  /// Converts a JSON [Map] into a [GeoPoint] object.
  ///
  /// Firebase `GeoPoint` objects have 'latitude' and 'longitude' fields.
  @override
  GeoPoint fromJson(Map<String, dynamic> json) {
    return GeoPoint(json['latitude'] as double, json['longitude'] as double);
  }

  /// Converts a [GeoPoint] object into a JSON [Map].
  @override
  Map<String, dynamic> toJson(GeoPoint object) {
    return {
      'latitude': object.latitude,
      'longitude': object.longitude,
    };
  }

  /// Converts a list of dynamic objects (from JSON) into a list of [GeoPoint] objects.
  ///
  /// This method handles cases where the elements in the JSON list might already be
  /// `GeoPoint` instances (e.g., if not strictly coming from a raw JSON string)
  /// or `Map<String, dynamic>` representations.
  static List<GeoPoint> geoPointListFromJson(List<dynamic> jsonList) {
    return jsonList.map((e) {
      if (e is GeoPoint) {
        return e;
      } else if (e is Map<String, dynamic>) {
        return GeoPoint(e['latitude'] as double, e['longitude'] as double);
      }
      // If the element is neither a GeoPoint nor a compatible Map, throw an error.
      throw ArgumentError('Expected GeoPoint or Map for GeoPoint, but got ${e.runtimeType}');
    }).toList();
  }

  /// Converts a list of [GeoPoint] objects into a list of dynamic objects (for JSON).
  ///
  /// Firestore can directly serialize `GeoPoint` objects,
  /// so it's not strictly necessary to convert them to a `Map` here
  /// when the target is Firestore. The list of `GeoPoint`s can be returned directly.
  static List<dynamic> geoPointListToJson(List<GeoPoint> geoPointList) {
    return geoPointList;
  }
}
