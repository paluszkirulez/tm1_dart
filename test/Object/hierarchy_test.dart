import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tm1_dart/Objects/Hierarchy.dart';
import 'package:tm1_dart/Services/HierarchyService.dart';
import 'package:tm1_dart/Services/RESTConnection.dart';
import 'package:random_string/random_string.dart' as random;

class MockHierarchy extends Mock implements Hierarchy {}

//var hierarchy = MockHierarchy();

class MockHierarchyService extends Mock implements HierarchyService {}

var hirarchyService = MockHierarchy();

void main() {
  String ip = "10.113.152.189";
  RESTConnection restConnection = RESTConnection.initialize(
      "https", ip, 8010, "admin", "apple", true, "", false, false);
  Map<String, dynamic> testMap = {'Name': 'actvsbud'};
  Hierarchy hierarchy = Hierarchy.fromJson('actvsbud', testMap);

  test('check if correct elements of hierarchy are returned', () async {
    Map<String,dynamic> expectedElements = {
    'Actual':'Numeric',
    'Budget':'Numeric',
    'Variance':'Consolidated'
    };
    var printout = await HierarchyService().getObjectsAsaMap(hierarchy);
    expect(printout, expectedElements);
  });
  test('check if hierarchy funtion returns a list of attributes', () async {
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
  test('check if hierarchy creation works', () async {
    String name = random.randomString(5);
    print(name);
    Map<String, dynamic> testMap = {'Name': name};
    Hierarchy hierarchy = Hierarchy.fromJson('actvsbud', testMap);
    var printout = await HierarchyService().create(hierarchy);
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
}
//hierarchy tests
