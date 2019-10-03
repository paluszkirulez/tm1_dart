import 'package:tm1_dart/Objects/Element.dart';
import 'package:tm1_dart/Objects/Subset.dart';
import 'package:tm1_dart/Services/RESTConnection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tm1_dart/Services/SubsetService.dart';

import '../UtilsForTest/ConnectionUtils.dart';

void main() async {
  //String ipAddress = await GetIp.ipAddress;
  String ipAddress = await getIp();
  RESTConnection restConnection = RESTConnection.initialize(
      "https", ipAddress, 8010, "admin", "apple", true, "", false, false);
  String dimStatic = 'Month';
  String hierStatic = 'Month';
  String dimDynamic = 'Region';
  String hierDynamic = 'Region';
  Map<String, dynamic> staticMap = {
    "Name": "Q1",
    "UniqueName": "[$dimStatic].[Q1]",
    "Expression": "[$dimStatic].MEMBERS",
    "Alias": ""
  };
  Map<String, dynamic> element1map = {
    "Name": "Jan",
    "UniqueName": "[$dimStatic].[Jan]",
    "Type": "N",
    "Level": 0
  };
  Map<String, dynamic> element2map = {
    "Name": "Feb",
    "UniqueName": "[$dimStatic].[Feb]",
    "Type": "N",
    "Level": 0
  };
  Map<String, dynamic> element3map = {
    "Name": "Mar",
    "UniqueName": "[$dimStatic].[Mar]",
    "Type": "N",
    "Level": 0
  };

  Element element1 = Element.fromJson(dimStatic, hierStatic, element1map);
  Element element2 = Element.fromJson(dimStatic, hierStatic, element2map);
  Element element3 = Element.fromJson(dimStatic, hierStatic, element3map);
  List<Element> elementsOfStaticList = [element1, element2, element3];

  Map<String, dynamic> dynamicMap = {
    'Name': 'dynamic',
    'UniqueName': '[$dimDynamic].[dynamic]',
    'Expression': '{TM1SORT( {TM1SUBSETALL( [$dimDynamic] )}, ASC)}',
    'Alias': ''
  };

  Subset staticSubset = Subset.fromJson(dimStatic, hierStatic, staticMap);
  staticSubset.elements = elementsOfStaticList;
  Subset dynamicSubset = Subset.fromJson(dimDynamic, hierDynamic, dynamicMap);

  test('check if subset is dynamic and static', () async {
    expect(dynamicSubset.isDynamic, true);
    expect(staticSubset.isDynamic, false);
  });

  test('does the subset exist', () async {
    bool actualValue = await SubsetService().checkIfExists(staticSubset);
    expect(actualValue, true);
  });

  test('get subset from resource', () async {
    Subset actualSubset = await SubsetService()
        .getSubset(dimStatic, hierStatic, staticSubset.name);
    expect(actualSubset.name, staticSubset.name);
    //expect(actualSubset.elements.length, 0);
  });
  test('get elements of a given subset', () async {
    List<String> actualList = await SubsetService().getElements(staticSubset);
    actualList = actualList.map((a) => a.substring(0, 3)).toList();
    expect(actualList, [element1.name, element2.name, element3.name]);
  });

  //TODO get subsets should work from dimension service

}
