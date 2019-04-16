import 'TM1Object.dart';
import 'Element.dart';
import 'dart:convert';
class Subset extends TM1Object{
  final String classType = 'Subset';
  final String name;
  final String dimensionName;
  final String hierarchyName;
  String aliasApplied;
  List<Element> elements=[];
  bool isDynamic = false;
  String MDX = '';

  Subset(this.dimensionName,this.hierarchyName,{this.name,this.aliasApplied,this.elements,this.isDynamic,this.MDX});

  factory Subset.fromJson(
      String dimensionName, String hierarchyName, Map<String, dynamic> parsedJson) {
    return new Subset(dimensionName, hierarchyName,
        name: parsedJson['Name'],
        MDX: parsedJson['Expression'],
        aliasApplied:parsedJson['Alias'],
        isDynamic: parsedJson['Expression']!='[${dimensionName}].MEMBERS' ? true :false );
  }



  @override
  String createTM1Path() {
    return 'api/v1/Dimensions(\'$dimensionName\')/Hierarchies(\'$hierarchyName\')/Subsets';
  }

  @override
  String body() {
    Map<String,dynamic> bodyMap={};
    bodyMap.addAll({'Name':name});
    aliasApplied!=''? bodyMap.addAll({'Alias':aliasApplied}):{};
    bodyMap.addAll({'Hierarchy@odata.bind':'Dimensions(\'$dimensionName\')/Hierarchies(\'$hierarchyName\')'});
    bodyMap.addAll(createExpressionOrListOfElement());
    return json.encode(bodyMap);
  }

  Map<String,dynamic> createExpressionOrListOfElement(){
    Map<String,dynamic> bodyMap={};
    if(isDynamic){
      bodyMap.addAll({'Expression':MDX});

    }
    else{
      var statement='Dimensions(\'$dimensionName\')/Hierarchies(\'$hierarchyName\')/Elements';
      var listOfElements='[';
      for(Element element in elements){
        listOfElements = listOfElements+statement+'(\'${element.name}\')';
        listOfElements = listOfElements+',';
      }
      listOfElements = listOfElements.substring(0,listOfElements.length-1)+']';
      bodyMap.addAll({'Elements@odata.bind':listOfElements});
    }

    return bodyMap;
  }


}