import 'package:flutter_test/flutter_test.dart';
import 'package:tm1_dart/Objects/Cube.dart';
import 'package:tm1_dart/Services/CubeService.dart';
import 'package:tm1_dart/Services/RESTConnection.dart';

import '../UtilsForTest/ConnectionUtils.dart';

void main() async {
  String ip = await getIp();
  RESTConnection restConnection = RESTConnection.initialize(
      "https", ip, 8010, "admin", "apple", true, "", false, false);
  String cubeName = 'PNLCube';
  List<String> testDimensions = ["actvsbud","region","account2","month"];
  test('check if get cube works', () async {
    Cube cube = await CubeService().getCube(cubeName);

    expect(cube.name, cubeName);
    expect(cube.dimensions.map((a) => a.name).toList(), testDimensions);
    expect(cube.rules, "#Region System\nFEEDSTRINGS;\nSKIPCHECK;\n#EndRegion");
  });
  test('check if get cube works for controlling cubes', () async {
    String cubeName = '}ElementAttributes_account1';
    Cube cube = await CubeService().getCube(cubeName);
    expect(cube.name, cubeName);
    //expect(cube.dimensions, testDimensions);
    //expect(cube.rules.ruleBody, "#Region System\nFEEDSTRINGS;\nSKIPCHECK;\n#EndRegion");
  });


  test('check if cube exists', ()async{
    Cube cube = await CubeService().getCube(cubeName);

    expect(await CubeService().checkIfExists(cube), true);

  });
  test('get random intersection', () async {
    //in some random cases test might be wrong
    Cube cube = await CubeService().getCube(cubeName);
    List<String> intersection1 = await CubeService().getRandomIntersection(
        cube.name);
    List<String> intersection2 = await CubeService().getRandomIntersection(
        cube.name);
    expect(intersection1[1] == intersection2[1], false);
  });
}
