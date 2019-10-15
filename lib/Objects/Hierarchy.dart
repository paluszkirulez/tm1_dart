import 'dart:convert';

import 'Element.dart';
import 'TM1Object.dart';

class Hierarchy extends TM1Object {
  ///abstraction of hierarchy, consist of elements and keeps reference
  ///to its dimension


  //TODO check if in all palces list of elements consist of strings,not actual objects
  final String classType = 'Hierarchy';
  final String name;
  final String dimension;
  Map<String, Element> elements;
  List<String> subsets;
  List<Map<String, dynamic>> edges;

  Hierarchy(this.dimension, {this.name});

  factory Hierarchy.fromJson(
      String dimension, Map<String, dynamic> parsedJson) {
    return new Hierarchy(dimension,
        name: parsedJson['Name']);
  }


  @override
  String createTM1Path() {
    return 'api/v1/Dimensions(\'$dimension\')/Hierarchies';
  }

  @override
  String body() {
    Map<String, dynamic> bodyMap = {
      'Name': name,
    };
    return json.encode(bodyMap);
  }


}
