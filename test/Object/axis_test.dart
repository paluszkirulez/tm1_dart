//TODO tests for axis

import 'package:tm1_dart/Objects/Element.dart';
import 'package:tm1_dart/Objects/Subset.dart';
import 'package:tm1_dart/Objects/UnregSubset.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tm1_dart/Objects/Axis/ViewAxisSelection.dart';
import 'package:tm1_dart/Objects/Axis/ViewTitleSelection.dart';

void main() {
  //String ipAddress = await GetIp.ipAddress;
 /* String ipAddress = '10.113.171.159';
  RESTConnection restConnection = RESTConnection.initialize(
      "https", ipAddress, 8010, "admin", "apple", true, "", false, false);*/
  String dimName = 'actvsbud';
  String hierName = 'actvsbud';
  Map<String, dynamic> testMap = {
    "Name": "All Members",
    "UniqueName": "[$dimName].[All Members]",
   // "Expression": "[$dimName].MEMBERS",
    "Expression":"[some kind of expression]",
    "Alias": ""
  };
  Map<String,dynamic> testMapElement = {'Name':'aa','UniqueName':'uName','Type':'Numeric','Index':0,'Level':0};
  Element element = Element.fromJson('account','account',testMapElement);
  Map<String, dynamic> testAxisOfElements = {
    "Name": "All Members",
    "UniqueName": "[$dimName].[All Members]",
    "Expression": "[$dimName].MEMBERS",
    //"Expression":"[some kind of expression]",
    "Alias": ""
  };
  Subset testingSubsetWithElements = Subset.fromJson(dimName, hierName, testAxisOfElements);
  testingSubsetWithElements.elements = [element];

  Subset testingSubset = Subset.fromJson(dimName, hierName, testMap);
  UnregSubset unregSubset = UnregSubset.fromJson(dimName,hierName,testMap);

  test('check if subset named axes is correctly created', () async {
    ViewAxisSelection testSelection =
        ViewAxisSelection(testingSubset, dimName, hierName);
    var actualString =
        '{"Subset@odata.bind":"Dimensions(\'$dimName\')/Hierarchies(\'$hierName\')/Subsets(\'${testingSubset.name}\')"}';
    expect(testSelection.body(), actualString);
  });
  test('check if named subset with select is correctly created', () async {
    ViewTitleSelection testSelection =
    ViewTitleSelection(testingSubset,dimName,hierName,'Actual');
    var actualString =
        '{"Subset@odata.bind":"Dimensions(\'$dimName\')/Hierarchies(\'$hierName\')/Subsets(\'${testingSubset.name}\')",'
        '"Selected@odata.bind":"Dimensions(\'$dimName\')/Hierarchies(\'$hierName\')/Elements(\'Actual\')"}';
    expect(testSelection.body(), actualString);
  });
  test('check if axis without subset is correctly created', () async {
    ViewAxisSelection testSelection =
    ViewAxisSelection(unregSubset,dimName,hierName);
    var actualString ='{"Subset":{"Hierarchy@odata.bind":"Dimensions(\'$dimName\')/Hierarchies(\'$hierName\')","Expression":"${unregSubset.MDX}"}}';
    expect(testSelection.body(), actualString);
  });
  //TODO check how elements based subset should be created and what is the output
/*  test('check if axis with elements is correctly created', () async {
    ViewAxisSelection testSelection =
    ViewAxisSelection(testingSubsetWithElements,dimName,hierName);
    var actualString ='{"Subset":{"Hierarchy@odata.bind":"Dimensions(\'$dimName\')/Hierarchies(\'$hierName\')","Expression":"${testingSubsetWithElements.elements}"}}';
    expect(testSelection.body(), actualString);
  });*/
}
