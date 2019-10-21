//TODO tests for axis

import 'package:flutter_test/flutter_test.dart';
import 'package:tm1_dart/Objects/Axis/ViewAxisSelection.dart';
import 'package:tm1_dart/Objects/Axis/ViewTitleSelection.dart';
import 'package:tm1_dart/Objects/Element.dart';
import 'package:tm1_dart/Objects/Subset.dart';
import 'package:tm1_dart/Services/ElementService.dart';
import 'package:tm1_dart/Services/RESTConnection.dart';
import 'package:tm1_dart/Services/SubsetService.dart';

import '../UtilsForTest/ConnectionUtils.dart';

void main() async {
  String ip = await getIp();
  RESTConnection restConnection = RESTConnection.initialize(
      "https",
      ip,
      8010,
      "admin",
      "apple",
      true,
      "",
      false,
      false);
  String dimName = 'account1';
  String hierName = 'account1';
  Map<String, dynamic> testMap = {
    "Name": "All Members",
    "UniqueName": "[$dimName].[All Members]",
    // "Expression": "[$dimName].MEMBERS",
    "Expression": "[some kind of expression]",
    "Alias": ""
  };
  Map<String, dynamic> testMapElement = {
    'Name': 'aa',
    'UniqueName': 'uName',
    'Type': 'Numeric',
    'Index': 0,
    'Level': 0
  };
  String elementName = 'Price';
  Element element = await ElementService().getElement(
      hierName, dimName, elementName);
  String staticSubsetName = 'Default';
  Subset testingSubsetWithElements = await SubsetService().getSubset(
      dimName, hierName, staticSubsetName);



  test('check if subset named axes is correctly created', () async {
    ViewAxisSelection testSelection =
    ViewAxisSelection(testingSubsetWithElements, dimName, hierName);
    var actualString =
        '{"Subset@odata.bind":"Dimensions(\'$dimName\')/Hierarchies(\'$hierName\')/Subsets(\'${testingSubsetWithElements
        .name}\')"}';
    expect(testSelection.body(), actualString);
  });
  test('check if named subset with select is correctly created', () async {
    ViewTitleSelection testSelection =
    ViewTitleSelection(testingSubsetWithElements, dimName, hierName, 'Actual');
    var actualString =
        '{"Subset@odata.bind":"Dimensions(\'$dimName\')/Hierarchies(\'$hierName\')/Subsets(\'${testingSubsetWithElements
        .name}\')",'
        '"Selected@odata.bind":"Dimensions(\'$dimName\')/Hierarchies(\'$hierName\')/Elements(\'Actual\')"}';
    expect(testSelection.body(), actualString);
  });
  /*test('check if axis without subset is correctly created', () async {
    ViewAxisSelection testSelection =
    ViewAxisSelection(unregSubset, dimName, hierName);
    var actualString =
        '{"Subset":{"Hierarchy@odata.bind":"Dimensions(\'$dimName\')/Hierarchies(\'$hierName\')","Expression":"${unregSubset
        .expression}"}}';
    expect(testSelection.body(), actualString);
  });*/
  //TODO check how elements based subset should be created and what is the output
  test('check if axis with elements is correctly created', () async {
    ViewAxisSelection testSelection =
    ViewAxisSelection(testingSubsetWithElements, dimName, hierName);
    var actualString =
        '{"Subset":{"Hierarchy@odata.bind":"Dimensions(\'$dimName\')/Hierarchies(\'$hierName\')","Expression":"${testingSubsetWithElements
        .elements}"}}';
    expect(testSelection.body(), actualString);
  });
}
