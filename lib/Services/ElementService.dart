import 'package:tm1_dart/Objects/Element.dart';
import 'package:tm1_dart/Objects/Hierarchy.dart';
import 'package:tm1_dart/Objects/TM1Object.dart';
import 'package:tm1_dart/Services/ObjectService.dart';
import 'package:tm1_dart/Services/RESTConnection.dart';
import 'dart:convert';

import 'package:tm1_dart/Utils/JsonConverter.dart';

class ElementService extends ObjectService {
  /// this class is managing elements in hierarchies and dimensions
  ///
  static RESTConnection restConnection = RESTConnection.restConnection;

  Future<Element> getElement(
      String dimensionName, String hierarchyName, String elementName) async {
    var bodyReturned = await restConnection.runGet(
        'api/v1/Dimensions(\'$dimensionName\')/Hierarchies(\'$hierarchyName\')/Elements(\'$elementName\')');
    var decodedJson =  jsonDecode(await transformJson(bodyReturned));
    //Map<String, dynamic> tempList = new Map<String, dynamic>.from(decodedJson);
    //print(tempList);
    Element element =
        Element.fromJson(dimensionName, hierarchyName, decodedJson);
    return element;
  }





  Future<Map<String, dynamic>> getMembersUnderConsolidation(Element element,
      {int maxDepth = 99, bool leavesOnly = false}) async {
    /// funtion gets elements that lies underneath element, by defualt
    /// user do not need to specify other parameter
    /// additional parameters
    /// maxDepth - by default 99, specifies how deep process should look for elements
    /// leavesOnly - if true gets only leaves

    String request = element.createTM1Path() + '(\'${element.name}\')';
    Map<String, dynamic> parametersMap = {};
    parametersMap.addAll({'\$select': 'Name,Type'});
    var expandString = 'Components(';
    for (int i = 0; i < maxDepth; i++) {
      expandString = expandString + '\$select=Name,Type;\$expand=Components(';
    }
    expandString =
        expandString.substring(0, expandString.length - 1) + ')' * maxDepth;
    parametersMap.addAll({'\$expand': expandString});
    var bodyReturned =
        await restConnection.runGet(request, parameters: parametersMap);
    Map<String, dynamic> decodedJson = jsonDecode(await transformJson(bodyReturned));
    Map<String, dynamic> listOfElement = {};
    void getMembers(Map<String, dynamic> decodedJson) {
      if (decodedJson['Type'] == 'Numeric') {
        listOfElement.addAll({decodedJson['Name']: decodedJson['Type']});
      } else if (decodedJson['Type'] == 'Consolidated') {
        if (decodedJson.containsKey('Components')) {
          for (var component in decodedJson['Components']) {
            if (leavesOnly) {
              if (component['Type'] == 'Numeric' ||
                  component['Type'] == 'Text') {
                listOfElement.addAll({component['Name']: component['Type']});
              }
            } else {
              listOfElement.addAll({component['Name']: component['Type']});
            }

            getMembers(component);
          }
        }
      }
    }
    getMembers(decodedJson);
    return listOfElement;
  }


}
