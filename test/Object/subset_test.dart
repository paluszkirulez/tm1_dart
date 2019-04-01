import 'package:tm1_dart/Objects/Subset.dart';
import 'package:tm1_dart/Services/RESTConnection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tm1_dart/Services/SubsetService.dart';
void main() {
  String ip = "10.113.152.189";
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
  String dimName='actvsbud';
  String hierName='actvsbud';
  Map<String, dynamic> testMap = {"Name": "All Members","UniqueName": "[$dimName].[All Members]",
    "Expression": "[$dimName].MEMBERS","Alias": ""};

  String subsName='All Members';
  Subset testingSubset= Subset.fromJson(dimName, hierName, testMap);
  test('check if subset is correctly created', () async {
    var printout = await SubsetService().getSubset(dimName,hierName,subsName);
    expect(printout.name, testingSubset.name);
    expect(printout.isDynamic, false);
    expect(printout.MDX, testingSubset.MDX);
  });
}