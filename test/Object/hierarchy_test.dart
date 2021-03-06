import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:random_string/random_string.dart' as random;
import 'package:tm1_dart/Objects/Element.dart';
import 'package:tm1_dart/Objects/Hierarchy.dart';
import 'package:tm1_dart/Objects/Subset.dart';
import 'package:tm1_dart/Services/HierarchyService.dart';
import 'package:tm1_dart/Services/RESTConnection.dart';

import '../UtilsForTest/ConnectionUtils.dart';

class MockHierarchy extends Mock implements Hierarchy {}

//var hierarchy = MockHierarchy();

/*class MockHierarchyService extends Mock implements HierarchyService {}

var hirarchyService = MockHierarchy();*/

void main() async {
  String ip = await getIp();
  RESTConnection restConnection = RESTConnection.initialize(
      "https", ip, 8010, "admin", "apple", true, "", false, false);
  Map<String, dynamic> testMap = {'Name': 'actvsbud'};
  String hierarchyName = 'actvsbud';
  String dimensionName = 'actvsbud';

  test('check if correct elements of hierarchy are returned', () async {
    List<String> expectedElements = [
      'Actual',
      'Actual2',
      'Budget',
      'Variance'
    ];

    Map<String, Element> mapOfElements = await HierarchyService().getElements(
        dimensionName, hierarchyName);
    List<String> printout = mapOfElements.keys.toList();
    expect(printout, expectedElements);
  });
  test('check if hierarchy function returns a list of attributes', () async {
    Map<String, dynamic> expectedElements = {
      'Format': 'String',
      'permittedcalculations_n_and_c': 'String',
      'Caption': 'Alias',
      '实际值VS预算': 'Alias',
      'Presactivo': 'Alias',
      'bilattivo': 'Alias',
      '実数と予算': 'Alias',
      'datenart': 'Alias'
    };
    var printout = await HierarchyService().getAttributes(
        dimensionName, hierarchyName);
    expect(printout, expectedElements);
  });
  String name = random.randomString(5, from: 97, to: 122);
  String dimensionName2 = 'actvsbud';
  String hierarchyName2 = 'actvsbud';
  Hierarchy hierarchy2 = Hierarchy.fromJson(
      {'Dimension': {'Name': dimensionName2}, 'Name': name});

  test('check if hierarchy creation works', () async {
    var printout = await HierarchyService().create(hierarchy2);
    expect(printout, true);
  });
  test('check if hierarchy deletion works', () async {
    var printout = await HierarchyService().delete(hierarchy2);
    expect(printout, true);
  });

  test('check if getHierarchy works', () async {
    Hierarchy hierarchyNew = await HierarchyService().getHierarchy('actvsbud', 'actvsbud');
    expect('actvsbud', hierarchyNew.name);
  });
  test('check if get default member works', () async {
    String actualResult = await HierarchyService().getDefaultMember(
        dimensionName, hierarchyName);
    expect(actualResult,'Actual');
  });
  test('get all subsets for a given hierarchy', () async {
    List<Subset> actualResult = await HierarchyService().getSubsets(
        'account1', 'account1');

    List<String> actualName = actualResult.map((a) => a.name).toList();
    expect(actualName,
        ['All Members', 'Default']);
  });
  test('get number of elements', () async {
    var actualResult = await HierarchyService().getNumberOfElements(
        dimensionName, hierarchyName);
    expect(actualResult, 4);
  });
  test('get number of subsets', () async {
    var actualResult = await HierarchyService().getNumberOfSubsets(
        'account1', 'account1');
    expect(actualResult, 2);
  });


  test('check if hierarchy contains given element', () async {
    String trueElement = 'Actual';
    String falseElement = 'asadadda';
    bool trueBool = await HierarchyService().checkIfContainsElement(
        dimensionName, hierarchyName, trueElement);
    bool falseBool = await HierarchyService().checkIfContainsElement(
        dimensionName, hierarchyName, falseElement);
    expect(trueBool, true);
    expect(falseBool, false);
  });

  test('check if deleting all edges works', () async {
    bool result = await HierarchyService().deleteAllEdges(
        dimensionName, hierarchyName);
    expect(result, false);
  });
  test('check if adding edges works', () async {
    bool result2 = await HierarchyService().createEdges(
        dimensionName, hierarchyName, 'Variance', 'Actual2', 1);
    expect(result2, true);
  });
  test('check if correct edges are returned', () async {
    List<Map<String, dynamic>> listOfMaps = await HierarchyService().getEdges(
        dimensionName, hierarchyName);
    expect(listOfMaps.length, 1);
  });
  test('check if visiility change works', () async {
    bool changed = await HierarchyService().updateVisibility(
        dimensionName, hierarchyName, false);
    expect(changed, true);
  });
}
//hierarchy tests
