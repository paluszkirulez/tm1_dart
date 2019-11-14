// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Subset.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Subset _$SubsetFromJson(Map<String, dynamic> json) {
  Map<String, Element> _convertListToMap(List listOfElement) {
    Map<String, Element> myMap = {};
    for (Map e in listOfElement) {
      myMap.addAll({e['Name']: Element.fromJson(e)});
    }
    return myMap;
  }

  return Subset(
    json['Name'] as String,
    json['UniqueName'] as String,
    json['Hierarchy']['Dimension']['Name'] as String,
    json['Hierarchy']['Name'] as String,
    json['Alias'] as String,
    json['Elements'] == null ? {} : _convertListToMap(json['Elements'] as List),
    json['Expression'] as String ?? '',
    json['Attributes'] as Map<String, dynamic>,
  )
    ..private = json['private'] as bool
    ..isDynamic = json['isDynamic'] as bool;
}

Map<String, dynamic> _$SubsetToJson(Subset instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('Name', instance.name);
  /*writeNotNull('UniqueName', instance.uniqueName);
  writeNotNull('dimensionName', instance.dimensionName);
  writeNotNull('hierarchyName', instance.hierarchyName);
  writeNotNull('private', instance.private);*/
  writeNotNull('Alias', instance.alias);
  writeNotNull(
      'Elements', instance.elements?.map((k, e) => MapEntry(k, e?.toJson())));
  //writeNotNull('isDynamic', instance.isDynamic);
  writeNotNull('Expression', instance.expression);
  //writeNotNull('Attributes', instance.attributes);
  return val;
}
