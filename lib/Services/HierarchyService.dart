import 'dart:convert';
import 'dart:io';

import 'package:tm1_dart/Objects/Element.dart';
import 'package:tm1_dart/Objects/Hierarchy.dart';
import 'package:tm1_dart/Objects/Subset.dart';
import 'package:tm1_dart/Services/ElementService.dart';
import 'package:tm1_dart/Services/ObjectService.dart';
import 'package:tm1_dart/Services/SubsetService.dart';
import 'package:tm1_dart/Utils/JsonConverter.dart';

class HierarchyService extends ObjectService {

  //TODO get all subsets within given hierarchy
  Future<Hierarchy> getHierarchy(
      String dimensionName, String hierarchyName) async {
    Map<String, dynamic> parameters = {'\$expand': 'Dimension(\$select=Name)'};
    var bodyReturned = await restConnection.runGet(
        'api/v1/Dimensions(\'$dimensionName\')/Hierarchies(\'$hierarchyName\')',
        parameters: parameters);
    var decodedJson = jsonDecode(await transformJson(bodyReturned));

    Map<String, dynamic> objectMap = {};
    objectMap.addAll(decodedJson);
    objectMap.addAll(
        {'Elements': await getElements(dimensionName, hierarchyName)});
    objectMap.addAll(
        {'Subsets': await getSubsets(dimensionName, hierarchyName)});
    objectMap.addAll({'Edges': await getEdges(dimensionName, hierarchyName)});
    Hierarchy hierarchy = Hierarchy.fromJson(objectMap);

    return hierarchy;
  }

  Future<Map<String, Element>> getElements(String dimensionName,
      String hierarchyName, {getControl}) async {
    //returns all elements as list
    Map<String, dynamic> parametersMap = {};
    parametersMap.addAll({'\$select': 'Name,Type'});

    var bodyReturned = await restConnection.runGet(
        'api/v1/Dimensions(\'${dimensionName}\')/Hierarchies(\'${hierarchyName}\')/Elements',
        parameters: parametersMap);
    var decodedJson = jsonDecode(await transformJson(bodyReturned));
    List<dynamic> listOfStrings = decodedJson['value'];
    Map<String, Element> objectsMap = {};
    for (var i in listOfStrings) {
      Map<String, dynamic> pair = i;
      String name = pair['Name'];
      Element nameElement = await ElementService().getElement(
          dimensionName, hierarchyName, name);
      objectsMap.addAll({name: nameElement});
    }

    return objectsMap;
  }

  Future<int> getNumberOfElements(String dimensionName, String hierarchyName,
      {getControl}) async {
    Map<String, Element> namesList = await getElements(
        dimensionName, hierarchyName, getControl: getControl);
    return namesList.length;
  }


  Future<Map<String, dynamic>> getAttributes(String dimensionName,
      String hierarchyName) async {
    var bodyReturned = await restConnection.runGet(
        'api/v1/Dimensions(\'${dimensionName}\')/Hierarchies(\'${hierarchyName}\')/ElementAttributes');
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

  Future<String> getDefaultMember(String dimensionName,
      String hierarchyName) async {
    var baseURL = 'api/v1/Dimensions(\'${dimensionName}\')/Hierarchies(\'${hierarchyName}\')/DefaultMember/Name/\$value';
    var bodyReturned = await restConnection.runGet(baseURL);
    String decodedJson = await transformJson(bodyReturned);
    return decodedJson;
  }

  Future<List<Subset>> getSubsets(String dimensionName, String hierarchyName,
      {getControl}) async {
    //returns all elements as list
    Map<String, dynamic> parametersMap = {};
    parametersMap.addAll({'\$select': 'Name'});

    var bodyReturned = await restConnection.runGet(
        'api/v1/Dimensions(\'${dimensionName}\')/Hierarchies(\'${hierarchyName}\')/Subsets',
        parameters: parametersMap);
    var decodedJson = jsonDecode(await transformJson(bodyReturned));
    List<dynamic> listOfStrings = decodedJson['value'];
    List<Subset> objectsMap = [];
    for (var i in listOfStrings) {
      Map<String, dynamic> pair = i;
      String name = pair['Name'];
      Subset subset = await SubsetService().getSubset(
          dimensionName, hierarchyName, name);
      objectsMap.add(subset);
    }

    return objectsMap;
  }

  Future<int> getNumberOfSubsets(String dimensionName, String hierarchyName,
      {getControl}) async {
    List<Subset> namesList = await getSubsets(
        dimensionName, hierarchyName, getControl: getControl);
    return namesList.length;
  }

  Future<bool> checkIfContainsElement(String dimensionName,
      String hierarchyName,
      String element) async {
    Map<String, Element> allElements = await getElements(
        dimensionName, hierarchyName);
    bool result = allElements.keys.contains(element);
    return result;
  }

  Future<List<Map<String, dynamic>>> getEdges(String dimensionName,
      String hierarchyName) async {

    var bodyReturned = await restConnection.runGet(
        'api/v1/Dimensions(\'${dimensionName}\')/Hierarchies(\'${hierarchyName}\')/Edges');

    var decodedJson = jsonDecode(await transformJson(bodyReturned));

    List<dynamic> listOfStrings = decodedJson['value'];
    List<Map<String, dynamic>> objectsMap = [];
    for (var i in listOfStrings) {
      Map<String, dynamic> pairs = i;
      objectsMap.add(pairs);
    }
    return objectsMap;
  }

  Future<bool> createEdges(String dimensionName, String hierarchyName,
      String parentName, String componentName, int weight) async {
    String connectionString = 'api/v1/Dimensions(\'${dimensionName}\')/Hierarchies(\'${hierarchyName}\')/Edges';

    String body = json.encode({
      'ParentName': parentName,
      'ComponentName': componentName,
      'Weight': weight
    });

    HttpClientResponse bodyReturned = await restConnection.runPost(
        connectionString, {}, body);
    bool created = false;
    if (bodyReturned.statusCode == 201) {
      created = true;
    }
    return created;
  }

  Future<bool> deleteAllEdges(String dimensionName,
      String hierarchyName) async {
    String connectionString = 'api/v1/Dimensions(\'${dimensionName}\')/Hierarchies(\'${hierarchyName}\')';

    String body = json.encode({"Edges": []});
    HttpClientResponse bodyReturned = await restConnection.runUpdate(
        connectionString, {}, body);
    bool deleted = false;
    if (bodyReturned.statusCode == 201) {
      deleted = true;
    }
    return deleted;
  }

  Future<bool> updateVisibility(String dimensionName, String hierarchyName,
      bool visible) async {
    String connectionString = 'api/v1/Dimensions(\'${dimensionName}\')/Hierarchies(\'${hierarchyName}\')';
    String body = json.encode({"Visible": visible});
    HttpClientResponse bodyReturned = await restConnection.runUpdate(
        connectionString, {}, body);
    bool changed = false;
    if ((bodyReturned.statusCode >= 200) & (bodyReturned.statusCode < 230)) {
      changed = true;
    }
    return changed;
  }

}
