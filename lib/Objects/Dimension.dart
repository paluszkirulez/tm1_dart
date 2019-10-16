import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

import 'Hierarchy.dart';
import 'TM1Object.dart';

part 'Dimension.g.dart';

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class Dimension extends TM1Object{
  ///this class is created as a dimension blueprint
  /// beside name it contains list of hierarchies (not elements)
  final String classType = 'Dimension';
  @JsonKey(name: 'Name')
  final String name;
  @JsonKey(name: 'Hierarchies')
  List<Hierarchy> hierarchies = [];


  Dimension(this.name, this.hierarchies);

  factory Dimension.fromJson(Map<String, dynamic> json) =>
      _$DimensionFromJson(json);

  Map<String, dynamic> toJson() => _$DimensionToJson(this);

  @override
  String createTM1Path() {
    return 'api/v1/Dimensions';
  }

  @override
  String body() {
    return json.encode(toJson());
  }


}