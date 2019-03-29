import 'package:tm1_dart/Objects/Element.dart';
import 'package:tm1_dart/Objects/Hierarchy.dart';
import 'package:tm1_dart/Objects/TM1Object.dart';
import 'package:tm1_dart/Services/ObjectService.dart';
import 'package:tm1_dart/Services/RESTConnection.dart';
import 'dart:convert';

class ElementService extends ObjectService {
  /// this class is managing elements in hierarchies and dimensions
  ///
  static RESTConnection restConnection = RESTConnection.restConnection;

  Future<Element> getElement(
      String dimensionName, String hierarchyName, String elementName) async {
    var bodyReturned = await restConnection.runGet(
        'api/v1/Dimensions(\'$dimensionName\')/Hierarchies(\'$hierarchyName\')/Elements(\'$elementName\')');
    var decodedJson = jsonDecode(bodyReturned);
    Map<String, dynamic> tempList = new Map<String, dynamic>.from(decodedJson);
    //print(tempList);
    Element element =
        Element.fromJson(dimensionName, hierarchyName, decodedJson);
    print(element.toString());
    return element;
  }

  Future<bool> createElement(Element element) async {
    var request = element.createTM1Path();
    String body = element.body();
    if (!await checkIfExists(element)) {
      await restConnection.runPost(request, {}, body);
      return true;
    } else {
      return false;
    }
  }

  Future<Map<String, dynamic>> getElementAttributes(Element element) async {
    //TODO get this class to dimension service class
    var bodyReturned = await restConnection.runGet(
        'api/v1/Dimensions(\'${element.dimension}\')/Hierarchies(\'${element.hierarchy}\')/ElementAttributes');
    var decodedJson = jsonDecode(bodyReturned);
    List<dynamic> objectsMap = decodedJson['value'];
    List<String> namesList = objectsMap
        .map((name) => name.toString().substring(7, name.toString().length - 1))
        .toList();
    Map<String, dynamic> nameTypeMap = <String, dynamic>{};
    List<String> tempList = <String>[];
    for (int a = 0; a < namesList.length - 1; a++) {
      tempList = namesList[a].split(', ');
      nameTypeMap.addAll(
          {tempList[0]: tempList[1].replaceRange(0, 'Type: '.length, '')});
    }
    return nameTypeMap;
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
    Map<String, dynamic> decodedJson = jsonDecode(bodyReturned);
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

    return listOfElement;
  }
}
