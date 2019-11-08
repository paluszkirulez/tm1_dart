import 'dart:convert';
import 'dart:io';

import 'package:tm1_dart/Objects/Element.dart';
import 'package:tm1_dart/Objects/Subset.dart';
import 'package:tm1_dart/Services/ElementService.dart';
import 'package:tm1_dart/Services/ObjectService.dart';
import 'package:tm1_dart/Utils/JsonConverter.dart';

class SubsetService extends ObjectService {
  /// class servicing operation related to subsets

  //TODO push methods
  Future<Subset> getSubset(
      String dimensionName, String hierarchyName, String subsetName) async {
    Map<String, dynamic> parametersMap = {};
    parametersMap.addAll({'\$select': '*,Alias'});
    var bodyReturned = await restConnection.runGet(
        'api/v1/Dimensions(\'$dimensionName\')/Hierarchies(\'$hierarchyName\')/Subsets(\'$subsetName\')',
        parameters: parametersMap);
    var decodedJson = jsonDecode(await transformJson(bodyReturned));
    //print(dimensionName+' '+decodedJson.toString()+' '+parametersMap.toString());
    Map<String, dynamic> objectMap = {};
    objectMap.addAll(decodedJson);
    Map<String, Element> mapOfElements =
    await getElements(dimensionName, hierarchyName, subsetName);
    objectMap.addAll({'Elements': mapOfElements});
    objectMap.addAll({'dimensionName': dimensionName});
    objectMap.addAll({'hierarchyName': hierarchyName});
    Subset subset = Subset.fromJson(objectMap);
    bool isDynamic = false;
    if (![null, ''].contains(subset.expression)) {
      isDynamic = true;
    }


    subset.isDynamic = isDynamic;
    return subset;
  }

  Future<Map<String, Element>> getElements(String dimensionName,
      String hierarchyName, String subsetName,
      {getControl}) async {
    Map<String, dynamic> parametersMap = {};
    parametersMap.addAll({'\$select': 'Name,Type'});

    var bodyReturned = await restConnection.runGet(
        'api/v1/Dimensions(\'$dimensionName\')/Hierarchies(\'$hierarchyName\')/Subsets' +
            '(\'${subsetName}\')/Elements',
        parameters: parametersMap);
    var decodedJson = jsonDecode(await transformJson(bodyReturned));
    List<dynamic> listOfStrings = decodedJson['value'];
    Map<String, Element> objectsMap = {};
    for (var i in listOfStrings) {
      Map<String, dynamic> pair = i;
      String name = pair['Name'];
      Element nameElement =
      await ElementService().getElement(dimensionName, hierarchyName, name);

      objectsMap.addAll({name: nameElement});
    }

    return objectsMap;
  }

  Future<bool> checkIfElementExists(String dimensionName,
      String hierarchyName, String subsetName, String elementName,
      {getControl = false}) async {
    Map<String, Element> mapElements = await getElements(
        dimensionName, hierarchyName, subsetName, getControl: getControl);
    bool elementExists = false;
    if (mapElements.containsKey(elementName)) {
      elementExists = true;
    }
    return elementExists;
  }

  Future<bool> deleteElementFromSubset(String dimensionName,
      String hierarchyName, String subsetName, String elementName) async {
    Map<String, Element> mapElements = await getElements(
        dimensionName, hierarchyName, subsetName);
    bool elementDeleted = false;
    bool checkIfExist = await checkIfElementExists(
        dimensionName, hierarchyName, subsetName, elementName);
    if (!checkIfExist) {
      return elementDeleted;
    }
    var url = 'api/v1/Dimensions(\'$dimensionName\')/Hierarchies(\'$hierarchyName\')/Subsets(\'$subsetName\')/Elements(\'$elementName\')';
    HttpClientResponse response = await restConnection.runDelete(url);
    if ((response.statusCode >= 200) & (response.statusCode <= 230)) {
      elementDeleted = true;
    }
    return elementDeleted;
  }

  Future<bool> updateSubset(Subset subsetName) async {
    bool returnedResult = false;
    var body = subsetName.body();
    String path = subsetName.createTM1Path() + '(\'${subsetName.name}\')';
    HttpClientResponse response = await restConnection.runUpdate(
        path, {}, body);
    if ((response.statusCode >= 200) & (response.statusCode <= 230)) {
      returnedResult = true;
    }
    return returnedResult;
  }

}
