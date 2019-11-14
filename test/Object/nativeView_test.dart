import 'package:flutter_test/flutter_test.dart';
import 'package:tm1_dart/Objects/Axis/ViewAxisSelection.dart';
import 'package:tm1_dart/Objects/Axis/ViewTitleSelection.dart';
import 'package:tm1_dart/Objects/Element.dart';
import 'package:tm1_dart/Objects/Subset.dart';
import 'package:tm1_dart/Objects/UnregSubset.dart';
import 'package:tm1_dart/Objects/View/NativeView.dart';
import 'package:tm1_dart/Services/ElementService.dart';
import 'package:tm1_dart/Services/RESTConnection.dart';
import 'package:tm1_dart/Services/ViewService.dart';

import '../UtilsForTest/ConnectionUtils.dart';

//TODO prepare subsets and axis/titles
//

void main() async {
  String ip = await getIp();
  RESTConnection restConnection = RESTConnection.initialize(
      "https", ip, 8010, "admin", "apple", true, "", false, false);
  String cubeName = 'PNLCube';
  String dimName = 'month';
  String hierName = 'month';
  String el1 = 'Jan';
  String el2 = 'Feb';
  String el3 = 'Mar';

  Element element1 = await ElementService().getElement(dimName, hierName, el1);
  Element element2 = await ElementService().getElement(dimName, hierName, el2);
  Element element3 = await ElementService().getElement(dimName, hierName, el3);
  var monthJson = {'Expression': ''};
  Map<String, dynamic> unregMap = {
    'Name': 'testName',
    'Hierarchy': {'Name': dimName, 'Dimension': {'Name': dimName}},
    'Elements': [element1.toJson(), element2.toJson(), element3.toJson()]

  };
  unregMap.addAll(monthJson);
  UnregSubset subsetMonth1 = UnregSubset.fromJson(unregMap);

  var accountJson = {
    'Name': 'testName',
    'Hierarchy': {'Name': 'account2', 'Dimension': {'Name': 'account2'}},
    'Expression': '[account2].[bdg]'
  };
  UnregSubset subsetAccount2 =
  UnregSubset.fromJson(accountJson);
  Subset subsetTitle1 = Subset.fromJson(
      {
        'Name': 'testName',
        'Hierarchy': {'Name': 'actvsbud', 'Dimension': {'Name': 'actvsbud'}},
        'Expression': '[actvsbud].Actual',
        'Name': 'All Members',
        'Alias': ''
      });
  Subset subsetTitle2 = Subset.fromJson(
      {
        'Name': 'testName',
        'Hierarchy': {'Name': 'region', 'Dimension': {'Name': 'region'}},
        'Expression': '[region].World',
        'Name': 'Europe',
        'Alias': ''
      });
  ViewTitleSelection viewTitleSelection1 =
  ViewTitleSelection(subsetTitle1, 'Actual');
  ViewTitleSelection viewTitleSelection2 =
  ViewTitleSelection(subsetTitle2, 'World');
  //TODO - dim and hirarchy should be retrieved from subset
  ViewAxisSelection viewAxisSelection2 =
  ViewAxisSelection(subsetMonth1);
  ViewAxisSelection viewAxisSelection1 =
  ViewAxisSelection(subsetAccount2);

  test('check if mdx is created correctly', () {
    NativeView nativeViewTest = NativeView('temp view', 'PNLCube', true, true, "0.#########", [viewAxisSelection1], [viewTitleSelection1,viewTitleSelection2], [viewAxisSelection2]);
    var expectedMDX = "SELECT NON EMPTY {[month].[Jan], [month].[Feb], [month].[Mar]} ON COLUMNS, NON EMPTY {[account2].[bdg]} ON ROWS FROM [PNLCube] WHERE ([actvsbud].[Actual], [region].[World])";
    expect(nativeViewTest.prepareMDXQueryView(), expectedMDX);
  });
  test('check if native view default body json construct is correct', () {
    NativeView nativeViewTest = NativeView(
        'temp view',
        'PNLCube',
        true,
        true,
        "0.#########",
        [viewAxisSelection1],
        [viewTitleSelection1, viewTitleSelection2],
        [viewAxisSelection2]);
    var expectedMDX = "{\"@odata.type\": \"ibm.tm1.api.v1.NativeView\",\"Name\": \"temp view\",\"Columns\": [{\"Subset\":{\"Hierarchy@odata.bind\":\"Dimensions(\'month\')/Hierarchies(\'month\')\",\"Elements@odata.bind\":[\"Dimensions(\'month\')/Hierarchies(\'month\')/Elements(\'Jan\')\",\"Dimensions(\'month\')/Hierarchies(\'month\')/Elements(\'Feb\')\",\"Dimensions(\'month\')/Hierarchies(\'month\')/Elements(\'Mar\')\"]}}], \"Rows\": [{\"Subset\":{\"Hierarchy@odata.bind\":\"Dimensions(\'account2\')/Hierarchies(\'account2\')\",\"Expression\":\"[account2].[bdg]\"}}], \"Titles\": [{\"Subset@odata.bind\":\"Dimensions(\'actvsbud\')/Hierarchies(\'actvsbud\')/Subsets(\'All Members\')\",\"Selected@odata.bind\":\"Dimensions(\'actvsbud\')/Hierarchies(\'actvsbud\')/Elements(\'Actual\')\"},{\"Subset@odata.bind\":\"Dimensions(\'region\')/Hierarchies(\'region\')/Subsets(\'Europe\')\",\"Selected@odata.bind\":\"Dimensions(\'region\')/Hierarchies(\'region\')/Elements(\'World\')\"}], \"SuppressEmptyColumns\": true,\"SuppressEmptyRows\":true,\"FormatString\":\"0.#########\"}"
        .trim();
    expect(nativeViewTest.body(), expectedMDX);
  });

  test('check if get nativeView works', () async {
    NativeView nativeViewTest = await ViewService().getNativeView(
        'PNLCube', 'Another view');

    expect(nativeViewTest.titles[0].selected, 'Variance');
  });
}
