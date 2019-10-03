import 'package:tm1_dart/Objects/Element.dart';
import 'package:tm1_dart/Objects/Subset.dart';
import 'dart:convert';

class UnregSubset extends Subset{
  final String name = '';
  final String aliasApplied = '';
  final String dimensionName;
  final String hierarchyName;
  List<Element> elements=[];
  bool isDynamic = false;
  String MDX = '';
  UnregSubset(this.dimensionName,this.hierarchyName,{this.elements,this.MDX,this.isDynamic}):
    super(dimensionName,hierarchyName);

  factory UnregSubset.fromJson(String dimensionName, String hierarchyName,Map<String,dynamic> parsedJson){
    return new UnregSubset(dimensionName, hierarchyName,MDX: parsedJson['Expression'],
        isDynamic: parsedJson['Expression'] != '[$dimensionName].MEMBERS'
            ? parsedJson['Expression'] != '' ? true : false
            : false);
  }

  @override
  String createTM1Path() {
    return 'api/v1/Dimensions(\'$dimensionName\')/Hierarchies(\'$hierarchyName\')/Elements';
  }


  @override
  String body() {
    Map<String,dynamic> bodyMap={};
    bodyMap.addAll({'Hierarchy@odata.bind':'Dimensions(\'$dimensionName\')/Hierarchies(\'$hierarchyName\')'});
    bodyMap.addAll(createExpressionOrListOfElement());
    return json.encode(bodyMap);
  }




}