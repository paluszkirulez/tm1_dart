import 'dart:convert';

import 'package:tm1_dart/Objects/Element.dart';
import 'package:tm1_dart/Services/ObjectService.dart';
import 'package:tm1_dart/Utils/JsonConverter.dart';

class ElementService extends ObjectService {
  /// this class is managing elements in hierarchies and dimensions
  ///


  Future<Element> getElement(String dimensionName, String hierarchyName,
      String elementName, {bool withAttributes = false}) async {
    var bodyReturned = await restConnection.runGet(
        'api/v1/Dimensions(\'$dimensionName\')/Hierarchies(\'$hierarchyName\')/Elements(\'$elementName\')');
    var decodedJson =  jsonDecode(await transformJson(bodyReturned));


    Map<String, dynamic> tempList = {};
    tempList.addAll(decodedJson);
    tempList.addAll(
        {'dimensionName': dimensionName, 'hierarchyName': hierarchyName});

    Element element =
    Element.fromJson(tempList);
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

  Element _simpleCreate(String dimensionName, String hierarchyName,
      String elementName, {String type: 'Numeric'}) {
    Map<String, dynamic> mapForElement = {};
    mapForElement.addAll({'dimensionName': dimensionName});
    mapForElement.addAll({'hierarchyName': hierarchyName});
    mapForElement.addAll({'Name': elementName});
    mapForElement.addAll({'Type': type});
    Element element = Element.fromJson(mapForElement);
    return element;
  }

  Future<bool> createElement(String dimensionName, String hierarchyName,
      String elementName, {String type: 'Numeric'}) {
    Element element = _simpleCreate(
        dimensionName, hierarchyName, elementName, type: type);
    var created = create(element);
    return created;
  }

  Future<bool> deleteElement(String dimensionName, String hierarchyName,
      String elementName, {String type: 'Numeric'}) {
    Element element = _simpleCreate(
        dimensionName, hierarchyName, elementName, type: type);
    var deleted = delete(element);
    return deleted;
  }




}
