import 'dart:convert';

import 'package:tm1_dart/Objects/Subset.dart';
import 'package:tm1_dart/Objects/TM1Object.dart';
import 'package:tm1_dart/Services/ObjectService.dart';
import 'package:tm1_dart/Services/RESTConnection.dart';
import 'package:tm1_dart/Utils/JsonConverter.dart';

class SubsetService extends ObjectService {
  /// class servicing operation related to subsets

  //TODO get all elements within given subset
  Future<Subset> getSubset(
      String dimensionName, String hierarchyName, String subsetName) async {
    Map<String, dynamic> parametersMap = {};
    parametersMap.addAll({'\$select': '*,Alias'});
    var bodyReturned = await restConnection.runGet(
        'api/v1/Dimensions(\'$dimensionName\')/Hierarchies(\'$hierarchyName\')/Subsets(\'$subsetName\')',
        parameters: parametersMap);
    var decodedJson =  jsonDecode(await transformJson(bodyReturned));
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

}
