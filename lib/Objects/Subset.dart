import 'TM1Object.dart';
import 'Element.dart';
import 'dart:convert';

class Subset extends TM1Object {
  final String classType = 'Subset';
  final String name;
  final String dimensionName;
  final String hierarchyName;
  bool private;
  String aliasApplied;
  List<Element> elements = [];
  bool isDynamic = false;
  String MDX = '';

  //TODO add prvatesubsets by adding boolean and using 'PrivateSubsets' in baseurl
  Subset(this.dimensionName, this.hierarchyName,
      {this.name,
        this.aliasApplied,
        this.elements,
        this.isDynamic = false,
        this.MDX,
        this.private = false});

  factory Subset.fromJson(String dimensionName, String hierarchyName,
      Map<String, dynamic> parsedJson) {
    return new Subset(dimensionName, hierarchyName,
        name: parsedJson['Name'],
        MDX: parsedJson['Expression'],
        aliasApplied: parsedJson['Alias'],
        private: parsedJson['Private'],
        isDynamic: parsedJson['Expression'] != '[$dimensionName].MEMBERS'
            ? parsedJson['Expression'] != null ? true : false
            : false);
  }

  @override
  String createTM1Path() {
    return 'api/v1/Dimensions(\'$dimensionName\')/Hierarchies(\'$hierarchyName\')/Subsets';
  }

  @override
  String body() {
    Map<String, dynamic> bodyMap = {};
    bodyMap.addAll({'Name': name});
    aliasApplied != '' ? bodyMap.addAll({'Alias': aliasApplied}) : {};
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
      bodyMap.addAll({'Expression': MDX});
    } else {
      var statement =
          'Dimensions(\'$dimensionName\')/Hierarchies(\'$hierarchyName\')/Elements';
      //var listOfElements='[';
      var listOfElements = [];
      var fullElementName = '';
      for (Element element in elements) {
        fullElementName = statement + '(\'${element.name}\')';
        listOfElements.add(fullElementName);
      }
      //listOfElements = listOfElements.substring(0,listOfElements.length-1);
      bodyMap.addAll({'Elements@odata.bind': listOfElements});
    }

    return bodyMap;
  }
}
