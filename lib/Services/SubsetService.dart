import 'dart:convert';

import 'package:tm1_dart/Objects/Subset.dart';
import 'package:tm1_dart/Services/ObjectService.dart';
import 'package:tm1_dart/Services/RESTConnection.dart';
import 'package:tm1_dart/Utils/JsonConverter.dart';

class SubsetService extends ObjectService {
  /// class servicing operation related to subsets
  static RESTConnection restConnection = RESTConnection.restConnection;
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
}
