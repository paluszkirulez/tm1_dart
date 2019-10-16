import 'dart:convert';
import 'dart:math';

import 'package:tm1_dart/Objects/Cube.dart';
import 'package:tm1_dart/Objects/Dimension.dart';
import 'package:tm1_dart/Objects/Element.dart';
import 'package:tm1_dart/Objects/Hierarchy.dart';
import 'package:tm1_dart/Services/DimensionService.dart';
import 'package:tm1_dart/Services/HierarchyService.dart';
import 'package:tm1_dart/Services/ObjectService.dart';
import 'package:tm1_dart/Utils/JsonConverter.dart';

class CubeService extends ObjectService{
  Future<Cube> getCube(String cubeName) async{
    var bodyReturned = await restConnection.runGet(
        'api/v1/Cubes(\'$cubeName\')');
    var decodedJson = jsonDecode(await transformJson(bodyReturned));
    Map<String, dynamic> objectMap = {};
    objectMap.addAll(decodedJson);
    objectMap.addAll({'Dimensions': await getDimensions(cubeName)});
    Cube cube = Cube.fromJson(objectMap);
    return cube;
  }


  Future<List<Dimension>> getDimensions(String cubeName, {getControl}) async {
    //return list of dimensions
    Map<String, dynamic> parametersMap = {};
    parametersMap.addAll({'\$select': 'Name'});

    var bodyReturned = await restConnection.runGet(
        'api/v1/Cubes' + '(\'${cubeName}\')/Dimensions',
        parameters: parametersMap);
    var decodedJson = jsonDecode(await transformJson(bodyReturned));
    List<dynamic> listOfStrings = decodedJson['value'];
    List<Dimension> objectsMap = [];
    for (var i in listOfStrings) {
      Map<String, dynamic> pair = i;
      String name = pair['Name'];
      Dimension dimension = await DimensionService().getDimension(name);
      objectsMap.add(dimension);
    }

    return objectsMap;
  }

  Future<List<String>> getRandomIntersection(String cubeName) async {
    /// random intersaction of a cube, used for testing
    /// not optimized
    ///
    List<Dimension> dimensions = await getDimensions(cubeName);
    List<String> dimensionsInCube = dimensions.map((a) => a.name).toList();
    List<String> returnedElements = [];
    for (String dimension in dimensionsInCube) {
      Hierarchy hierarchy = await HierarchyService().getHierarchy(
          dimension, dimension);
      Map<String, Element> listOfElement = await HierarchyService().getElements(
          dimension, hierarchy.name);
      List<String> elements = listOfElement.keys.toList();

      String element = elements[Random().nextInt(elements.length)];
      returnedElements.add(element);
    }
    return returnedElements;
  }
}