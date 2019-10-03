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
  var monthJson = {'Expression': ''};
  UnregSubset subsetMonth1 = UnregSubset.fromJson('month', 'month',
      monthJson);
  subsetMonth1.elements = [element1, element2, element3];
  var accountJson = {'Expression': '[account2].[bdg]'};
  UnregSubset subsetAccount2 =
  UnregSubset.fromJson('account2', 'account2', accountJson);
  Subset subsetTitle1 = Subset.fromJson('actvsbud', 'actvsbud',
      {'Expression': '[actvsbud].Actual', 'Name': 'All Members', 'Alias': ''});
  Subset subsetTitle2 = Subset.fromJson('region', 'region',
      {'Expression': '[region].World', 'Name': 'Europe', 'Alias': ''});
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
    expect(nativeViewTest.body().trim(), expectedMDX);
  });
}
