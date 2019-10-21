import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:tm1_dart/Objects/Element.dart';
import 'package:tm1_dart/Objects/Subset.dart';

part 'UnregSubset.g.dart';

@JsonSerializable(explicitToJson: true)
class UnregSubset extends Subset{
  @JsonKey(name: 'Name')
  final String name;
  @JsonKey(name: 'UniqueName')
  final String uniqueName;
  @JsonKey(name: 'Alias')
  final String alias;
  @JsonKey(name: 'dimensionName')
  final String dimensionName;
  @JsonKey(name: 'hierarchyName')
  final String hierarchyName;
  @JsonKey(name: 'Elements')
  Map<String, Element> elements = {};
  bool isDynamic = false;
  @JsonKey(name: 'Expression')
  String expression = '';
  @JsonKey(name: 'Attributes')
  Map<String, dynamic> attributes;

  UnregSubset(this.name, this.uniqueName, this.dimensionName,
      this.hierarchyName, this.alias, this.elements, this.expression,
      this.isDynamic, this.attributes) :
        super(
          name,
          uniqueName,
          dimensionName,
          hierarchyName,
          alias,
          elements,
          expression,
          attributes);

  factory UnregSubset.fromJson(Map<String, dynamic> json) =>
      _$UnregSubsetFromJson(json);

  Map<String, dynamic> toJson() => _$UnregSubsetToJson(this);

  @override
  String createTM1Path() {
    return 'api/v1/Dimensions(\'$dimensionName\')/Hierarchies(\'$hierarchyName\')/Elements';
  }


  @override
  String body() {
    Map<String,dynamic> bodyMap={};
    bodyMap.addAll({'Hierarchy@odata.bind':'Dimensions(\'$dimensionName\')/Hierarchies(\'$hierarchyName\')'});
    bodyMap.addAll(createExpressionOrListOfElement());
    return json.encode(bodyMap);
  }


}