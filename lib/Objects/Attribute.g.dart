// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Attribute.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Attribute _$AttributeFromJson(Map<String, dynamic> json) {
  return Attribute(
    json['name'] as String,
    json['type'] as String,
    json['dimension'] as String,
    json['hierarchy'] as String,
  );
}

Map<String, dynamic> _$AttributeToJson(Attribute instance) => <String, dynamic>{
      'name': instance.name,
      'type': instance.type,
      'dimension': instance.dimension,
      'hierarchy': instance.hierarchy,
    };
