import 'package:flutter_test/flutter_test.dart';
import 'package:random_string/random_string.dart' as random;
import 'package:tm1_dart/Objects/Element.dart';
import 'package:tm1_dart/Objects/Subset.dart';
import 'package:tm1_dart/Services/ElementService.dart';
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
  String staticSubsetName = 'Subset1';
  String dynamicSubsetName = 'test_alias';
  Subset staticSubset = await SubsetService().getSubset(
      dimensionName, hierarchyName, staticSubsetName);
  Subset dynamicSubset = await SubsetService().getSubset(
      dimensionName, hierarchyName, dynamicSubsetName);

  test('check if subset is dynamic and static', () async {
    expect(dynamicSubset.isDynamic, true);
    expect(staticSubset.isDynamic, false);
  });



  test('get elements of a given subset', () async {
    Map<String, Element> actualList = await SubsetService().getElements(
        dimensionName, hierarchyName, staticSubsetName);
    var actual = actualList.keys.toList();
    expect(actual, ['Actual2', 'Actual']);
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
  test('check if element exists', () async {
    bool result = await SubsetService().checkIfElementExists(
        dimensionName, hierarchyName, staticSubsetName, 'Actual2');
    bool result2 = await SubsetService().checkIfElementExists(
        dimensionName, hierarchyName, staticSubsetName, 'falseName');

    expect(result, true);
    expect(result2, false);
  });


  String name = random.randomString(5, from: 97, to: 122);
  Subset subset2 = staticSubset;
  subset2.name = name;
  //TODO get subsets should work from dimension service
  test('create static subset', () async {
    bool created = await SubsetService().create(subset2);
    expect(created, true);
  });
  String newName = random.randomString(5, from: 97, to: 122);
  Subset subset3 = dynamicSubset;
  subset3.name = newName;
  //TODO get subsets should work from dimension service
  test('create dynamic subset', () async {
    bool created = await SubsetService().create(subset3);
    expect(created, true);
  });


  test('does the subset exist', () async {
    bool actualValue = await SubsetService().checkIfExists(dynamicSubset);
    expect(actualValue, true);
  });

  test('delete static subset', () async {
    bool deleteResult = await SubsetService().delete(subset2);
    bool actualValue = await SubsetService().checkIfExists(subset2);
    expect(deleteResult, true);
    expect(actualValue, false);
  });
  staticSubsetName = 'newSubset';
  Subset newSubset = await SubsetService().getSubset(
      dimensionName, hierarchyName, staticSubsetName);
  Element newElement = await ElementService().getElement(
      dimensionName, hierarchyName, 'Actual');
  test('delete element from subset', () async {
    bool returned = await SubsetService().deleteElementFromSubset(
        dimensionName, hierarchyName, newSubset.name, 'Actual');
    expect(returned, true);
  });

  test('update subset', () async {
    newSubset.elements.clear();
    newSubset.elements.addAll({newElement.name: newElement});
    bool checkUpdate = await SubsetService().updateSubset(newSubset);
    expect(checkUpdate, true);
  });

  // private subsets tests
  test('get private dynamic subset from resource', () async {
    String staticDynamicSubsetName = 'test_subset';
    Subset actualSubset = await SubsetService()
        .getSubset(
        dimensionName, hierarchyName, staticDynamicSubsetName, private: true);
    expect(actualSubset.name, staticDynamicSubsetName);
  });

}
