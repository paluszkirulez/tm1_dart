// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Dimension.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Dimension _$DimensionFromJson(Map<String, dynamic> json) {
  return Dimension(json['Name'] as String, (json['Hierarchies'] as List));
}

Map<String, dynamic> _$DimensionToJson(Dimension instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('Name', instance.name);
  writeNotNull(
      'Hierarchies', instance.hierarchies?.map((e) => e?.toJson())?.toList());
  return val;
}
