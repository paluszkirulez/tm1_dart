import 'package:json_annotation/json_annotation.dart';

import 'TM1Object.dart';

part 'Attribute.g.dart';

@JsonSerializable(explicitToJson: true)
class Attribute extends TM1Object {
  /// abstraction for attribute, keep refrence to a dimension where is used

  final String name;
  final String type;
  final String dimension;
  final String hierarchy;


  Attribute(this.name, this.type, this.dimension, this.hierarchy);

  factory Attribute.fromJson(Map<String, dynamic> json) =>
      _$AttributeFromJson(json);

  Map<String, dynamic> toJson() => _$AttributeToJson(this);

  @override
  String createTM1Path() {
    return 'api/v1/Dimensions(\'$dimension\')/Hierarchies(\'$dimension\')/ElementAttributes';
  }

  @override
  String body() {
    Map<String, dynamic> bodyMap = {
      '"Name"': '"$name"',
      '"Type"': '"$type"'
    };
    return bodyMap.toString();
  }
}
