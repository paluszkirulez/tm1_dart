import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

import 'Element.dart';
import 'TM1Object.dart';

part 'Subset.g.dart';

@JsonSerializable(explicitToJson: true)
class Subset extends TM1Object {
  final String classType = 'Subset';
  @JsonKey(name: 'Name')
  final String name;
  @JsonKey(name: 'UniqueName')
  final String uniqueName;
  @JsonKey(name: 'dimensionName')
  final String dimensionName;
  @JsonKey(name: 'hierarchyName')
  final String hierarchyName;
  bool private;
  @JsonKey(name: 'Alias')
  String alias;
  @JsonKey(name: 'Elements')
  Map<String, Element> elements = {};
  bool isDynamic = false;
  @JsonKey(name: 'Expression')
  String expression = '';
  @JsonKey(name: 'Attributes')
  Map<String, dynamic> attributes = {};


  Subset(this.name, this.uniqueName, this.dimensionName, this.hierarchyName,
      this.alias, this.elements, this.expression,
      this.attributes);

  //TODO add prvatesubsets by adding boolean and using 'PrivateSubsets' in baseurl
  factory Subset.fromJson(Map<String, dynamic> json) => _$SubsetFromJson(json);

  Map<String, dynamic> toJson() => _$SubsetToJson(this);

  @override
  String createTM1Path() {
    return 'api/v1/Dimensions(\'$dimensionName\')/Hierarchies(\'$hierarchyName\')/Subsets';
  }

  @override
  String body() {
    Map<String, dynamic> bodyMap = {};
    bodyMap.addAll({'Name': name});
    alias != '' ? bodyMap.addAll({'Alias': alias}) : {};
    bodyMap.addAll({
      'Hierarchy@odata.bind':
      'Dimensions(\'$dimensionName\')/Hierarchies(\'$hierarchyName\')'
    });
    bodyMap.addAll(createExpressionOrListOfElement());
    return json.encode(bodyMap);
  }

  Map<String, dynamic> createExpressionOrListOfElement() {
    Map<String, dynamic> bodyMap = {};
    if (isDynamic) {
      bodyMap.addAll({'Expression': expression});
    } else {
      var statement =
          'Dimensions(\'$dimensionName\')/Hierarchies(\'$hierarchyName\')/Elements';
      //var listOfElements='[';
      var listOfElements = [];
      var fullElementName = '';
      for (Element element in elements.values) {
        fullElementName = statement + '(\'${element.name}\')';
        listOfElements.add(fullElementName);
      }
      //listOfElements = listOfElements.substring(0,listOfElements.length-1);
      bodyMap.addAll({'Elements@odata.bind': listOfElements});
    }

    return bodyMap;
  }
}
