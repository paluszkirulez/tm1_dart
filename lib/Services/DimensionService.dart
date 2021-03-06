import 'dart:convert';

import 'package:tm1_dart/Objects/Dimension.dart';
import 'package:tm1_dart/Objects/Hierarchy.dart';
import 'package:tm1_dart/Objects/TM1Object.dart';
import 'package:tm1_dart/Services/HierarchyService.dart';
import 'package:tm1_dart/Services/ObjectService.dart';
import 'package:tm1_dart/Utils/JsonConverter.dart';


class DimensionService extends ObjectService{


  Future<Dimension> getDimension(String dimensionName) async{
    var bodyReturned = await restConnection.runGet(
        'api/v1/Dimensions(\'$dimensionName\')');
    var decodedJson = jsonDecode(await transformJson(bodyReturned));
    Map<String, dynamic> objectMap = {};
    objectMap.addAll(decodedJson);
    objectMap.addAll({'Hierarchies': await getHierarchies(dimensionName)});
    Dimension dimension = Dimension.fromJson(decodedJson);

    return dimension;
  }

  Future<List<Hierarchy>> getHierarchies(String dimensionName,
      {getControl}) async {
    //return list of hierarchies
    Map<String, dynamic> parametersMap = {};
    parametersMap.addAll({'\$select': 'Name'});

    var bodyReturned = await restConnection.runGet(
        'api/v1/Dimensions(\'${dimensionName}\')/Hierarchies',
        parameters: parametersMap);
    var decodedJson = jsonDecode(await transformJson(bodyReturned));
    List<dynamic> listOfStrings = decodedJson['value'];
    List<Hierarchy> objectsMap = [];
    for (var i in listOfStrings) {
      Map<String, dynamic> pair = i;
      String name = pair['Name'];
      Hierarchy nameHierarchy = await HierarchyService().getHierarchy(
          dimensionName, name);
      objectsMap.add(nameHierarchy);
    }

    return objectsMap;
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