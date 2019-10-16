import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

import 'Element.dart';
import 'Subset.dart';
import 'TM1Object.dart';

part 'Hierarchy.g.dart';

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class Hierarchy extends TM1Object {
  ///abstraction of hierarchy, consist of elements and keeps reference
  ///to its dimension


  final String classType = 'Hierarchy';
  @JsonKey(name: 'Name')
  final String name;
  @JsonKey(name: 'dimensionName')
  final String dimension;
  @JsonKey(name: 'Elements')
  Map<String, Element> elements;
  @JsonKey(name: 'Subsets')
  List<Subset> subsets;
  @JsonKey(name: 'Edges')
  List<Map<String, dynamic>> edges;


  Hierarchy(this.name, this.dimension, this.elements, this.subsets, this.edges);

  factory Hierarchy.fromJson(Map<String, dynamic> json) =>
      _$HierarchyFromJson(json);

  Map<String, dynamic> toJson() => _$HierarchyToJson(this);


  @override
  String createTM1Path() {
    return 'api/v1/Dimensions(\'$dimension\')/Hierarchies';
  }

  @override
  String body() {
    return json.encode(toJson());
  }


}
