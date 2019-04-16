import 'package:tm1_dart/Objects/Element.dart';
import 'package:tm1_dart/Objects/Subset.dart';
import 'package:tm1_dart/Services/RESTConnection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tm1_dart/Services/SubsetService.dart';


void main() async {
  //String ipAddress = await GetIp.ipAddress;
  String ipAddress = '10.113.171.159';
  RESTConnection restConnection = RESTConnection.initialize(
      "https", ipAddress, 8010, "admin", "apple", true, "", false, false);
  String dimName = 'actvsbud';
  String hierName = 'actvsbud';
  Map<String, dynamic> testMap = {
    "Name": "All Members",
    "UniqueName": "[$dimName].[All Members]",
    "Expression": "[$dimName].MEMBERS",
    "Alias": ""
  };


  String subsName = 'All Members';
  Subset testingSubset = Subset.fromJson(dimName, hierName, testMap);
  test('check if subset is correctly created', () async {
    var printout = await SubsetService().getSubset(dimName, hierName, subsName);
    expect(printout.name, testingSubset.name);
    expect(printout.isDynamic, false);
    expect(printout.MDX, testingSubset.MDX);
  });
  test('check if subset returns correct elements', () async {
    var printout = await SubsetService().getObjects(testingSubset);
    List<String> expectedList = [
      'Variance, Type: Consolidated',
      'Actual, Type: Numeric',
      'Budget, Type: Numeric'
    ];
    expect(printout, expectedList);
  });
  test('check if subset returns correct elements as a map', () async {
    var printout = await SubsetService().getObjectsAsaMap(testingSubset);
    Map<String,dynamic> expectedList = {
    'Variance': 'Consolidated',
    'Actual':'Numeric',
    'Budget':'Numeric'
    };
    expect(printout, expectedList);
  });
  test('check if subset exists', () async {
    var printout = await SubsetService().checkIfExists(testingSubset);
    bool expectedResponse = true;
    expect(printout, expectedResponse);
  });
  test('check if correct body for subset is created', () async {
    Map<String,dynamic> testMap = {'Name':'aa','UniqueName':'uName','Type':'Numeric','Index':0,'Level':0};
    Map<String,dynamic> testMap2 = {'Name':'aa2','UniqueName':'uName','Type':'Numeric','Index':0,'Level':0};
    Element element = Element.fromJson('actvsbud','actvsbud',testMap);
    Element element2 = Element.fromJson('actvsbud','actvsbud',testMap2);
    testingSubset.elements=[element, element2];
    var printout = testingSubset.body();
    print(printout);
    var expectedResponse = '{"Name": "All Members", "Hierarchy@odata.bind": "Dimensions(\'actvsbud\')/Hierarchies(\'actvsbud\')", "Elements@odata.bind": ["Dimensions(\'actvsbud\')/Hierarchies(\'actvsbud\')/Elements(\'aa\')","Dimensions(\'actvsbud\')/Hierarchies(\'actvsbud\')/Elements(\'aa2\')"]}';
    expect(printout, expectedResponse);
  });
}
