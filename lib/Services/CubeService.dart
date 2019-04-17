import 'dart:convert';

import 'package:tm1_dart/Objects/Cube.dart';
import 'package:tm1_dart/Objects/TM1Object.dart';
import 'package:tm1_dart/Services/ObjectService.dart';
import 'package:tm1_dart/Utils/JsonConverter.dart';

class CubeService extends ObjectService{
  Future<Cube> getCube(String cubeName) async{
    var bodyReturned = await restConnection.runGet(
        'api/v1/Cubes(\'$cubeName\')');
    var decodedJson = jsonDecode(await transformJson(bodyReturned));
    Cube cube = Cube.fromJson(decodedJson);
    cube.dimensions = await getDimensions(cube);
    return cube;
  }


  Future<List<String>> getDimensions(TM1Object cube, {getControl}) async {
    //return list of dimensions
    Map<String, dynamic> parametersMap = {};
    parametersMap.addAll({'\$select': 'Name'});
    Cube cubeFromObject = cube as Cube;
    var bodyReturned = await restConnection.runGet(
        cubeFromObject.createTM1Path()+'(\'${cube.name}\')/Dimensions',
        parameters: parametersMap);
    var decodedJson = jsonDecode(await transformJson(bodyReturned));
    List<dynamic> objectsMap = decodedJson['value'];
    var namesList = objectsMap
        .map((name) => name.toString().substring(7, name.toString().length - 1))
        .toList();
    return namesList;
  }
}