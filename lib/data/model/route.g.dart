// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'route.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Route _$RouteFromJson(Map<String, dynamic> json) => Route(
      id: json['id'] as String? ?? '',
      userId: json['userId'] as String,
      timestamp: (json['timestamp'] as num).toInt(),
      pathPoints: json['pathPoints'] == null
          ? const []
          : const GeoPointListConverter().fromJson(json['pathPoints'] as List),
      startTime: (json['startTime'] as num).toInt(),
      endTime: (json['endTime'] as num).toInt(),
      totalDistance: (json['totalDistance'] as num).toDouble(),
      averageSpeed: (json['averageSpeed'] as num).toDouble(),
      maxSpeed: (json['maxSpeed'] as num).toDouble(),
    );

Map<String, dynamic> _$RouteToJson(Route instance) => <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'timestamp': instance.timestamp,
      'pathPoints': const GeoPointListConverter().toJson(instance.pathPoints),
      'startTime': instance.startTime,
      'endTime': instance.endTime,
      'totalDistance': instance.totalDistance,
      'averageSpeed': instance.averageSpeed,
      'maxSpeed': instance.maxSpeed,
    };
