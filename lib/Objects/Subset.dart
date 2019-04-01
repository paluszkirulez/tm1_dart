import 'TM1Object.dart';
import 'Element.dart';
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
    // TODO: implement body
    return null;
  }


}