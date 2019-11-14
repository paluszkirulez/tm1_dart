// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Hierarchy.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Hierarchy _$HierarchyFromJson(Map<String, dynamic> json) {
  return Hierarchy(
    json['Name'] as String,
    json['Dimension']['Name'] as String,
    (json['Elements'] as Map<String, dynamic>),
    (json['Subsets'] as List),
    (json['Edges'] as List)?.map((e) => e as Map<String, dynamic>)?.toList(),
  );
}

Map<String, dynamic> _$HierarchyToJson(Hierarchy instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('Name', instance.name);
  /*writeNotNull('dimensionName', instance.dimension);
  writeNotNull(
      'Elements', instance.elements?.map((k, e) => MapEntry(k, e?.toJson())));
  writeNotNull('Subsets', instance.subsets?.map((e) => e?.toJson())?.toList());
  writeNotNull('Edges', instance.edges);*/
  return val;
}
