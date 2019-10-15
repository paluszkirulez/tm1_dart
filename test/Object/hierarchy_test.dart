import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:random_string/random_string.dart' as random;
import 'package:tm1_dart/Objects/Hierarchy.dart';
import 'package:tm1_dart/Services/HierarchyService.dart';
import 'package:tm1_dart/Services/RESTConnection.dart';

import '../UtilsForTest/ConnectionUtils.dart';

class MockHierarchy extends Mock implements Hierarchy {}

//var hierarchy = MockHierarchy();

class MockHierarchyService extends Mock implements HierarchyService {}

var hirarchyService = MockHierarchy();

void main() async {
  String ip = await getIp();
  RESTConnection restConnection = RESTConnection.initialize(
      "https", ip, 8010, "admin", "apple", true, "", false, false);
  Map<String, dynamic> testMap = {'Name': 'actvsbud'};
  Hierarchy hierarchy = Hierarchy.fromJson('actvsbud', testMap);

  test('check if correct elements of hierarchy are returned', () async {
    Map<String,dynamic> expectedElements = {
    'Actual':'Numeric',
    'Budget':'Numeric',
    'Variance': 'Consolidated'
    };
    var printout = await HierarchyService().getElementsAsaMap(hierarchy);
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
    var printout = await HierarchyService().getAttributes(hierarchy);
    expect(printout, expectedElements);
  });
  String name = random.randomString(5);
  Map<String, dynamic> testMap2 = {'Name': name};
  Hierarchy hierarchy2 = Hierarchy.fromJson('actvsbud', testMap2);
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
    expect(hierarchy.name,hierarchyNew.name);
  });
  test('check if get defautl member works', () async {
    String actualResult = await HierarchyService().getDefaultMember(hierarchy);
    expect(actualResult,'Actual');
  });
  test('get all subsets for a given hierarchy', () async {
    List<String> actualResult = await HierarchyService().getSubsets(hierarchy);
    expect(actualResult, ['All Members', 'test_alias', 'test_subset_public']);
  });
  test('get number of elements', () async {
    var actualResult = await HierarchyService().getNumberOfElements(hierarchy);
    expect(actualResult, 3);
  });
  test('get number of subsets', () async {
    var actualResult = await HierarchyService().getNumberOfSubsets(hierarchy);
    expect(actualResult, 3);
  });


  test('check if hierarchy contains given element', () async {
    String trueElement = 'Actual';
    String falseElement = 'asadadda';
    bool trueBool = await HierarchyService().checkIfContainsElement(
        hierarchy, trueElement);
    bool falseBool = await HierarchyService().checkIfContainsElement(
        hierarchy, falseElement);
    expect(trueBool, true);
    expect(falseBool, false);
  });
  //TODO add getter for hierarchy details
  //TODO add post/update/remove methods

}
//hierarchy tests
