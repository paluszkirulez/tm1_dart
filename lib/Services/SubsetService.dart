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
  Future<Subset> getSubset(String dimensionName, String hierarchyName,
      String subsetName,
      {bool private = false}) async {
    Map<String, dynamic> parametersMap = {};
    String subsetType = private ? 'PrivateSubsets' : 'Subsets';
    parametersMap.addAll({
      '\$expand': 'Hierarchy(\$select=Name;\$expand=Dimension(\$select=Name)),Elements(\$select=*;\$expand: Hierarchy(\$select=Name;\$expand=Dimension(\$select=Name)))'
    });
    parametersMap.addAll({'\$select': '*,Alias'});
    var bodyReturned = await restConnection.runGet(
        'api/v1/Dimensions(\'$dimensionName\')/Hierarchies(\'$hierarchyName\')/$subsetType(\'$subsetName\')',
        parameters: parametersMap);

    var decodedJson = jsonDecode(await transformJson(bodyReturned));
    Map<String, dynamic> objectMap = {};
    objectMap.addAll(decodedJson);

    objectMap.addAll({'private': private});
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
      {getControl, bool private = false}) async {
    Map<String, dynamic> parametersMap = {};
    parametersMap.addAll({'\$select': 'Name,Type'});
    String subsetType = private ? 'PrivateSubsets' : 'Subsets';
    String path =
        'api/v1/Dimensions(\'$dimensionName\')/Hierarchies(\'$hierarchyName\')/$subsetType' +
            '(\'${subsetName}\')/Elements';
    var bodyReturned =
    await restConnection.runGet(path, parameters: parametersMap);
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

  Future<bool> checkIfElementExists(String dimensionName, String hierarchyName,
      String subsetName, String elementName,
      {getControl = false, bool private = false}) async {
    Map<String, Element> mapElements = await getElements(
        dimensionName, hierarchyName, subsetName,
        getControl: getControl, private: private);
    bool elementExists = false;
    if (mapElements.containsKey(elementName)) {
      elementExists = true;
    }
    return elementExists;
  }

  Future<bool> deleteElementFromSubset(String dimensionName,
      String hierarchyName, String subsetName, String elementName,
      {bool private = false}) async {
    bool elementDeleted = false;
    String subsetType = private ? 'PrivateSubsets' : 'Subsets';
    bool checkIfExist = await checkIfElementExists(
        dimensionName, hierarchyName, subsetName, elementName);

    if (!checkIfExist) {
      return elementDeleted;
    }
    var url =
        'api/v1/Dimensions(\'$dimensionName\')/Hierarchies(\'$hierarchyName\')/$subsetType(\'$subsetName\')/Elements(\'$elementName\')';
    HttpClientResponse response = await restConnection.runDelete(url);
    if ((response.statusCode >= 200) & (response.statusCode <= 230)) {
      elementDeleted = true;
    }
    return elementDeleted;
  }

/*  Future<bool> update(TM1Object subsetName) async {
    bool returnedResult = false;
    var body = subsetName.body();
    String path = subsetName.createTM1Path() + '(\'${subsetName.name}\')';
    HttpClientResponse response =
    await restConnection.runUpdate(path, {}, body);
    if ((response.statusCode >= 200) & (response.statusCode <= 230)) {
      returnedResult = true;
    }
    return returnedResult;
  }*/
}
