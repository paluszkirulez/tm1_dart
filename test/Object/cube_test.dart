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
  test('check if cube is created', () async {
    Cube cube = await CubeService().getCube(cubeName);

    expect(cube.name, cubeName);
    expect(cube.dimensions, testDimensions);
    expect(cube.rules.ruleBody, "#Region System\nFEEDSTRINGS;\nSKIPCHECK;\n#EndRegion");
  });
  test('check if cube exists', ()async{
    Cube cube = await CubeService().getCube(cubeName);
    Cube cube2 = Cube('adddd');
    expect(await CubeService().checkIfExists(cube), true);
    expect(await CubeService().checkIfExists(cube2), false);
  });
}
