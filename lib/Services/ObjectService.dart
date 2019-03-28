import 'package:tm1_dart/Objects/TM1Object.dart';

import 'RESTConnection.dart';
import 'dart:convert';
abstract class ObjectService {

  static RESTConnection restConnection = RESTConnection.restConnection;

  Future<List<String>> getObjects (String objectClass, bool getControl) async {
    ///general process to get list of elements, works for Cubes, Dimensions and Chores
    String baseURL = 'api/v1/$objectClass';
    String excluded = (getControl) ? '{': '}';
    Map<String,dynamic> params = {'\$select':'Name','\$filter':'not startswith(Name,\'$excluded\')'};
    var bodyReturned = await restConnection.runGet(baseURL, parameters: params);
    var decodedJson = jsonDecode(bodyReturned);
    List<dynamic> objectsMap= decodedJson['value'];
    var namesList = objectsMap.map((name)=>name.toString().substring(7,name.toString().length-1)).toList();
    return(namesList);
  }
  Future<bool> checkIfExists(TM1Object objectClass) async {
    bool returnedBool = true;

    String baseURL = objectClass.createTM1Path()+'/\$count';
    print(objectClass.createTM1Path());
    Map<String,dynamic> params = {'\$filter':'Name eq \'${objectClass.name}\''};
    var bodyReturned = await restConnection.runGet(baseURL, parameters: params);
    if(bodyReturned == '0'){
      returnedBool = false;
    }
    return returnedBool;
  }
}