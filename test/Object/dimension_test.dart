import 'package:tm1_dart/Objects/Dimension.dart';
import 'package:tm1_dart/Services/DimensionService.dart';
import 'package:tm1_dart/Services/HierarchyService.dart';
import 'package:tm1_dart/Services/RESTConnection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:random_string/random_string.dart';
import '../UtilsForTest/ConnectionUtils.dart';

void main() async {
  String ip = await  getIp();
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
    List<String> expectedElements = [
      'actvsbud',
      'actvsbud2',
      'Leaves',
      'O#3)3',
      '=Z%G1',
      '_a.Kj'
    ];
    expectedElements.sort((a, b) => a.hashCode.compareTo(b.hashCode));
    var printout = await DimensionService().getHierarchies(dimension);
    printout.sort((a, b) => a.hashCode.compareTo(b.hashCode));
    expect(printout, expectedElements);
  });
  test('check if dimension is created', () async {
    String randomDim = randomAlpha(5);
    print(randomDim);
    Dimension randomDimension = Dimension.fromJson({'Name': randomDim});
    bool result = await DimensionService().create(randomDimension);
    bool result2 = await DimensionService().checkIfExists(randomDimension);
    expect(result, true);
    expect(result2, true);
  });



}