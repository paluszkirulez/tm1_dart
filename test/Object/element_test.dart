
import 'package:flutter_test/flutter_test.dart';
import 'package:tm1_dart/Objects/Element.dart';
import 'package:tm1_dart/Services/ElementService.dart';
import 'package:tm1_dart/Services/RESTConnection.dart';


void main(){
  String ip = "10.113.152.189";
  RESTConnection restConnection = RESTConnection.initialize("https", ip, 8010,  "admin", "apple", true, "", false, false);
  test('Check if element is created from map',(){
    Map<String,dynamic> testMap = {'Name':'aa','UniqueName':'uName','Type':'Numeric','Index':0,'Level':0};
    Element element = Element.fromJson('account','account',testMap);
    expect(element.name, 'aa');
  });

  test('Check if element retrieves all members underneath',(){
    Map<String,dynamic> testMap = {'Name':'Gross Margin','UniqueName':'uName','Type':'Numeric','Index':0,'Level':0};
    Element element = Element.fromJson('account1', 'account1',testMap);
    var printout = ElementService().getMembersUnderConsolidation(element, maxDepth: 3);
    print(printout.then((s)=>print(s)));
    expect(element.name, 'Gross Margin');
  });
}