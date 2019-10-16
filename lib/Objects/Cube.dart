import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:tm1_dart/Objects/Dimension.dart';
import 'package:tm1_dart/Objects/TM1Object.dart';

part 'Cube.g.dart';

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class Cube extends TM1Object {
  @JsonKey(name: 'Name')
  String name;
  @JsonKey(name: 'Dimensions')
  List<Dimension> dimensions;
  @JsonKey(name: 'Rules')
  String rules;
  final String classType = 'Cubes';


  Cube(this.name, this.dimensions, this.rules);

  factory Cube.fromJson(Map<String, dynamic> json) => _$CubeFromJson(json);

  Map<String, dynamic> toJson() => _$CubeToJson(this);


  @override
  String createTM1Path() {
    return 'api/v1/Cubes';
  }

  @override
  String body() {
    return json.encode(toJson());
  }

}
