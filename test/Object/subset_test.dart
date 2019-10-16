import 'package:flutter_test/flutter_test.dart';
import 'package:tm1_dart/Objects/Element.dart';
import 'package:tm1_dart/Objects/Subset.dart';
import 'package:tm1_dart/Services/RESTConnection.dart';
import 'package:tm1_dart/Services/SubsetService.dart';

import '../UtilsForTest/ConnectionUtils.dart';

void main() async {
  //String ipAddress = await GetIp.ipAddress;
  String ipAddress = await getIp();
  RESTConnection restConnection = RESTConnection.initialize(
      "https", ipAddress, 8010, "admin", "apple", true, "", false, false);


  String dimensionName = 'actvsbud';
  String hierarchyName = 'actvsbud';
  String dynamicSubsetName = 'All Members';
  String staticSubsetName = 'test_alias';
  Subset staticSubset = await SubsetService().getSubset(
      dimensionName, hierarchyName, staticSubsetName);
  Subset dynamicSubset = await SubsetService().getSubset(
      dimensionName, hierarchyName, dynamicSubsetName);

  test('check if subset is dynamic and static', () async {
    expect(dynamicSubset.isDynamic, true);
    expect(staticSubset.isDynamic, false);
  });

  test('does the subset exist', () async {
    bool actualValue = await SubsetService().checkIfExists(staticSubset);
    expect(actualValue, true);
  });

  test('get elements of a given subset', () async {
    Map<String, Element> actualList = await SubsetService().getElements(
        dimensionName, hierarchyName, staticSubsetName);
    var actual = actualList.keys.toList();
    expect(actual, ['Actual', 'Budget', 'Variance']);
  });

  test('get subset from resource', () async {
    Subset actualSubset = await SubsetService()
        .getSubset(dimensionName, hierarchyName, staticSubsetName);
    expect(actualSubset.name, staticSubsetName);
    Map<String, Element> actualList = await SubsetService().getElements(
        dimensionName, hierarchyName, staticSubsetName);
    var actual = actualList.keys.toList();
    expect(actualSubset.elements.keys.toList(), actual);
    //expect(actualSubset.elements.length, 0);
  });


  //TODO get subsets should work from dimension service

}
