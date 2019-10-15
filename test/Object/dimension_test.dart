import 'package:flutter_test/flutter_test.dart';
import 'package:random_string/random_string.dart';
import 'package:tm1_dart/Objects/Dimension.dart';
import 'package:tm1_dart/Objects/Hierarchy.dart';
import 'package:tm1_dart/Services/DimensionService.dart';
import 'package:tm1_dart/Services/RESTConnection.dart';

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

      'Sh1^V',
      'V`Xmx',
      'StvqT',
      'NygYB',
      'actvsbud2',
      '=Z%G1',
      'O#3)3',
      '`u&7B',
      'Leaves',
      'Rqm!y',
      'actvsbud',
      '_a.Kj',
      'Ek+[g'


    ];
    expectedElements.sort((a, b) => a.hashCode.compareTo(b.hashCode));
    List<Hierarchy> hierarchyList = await DimensionService().getHierarchies(
        dimension);
    var printout = hierarchyList.map((a) => a.name).toList();
    printout.sort((a, b) => a.hashCode.compareTo(b.hashCode));
    expect(printout, expectedElements);
  });
  String randomDim = randomAlpha(5);
  test('check if dimension is created', () async {
    Dimension randomDimension = Dimension.fromJson({'Name': randomDim});
    bool result = await DimensionService().create(randomDimension);
    bool result2 = await DimensionService().checkIfExists(randomDimension);
    expect(result, true);
    expect(result2, true);
  });
  test('check if dimension is created', () async {
    Dimension randomDimension = Dimension.fromJson({'Name': randomDim});
    bool result = await DimensionService().delete(randomDimension);
    bool result2 = await DimensionService().checkIfExists(randomDimension);
    expect(result, true);
    expect(result2, false);
  });
  test('get default hierarchy for dimension', () async {
    String defaultHier = await DimensionService().getDefaultHierarchy(
        dimension);
    expect(defaultHier, dimension.name);
  });
}