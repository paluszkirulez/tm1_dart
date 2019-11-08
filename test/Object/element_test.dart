import 'package:flutter_test/flutter_test.dart';
import 'package:random_string/random_string.dart' as random;
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

  test('Check if element is get from server', () async {

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
    Element element = await ElementService().getElement(
        'account1', 'account1', 'Gross Margin');
    var printout = await ElementService()
        .getMembersUnderConsolidation(element, maxDepth: 3);
    List<String> actualResult = printout.keys.toList();
    expect(actualResult, ['Sales', 'Variable Costs', 'aa', 'aaa', 'Price']);
  });
  test('Check if element retrieves only leaves members underneath', () async {
    Map<String, dynamic> testMap = {
      'Name': 'Gross Margin',
      'UniqueName': 'uName',
      'Type': 'Numeric',
      'Index': 0,
      'Level': 0
    };
    Element element = await ElementService().getElement(
        'account1', 'account1', 'Gross Margin');
    var printout = await ElementService()
        .getMembersUnderConsolidation(element, maxDepth: 3, leavesOnly: true);
    List<String> actualResult = printout.keys.toList();
    expect(actualResult, ['Sales', 'Variable Costs', 'aaa', 'Price']);
  });
  String newName = random.randomString(5, from: 97, to: 122);
  test('create new element', () async {
    bool created = await ElementService().createElement(
        'account1', 'account1', newName);
    expect(created, true);
  });
  test('update Element', () async {
    Element element = await ElementService().getElement(
        'account1', 'account1', newName);
    element.elementType = 'String';
    bool updated = await ElementService().update(element);
    expect(updated, true);
  });

  test('deleted new element', () async {
    bool deleted = await ElementService().deleteElement(
        'account1', 'account1', newName);
    expect(deleted, true);
  });

}
