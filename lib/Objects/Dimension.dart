import 'TM1Object.dart';
import 'Hierarchy.dart';
class Dimension extends TM1Object{
  ///this class is created as a dimension blueprint
  /// beside name it contains list of hierarchies (not elements)
  final String classType = 'Dimension';
  final String name;
  List<String> hierarchies = [];

  Dimension({this.name});

  factory Dimension.fromJson(Map<String, dynamic> parsedJson){
    return new Dimension(name: parsedJson['Name']);
  }

  @override
  String createTM1Path() {
    return 'api/v1/Dimensions';

  }

  @override
  String body() {
    Map<String, dynamic> bodyMap = {
      '"Name"': '"$name"',
    };
    return bodyMap.toString();
  }


}