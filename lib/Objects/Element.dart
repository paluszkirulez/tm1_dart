import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

import 'TM1Object.dart';

part 'Element.g.dart';

@JsonSerializable(explicitToJson: true)
class Element extends TM1Object {
  ///class that represents element
  final String classType = 'Element';
  @JsonKey(name: 'Name')
  final String name;
  @JsonKey(name: 'UniqueName')
  final String uniqueName;
  @JsonKey(name: 'Type')
  String elementType;
  @JsonKey(name: 'Index')
  final int index;
  @JsonKey(name: 'Level')
  final int level;
  @JsonKey(name: 'dimensionName')
  final String dimension;
  @JsonKey(name: 'hierarchyName')
  final String hierarchy;
  @JsonKey(name: 'Attributes')
  Map<String, dynamic> attributes;

  @override
  String createTM1Path() {
    return 'api/v1/Dimensions(\'$dimension\')/Hierarchies(\'$hierarchy\')/Elements';
  }

  Element(this.name, this.uniqueName, this.elementType,
      this.index, this.level, this.dimension, this.hierarchy,
      this.attributes);


  factory Element.fromJson(Map<String, dynamic> json) =>
      _$ElementFromJson(json);

  Map<String, dynamic> toJson() => _$ElementToJson(this);


  @override
  String toString() {
    return 'Element{name: $name, uniqueName: $uniqueName, elementType: $elementType, index: $index, level: $level}';
  }

  @override
  String body() {
    return json.encode(toJson());
  }
}
