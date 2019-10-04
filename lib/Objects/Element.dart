import 'TM1Object.dart';
import '../Utils/ElementType.dart';
import 'dart:convert';

class Element extends TM1Object {
  ///class that represents element
  final String classType = 'Element';
  final String name;
  final String uniqueName;
  final String elementType;
  final int index;
  final int level;
  final String dimension;
  final String hierarchy;
  Map<String, dynamic> attributes;

  @override
  String createTM1Path() {
    return 'api/v1/Dimensions(\'$dimension\')/Hierarchies(\'$hierarchy\')/Elements';
  }

  //List<String> availableTypes = ElementType.values.map((e)=>e.toString());

  Element(this.dimension, this.hierarchy,
      {this.name, this.uniqueName, this.elementType, this.index, this.level, this.attributes});

  factory Element.fromJson(String dimension, String hierarchy,
      Map<String, dynamic> parsedJson, {bool withAttributes = false}) {
    return new Element(dimension, hierarchy,
        name: parsedJson['Name'],
        uniqueName: parsedJson['UniqueName'],
        elementType: parsedJson['Type'],
        level: parsedJson['Level'],
        attributes: withAttributes ? parsedJson['Attributes'] : new Map());
  }

  @override
  String body() {
    Map<String, dynamic> bodyMap = {
      'Name': name,
      'Type': elementType
    };
    return json.encode(bodyMap);
  }

  @override
  String toString() {
    return 'Element{name: $name, uniqueName: $uniqueName, elementType: $elementType, index: $index, level: $level}';
  }
}
