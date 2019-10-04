import 'package:tm1_dart/Objects/TM1Object.dart';
import 'package:tm1_dart/Utils/JsonConverter.dart';

import 'RESTConnection.dart';
import 'dart:convert';

abstract class ObjectService {
  RESTConnection restConnection = RESTConnection.restConnection;

  Future<bool> create(TM1Object tm1object) async {
    var request = tm1object.createTM1Path();
    String body = tm1object.body();
    if (!await checkIfExists(tm1object)) {
      await restConnection.runPost(request, {}, body);
      return true;
    } else {
      return false;
    }
  }

  Future<bool> delete(TM1Object tm1object) async {
    var request = tm1object.createTM1Path() + '(\'${tm1object.name}\')';
    if (await checkIfExists(tm1object)) {
      await restConnection.runDelete(request);
      return true;
    } else {
      return false;
    }
  }

  Future<List<String>> getObjects(TM1Object objectClass,
      {bool getControl=false}) async {
    ///general process to get list of entities, works for Cubes, Dimensions and Chores
    String baseURL = objectClass.createTM1Path();
    String excluded = (getControl) ? '{' : '}';
    Map<String, dynamic> params = {
      '\$select': 'Name,Type',
      '\$filter': 'not startswith(Name,\'$excluded\')'
    };
    var bodyReturned = await restConnection.runGet(baseURL, parameters: params);
    var decodedJson = jsonDecode(await transformJson(bodyReturned));
    List<dynamic> objectsMap = decodedJson['value'];
    var namesList = objectsMap
        .map((name) => name.toString().substring(7, name.toString().length - 1))
        .toList();
    return (namesList);
  }

  Future<bool> checkIfExists(TM1Object objectClass) async {
    bool returnedBool = true;
    String baseURL = objectClass.createTM1Path() + '/\$count';
    Map<String, dynamic> params = {
      '\$filter': 'Name eq \'${objectClass.name}\''
    };
    var bodyReturned = await restConnection.runGet(baseURL, parameters: params);
    var checkedValue = await transformJson(bodyReturned);

    if (checkedValue == '0') {
      returnedBool = false;
    }
    return returnedBool;
  }

  Future<Map<String, dynamic>> getObjectsAsaMap(TM1Object tm1object) async {
    //returns elements as name:type map
    List<String> namesList = await getObjects(tm1object);
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
