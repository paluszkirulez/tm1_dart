import 'package:tm1_dart/Objects/Element.dart';
import 'package:tm1_dart/Objects/Hierarchy.dart';
import 'package:tm1_dart/Objects/TM1Object.dart';
import 'package:tm1_dart/Services/ObjectService.dart';
import 'package:tm1_dart/Services/RESTConnection.dart';
import 'dart:convert';

class ElementService extends ObjectService {
  /// this class is managing elements in hierarchies and dimensions
  ///
  static RESTConnection restConnection = RESTConnection.restConnection;

  Future<Element> getElement(
      String dimensionName, String hierarchyName, String elementName) async {
    var bodyReturned = await restConnection.runGet(
        'api/v1/Dimensions(\'$dimensionName\')/Hierarchies(\'$hierarchyName\')/Elements(\'$elementName\')');
    var decodedJson = jsonDecode(bodyReturned);
    Map<String, dynamic> tempList = new Map<String, dynamic>.from(decodedJson);
    //print(tempList);
    Element element =
        Element.fromJson(dimensionName, hierarchyName, decodedJson);
    print(element.toString());
    return element;
  }

  Future<bool> createElement(Element element) async {
    var request = element.createTM1Path();
    String body = element.body();
    if (!await checkIfExists(element)) {
      await restConnection.runPost(request, {}, body);
      return true;
    } else {
      return false;
    }
  }

  Future<Map<String, dynamic>> getElementAttributes(Element element) async {
    var bodyReturned = await restConnection.runGet(
        'api/v1/Dimensions(\'${element.dimension}\')/Hierarchies(\'${element.hierarchy}\')/ElementAttributes');
    var decodedJson = jsonDecode(bodyReturned);
    List<dynamic> objectsMap = decodedJson['value'];
    List<String> namesList = objectsMap
        .map((name) => name.toString().substring(7, name.toString().length - 1))
        .toList();
    Map<String, dynamic> nameTypeMap = <String, dynamic>{};
    List<String> tempList = <String>[];
    for (int a = 0; a < namesList.length - 1; a++) {
      tempList = namesList[a].split(', ');
      nameTypeMap.addAll(
          {tempList[0]: tempList[1].replaceRange(0, 'Type: '.length, '')});
    }
    return nameTypeMap;
  }
}
