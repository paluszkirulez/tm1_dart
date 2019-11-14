// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'UnregSubset.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UnregSubset _$UnregSubsetFromJson(Map<String, dynamic> json) {
  Map<String, Element> _convertListToMap(List listOfElement) {
    Map<String, Element> myMap = {};
    for (Map e in listOfElement) {
      myMap.addAll({e['Name']: Element.fromJson(e)});
    }
    return myMap;
  }

  return UnregSubset(
    json['Hierarchy']['Dimension']['Name'] as String,
    json['Hierarchy']['Name'] as String,
    json['Elements'] == null ? {} : _convertListToMap(json['Elements'] as List),
    (json['Expression'] as String == '' ? false : true),
    json['Expression'] as String,
    json['Attributes'] as Map<String, dynamic>,
  );
}

Map<String, dynamic> _$UnregSubsetToJson(UnregSubset instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('private', instance.private);
  //val['Name'] = instance.name;
  //val['UniqueName'] = instance.uniqueName;
  //val['Alias'] = instance.alias;
  //val['dimensionName'] = instance.dimensionName;
  //val['hierarchyName'] = instance.hierarchyName;
  val['Elements'] = instance.elements?.map((k, e) => MapEntry(k, e?.toJson()));
  //val['isDynamic'] = instance.isDynamic;
  val['Expression'] = instance.expression;
  val['Attributes'] = instance.attributes;
  return val;
}
