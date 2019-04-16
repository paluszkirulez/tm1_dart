import 'package:tm1_dart/Objects/Dimension.dart';
import 'package:tm1_dart/Services/DimensionService.dart';
import 'package:tm1_dart/Services/RESTConnection.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  String ip = "10.113.179.59";
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
  Map<String, dynamic> testMap = {'Name': 'actvsbud'};
  Dimension dimension = Dimension.fromJson(testMap);
  test('check if correct dimension is returned', () async {
    Map<String,dynamic> expectedElements = {'Name':'actvsbud'
    };
    Dimension expectedDimension = Dimension.fromJson(expectedElements);
    var printout = await DimensionService().getDimension('actvsbud');
    expect(printout.name, expectedDimension.name);
  });
  test('check if correct hierarchies are returned', () async {
    List<String> expectedElements = ['actvsbud','actvsbud2','Leaves','O#3)3', '=Z%G1'];
    var printout = await DimensionService().getObjects(dimension);
    expect(printout, expectedElements);
  });

}