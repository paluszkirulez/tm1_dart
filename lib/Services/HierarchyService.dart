import 'dart:convert';

import 'package:tm1_dart/Objects/Hierarchy.dart';
import 'package:tm1_dart/Objects/TM1Object.dart';
import 'package:tm1_dart/Services/ObjectService.dart';
import 'package:tm1_dart/Utils/JsonConverter.dart';

class HierarchyService extends ObjectService {

  //TODO get all subsets within given hierarchy
  Future<Hierarchy> getHierarchy(
      String dimensionName, String hierarchyName) async {
    var bodyReturned = await restConnection.runGet(
        'api/v1/Dimensions(\'$dimensionName\')/Hierarchies(\'$hierarchyName\')');
    var decodedJson = jsonDecode(await transformJson(bodyReturned));


    Hierarchy hierarchy = Hierarchy.fromJson(dimensionName, decodedJson);

    hierarchy.elements = await getElements(hierarchy);
    return hierarchy;
  }

  Future<List<String>> getElements(TM1Object hierarchy, {getControl}) async {
    //returns all elements as list
    Map<String, dynamic> parametersMap = {};
    parametersMap.addAll({'\$select': 'Name,Type'});
    Hierarchy hierarchyFromObject = hierarchy as Hierarchy;
    var bodyReturned = await restConnection.runGet(
        'api/v1/Dimensions(\'${hierarchyFromObject.dimension}\')/Hierarchies(\'${hierarchyFromObject.name}\')/Elements',
        parameters: parametersMap);
    var decodedJson = jsonDecode(await transformJson(bodyReturned));
    List<dynamic> objectsMap = decodedJson['value'];
    var namesList = objectsMap
        .map((name) => name.toString().substring(7, name.toString().length - 1))
        .toList();
    return namesList;
  }

  Future<int> getNumberOfElements(TM1Object hierarchy, {getControl}) async {
    List<String> namesList = await getElements(
        hierarchy, getControl: getControl);
    return namesList.length;
  }

  Future<Map<String, dynamic>> getElementsAsaMap(TM1Object tm1object,
      {getControl}) async {
    //returns elements as name:type map
    List<String> namesList = await getElements(
        tm1object, getControl: getControl);
    Map<String, dynamic> nameTypeMap = <String, dynamic>{};
    List<String> tempList = <String>[];
    for (int a = 0; a < namesList.length; a++) {
      tempList = namesList[a].split(', ');
      nameTypeMap.addAll(
          {tempList[0]: tempList[1].replaceRange(0, 'Type: '.length, '')});
    }
    return nameTypeMap;
  }



  Future<Map<String, dynamic>> getAttributes(Hierarchy hierarchy) async {
    var bodyReturned = await restConnection.runGet(
        'api/v1/Dimensions(\'${hierarchy.dimension}\')/Hierarchies(\'${hierarchy.name}\')/ElementAttributes');
    var decodedJson = jsonDecode(await transformJson(bodyReturned));
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

  Future<String> getDefaultMember(Hierarchy hierarchy) async {
    var baseURL = 'api/v1/Dimensions(\'${hierarchy.dimension}\')/Hierarchies(\'${hierarchy.name}\')/DefaultMember/Name/\$value';
    var bodyReturned = await restConnection.runGet(baseURL);
    String decodedJson = await transformJson(bodyReturned);
    return decodedJson;
  }

  Future<List<String>> getSubsets(TM1Object hierarchy, {getControl}) async {
    //returns all elements as list
    Map<String, dynamic> parametersMap = {};
    parametersMap.addAll({'\$select': 'Name'});
    Hierarchy hierarchyFromObject = hierarchy as Hierarchy;
    var bodyReturned = await restConnection.runGet(
        'api/v1/Dimensions(\'${hierarchyFromObject
            .dimension}\')/Hierarchies(\'${hierarchyFromObject
            .name}\')/Subsets',
        parameters: parametersMap);
    var decodedJson = jsonDecode(await transformJson(bodyReturned));
    List<dynamic> objectsMap = decodedJson['value'];
    var namesList = objectsMap
        .map((name) =>
        name.toString().substring(7, name
            .toString()
            .length - 1))
        .toList();

    return namesList;
  }

  Future<int> getNumberOfSubsets(TM1Object hierarchy, {getControl}) async {
    List<String> namesList = await getSubsets(
        hierarchy, getControl: getControl);
    return namesList.length;
  }
  Future<bool> checkIfContainsElement(Hierarchy hierarchy,
      String element) async {
    Map<String, dynamic> allElements = await getElementsAsaMap(hierarchy);
    bool result = allElements.keys.contains(element);
    return result;
  }

  Future<List<Map<String, dynamic>>> getEdges(TM1Object hierarchy) async {
    Hierarchy hierarchyFromObject = hierarchy as Hierarchy;
    var bodyReturned = await restConnection.runGet(
        'api/v1/Dimensions(\'${hierarchyFromObject
            .dimension}\')/Hierarchies(\'${hierarchyFromObject
            .name}\')/Edges');

    var decodedJson = jsonDecode(await transformJson(bodyReturned));

    List<dynamic> listOfStrings = decodedJson['value'];
    List<Map<String, dynamic>> objectsMap = [];
    for (var i in listOfStrings) {
      Map<String, dynamic> pairs = i;
      objectsMap.add(pairs);
    }
    return objectsMap;
  }
}
