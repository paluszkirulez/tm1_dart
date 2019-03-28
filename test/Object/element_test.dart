
import 'package:flutter_test/flutter_test.dart';
import 'package:tm1_dart/Objects/Element.dart';


void main(){
  test('Check if element is created from map',(){
    Map<String,dynamic> testMap = {'Name':'aa','UniqueName':'uName','Type':'Numeric','Index':0,'Level':0};
    Element element = Element.fromJson('account','account',testMap);
    expect(element.name, 'aa');
  });
}