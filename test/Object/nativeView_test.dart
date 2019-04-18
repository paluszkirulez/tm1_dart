import 'package:flutter_test/flutter_test.dart';
import 'package:tm1_dart/Objects/Axis/ViewAxisSelection.dart';
import 'package:tm1_dart/Objects/Axis/ViewTitleSelection.dart';
import 'package:tm1_dart/Objects/Element.dart';
import 'package:tm1_dart/Objects/Subset.dart';
import 'package:tm1_dart/Objects/UnregSubset.dart';
import 'package:tm1_dart/Objects/View/NativeView.dart';
import 'package:tm1_dart/Services/RESTConnection.dart';

import '../UtilsForTest/ConnectionUtils.dart';

//TODO prepare subsets and axis/titles
//

void main() async {
  String ip = await getIp();
  RESTConnection restConnection = RESTConnection.initialize(
      "https", ip, 8010, "admin", "apple", true, "", false, false);
  String cubeName = 'PNLCube';
  Map<String, dynamic> testMapElement1 = {
    'Name': 'Jan',
    'UniqueName': 'Jan',
    'Type': 'Numeric',
    'Index': 0,
    'Level': 0
  };
  Map<String, dynamic> testMapElement2 = {
    'Name': 'Feb',
    'UniqueName': 'Feb',
    'Type': 'Numeric',
    'Index': 0,
    'Level': 0
  };
  Map<String, dynamic> testMapElement3 = {
    'Name': 'Mar',
    'UniqueName': 'Mar',
    'Type': 'Numeric',
    'Index': 0,
    'Level': 0
  };
  Element element1 = Element.fromJson('month', 'month', testMapElement1);
  Element element2 = Element.fromJson('month', 'month', testMapElement2);
  Element element3 = Element.fromJson('month', 'month', testMapElement3);

  UnregSubset subsetMonth1 = UnregSubset('month', 'month',
      elements: [element1, element2, element3], MDX: '');
  UnregSubset subsetAccount2 =
      UnregSubset('account2', 'account2', MDX: '{[account2].AllMembers}');
  Subset subsetTitle1 = Subset('actvsbud', 'actvsbud');
  Subset subsetTitle2 = Subset('region', 'region');
  ViewTitleSelection viewTitleSelection1 =
      ViewTitleSelection(subsetTitle1, 'actvsbud', 'actvsbud', 'Actual');
  ViewTitleSelection viewTitleSelection2 =
      ViewTitleSelection(subsetTitle2, 'region', 'region', 'World');
  //TODO - dim and hirarchy should be retrieved from subset
  ViewAxisSelection viewAxisSelection2 =
      ViewAxisSelection(subsetMonth1, 'month', 'month');
  ViewAxisSelection viewAxisSelection1 =
      ViewAxisSelection(subsetAccount2, 'account2', 'account2');

  test('check if mdx is created correctly', () {
    NativeView nativeViewTest = NativeView('temp view', 'PNLCube', true, true, "0.#########", [viewAxisSelection1], [viewTitleSelection1,viewTitleSelection2], [viewAxisSelection2]);
    var expectedMDX = "SELECT NON EMPTY {[month].[Jan], [month].[Feb], [month].[Mar]} ON COLUMNS, NON EMPTY {[account2].AllMembers} ON ROWS FROM [PNLCube] WHERE ([actvsbud].[Actual], [region].[World])";
    expect(nativeViewTest.prepareMDXQueryView(), expectedMDX);
  });
}
