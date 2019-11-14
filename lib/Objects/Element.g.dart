// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Element.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Element _$ElementFromJson(Map<String, dynamic> json) {
  return Element(
    json['Name'] as String,
    json['UniqueName'] as String,
    json['Type'] as String,
    json['Index'] as int,
    json['Level'] as int,
    json['Hierarchy']['Dimension']['Name'] as String,
    json['Hierarchy']['Name'] as String,
    json['Attributes'] as Map<String, dynamic>,
  );
}

Map<String, dynamic> _$ElementToJson(Element instance) => <String, dynamic>{
      'Name': instance.name,
      //'UniqueName': instance.uniqueName,
      'Type': instance.elementType,
      'Index': instance.index,
      'Level': instance.level,
      //'dimensionName': instance.dimension,
      'Hierarchy': {
        'Dimension': {'Name': instance.dimension},
        'Name': instance.hierarchy
      },
      //'Attributes': instance.attributes,
    };
