import 'dart:convert';

import 'package:tm1_dart/Objects/Dimension.dart';
import 'package:tm1_dart/Objects/TM1Object.dart';
import 'package:tm1_dart/Services/ObjectService.dart';
import 'package:tm1_dart/Utils/JsonConverter.dart';


class DimensionService extends ObjectService{


  Future<Dimension> getDimension(String dimensionName) async{
    var bodyReturned = await restConnection.runGet(
        'api/v1/Dimensions(\'$dimensionName\')');
    var decodedJson = jsonDecode(await transformJson(bodyReturned));
    Dimension dimension = Dimension.fromJson(decodedJson);
    dimension.hierarchies = await getHierarchies(dimension);
    return dimension;
  }

  Future<List<String>> getHierarchies(TM1Object dimension, {getControl}) async {
    //return list of hierarchies
    Map<String, dynamic> parametersMap = {};
    parametersMap.addAll({'\$select': 'Name'});
    Dimension dimensionFromObject = dimension as Dimension;
    var bodyReturned = await restConnection.runGet(
        'api/v1/Dimensions(\'${dimensionFromObject.name}\')/Hierarchies',
        parameters: parametersMap);
    var decodedJson = jsonDecode(await transformJson(bodyReturned));
    List<dynamic> objectsMap = decodedJson['value'];
    var namesList = objectsMap
        .map((name) => name.toString().substring(7, name.toString().length - 1))
        .toList();
    return namesList;
  }

  Future<String> getDefaultHierarchy(TM1Object dimension) async {
    Map<String, dynamic> parametersMap = {};
    parametersMap.addAll({'\$select': 'Name'});
    Dimension dimensionFromObject = dimension as Dimension;
    var bodyReturned = await restConnection.runGet(
        'api/v1/Dimensions(\'${dimensionFromObject.name}\')/DefaultHierarchy',
        parameters: parametersMap);
    var decodedJson = jsonDecode(await transformJson(bodyReturned));
    return decodedJson['Name'];
  }

}