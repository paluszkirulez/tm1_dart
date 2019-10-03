import 'dart:convert';

import 'package:tm1_dart/Objects/Subset.dart';
import 'package:tm1_dart/Objects/TM1Object.dart';
import 'package:tm1_dart/Services/ObjectService.dart';
import 'package:tm1_dart/Services/RESTConnection.dart';
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
    var decodedJson =  jsonDecode(await transformJson(bodyReturned));
    //print(dimensionName+' '+decodedJson.toString()+' '+parametersMap.toString());
    Subset subset = Subset.fromJson(dimensionName, hierarchyName, decodedJson);
    return subset;
  }
  Future<List<String>> getElements(TM1Object subset, {getControl}) async {
    Map<String, dynamic> parametersMap = {};
    parametersMap.addAll({'\$select': 'Name,Type'});
    Subset subsetFromObject = subset as Subset;
    var bodyReturned = await restConnection.runGet(
        subset.createTM1Path() + '(\'${subsetFromObject.name}\')/Elements',
        parameters: parametersMap);
    var decodedJson = jsonDecode(await transformJson(bodyReturned));
    List<dynamic> objectsMap = decodedJson['value'];
    var namesList = objectsMap
        .map((name) => name.toString().substring(7, name.toString().length - 1))
        .toList();
    return namesList;

  }

  Future<Map<String, dynamic>> getElementsAsaMap(TM1Object tm1object) async {
    //returns elements as name:type map
    List<String> namesList = await getElements(tm1object);
    Map<String, dynamic> nameTypeMap = <String, dynamic>{};
    List<String> tempList = <String>[];
    for (int a = 0; a < namesList.length; a++) {
      tempList = namesList[a].split(', ');
      nameTypeMap.addAll(
          {tempList[0]: tempList[1].replaceRange(0, 'Type: '.length, '')});
    }
    return nameTypeMap;
  }

}
