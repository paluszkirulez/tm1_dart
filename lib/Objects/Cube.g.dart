// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Cube.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Cube _$CubeFromJson(Map<String, dynamic> json) {
  return Cube(
    json['Name'] as String,
    (json['Dimensions'] as List),
    json['Rules'] as String,
  );
}

Map<String, dynamic> _$CubeToJson(Cube instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('Name', instance.name);
  writeNotNull(
      'Dimensions', instance.dimensions?.map((e) => e?.toJson())?.toList());
  writeNotNull('Rules', instance.rules);
  return val;
}
