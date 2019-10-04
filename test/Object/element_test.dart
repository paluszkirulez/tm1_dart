import 'package:flutter_test/flutter_test.dart';
import 'package:tm1_dart/Objects/Element.dart';
import 'package:tm1_dart/Services/ElementService.dart';
import 'package:tm1_dart/Services/RESTConnection.dart';

import '../UtilsForTest/ConnectionUtils.dart';

void main() async {
  String ip = await getIp();
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
  test('Check if element is created from map', () {
    Map<String, dynamic> testMap = {
      'Name': 'aa',
      'UniqueName': 'uName',
      'Type': 'Numeric',
      'Index': 0,
      'Level': 0
    };
    Element element = Element.fromJson('account', 'account', testMap);
    expect(element.name, 'aa');
  });
  test('Check if element is get from server', () async {
    Map<String, dynamic> testMap = {
      'Name': 'aa',
      'UniqueName': 'uName',
      'Type': 'Numeric',
      'Index': 0,
      'Level': 0
    };
    Element element =
    await ElementService().getElement('account1', 'account1', 'Price');
    expect(element.name, 'Price');
    expect(element.elementType, 'Numeric');
  });
  test('Check if element is get from server with attributes', () async {
    Map<String, dynamic> testMap = {
      'Name': 'aa',
      'UniqueName': 'uName',
      'Type': 'Numeric',
      'Index': 0,
      'Level': 0
    };
    Element element = await ElementService()
        .getElement('account1', 'account1', 'Price', withAttributes: true);
    expect(element.name, 'Price');
    expect(element.elementType, 'Numeric');
    expect(element.attributes.containsValue('Price'), true);
    expect(element.attributes.containsKey('Caption'), true);
  });

  test('Check if element retrieves all members underneath', () async {
    Map<String, dynamic> testMap = {
      'Name': 'Gross Margin',
      'UniqueName': 'uName',
      'Type': 'Numeric',
      'Index': 0,
      'Level': 0
    };
    Element element = Element.fromJson('account1', 'account1', testMap);
    var printout = await ElementService()
        .getMembersUnderConsolidation(element, maxDepth: 3);
    List<String> actualResult = printout.keys.toList();
    expect(actualResult, ['Sales', 'Variable Costs', 'aa', 'aaa']);
  });
  test('Check if element retrieves only leaves members underneath', () async {
    Map<String, dynamic> testMap = {
      'Name': 'Gross Margin',
      'UniqueName': 'uName',
      'Type': 'Numeric',
      'Index': 0,
      'Level': 0
    };
    Element element = Element.fromJson('account1', 'account1', testMap);
    var printout = await ElementService()
        .getMembersUnderConsolidation(element, maxDepth: 3, leavesOnly: true);
    List<String> actualResult = printout.keys.toList();
    expect(actualResult, ['Sales', 'Variable Costs', 'aaa']);
  });
//TODO add post/update/delete methods
}
