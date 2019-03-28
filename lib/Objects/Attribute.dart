
import 'TM1Object.dart';


class Attribute extends TM1Object {
  /// abstraction for attribute, keep refrence to a dimension where is used

  final String name;
  final String type;
  final String dimension;

  Attribute(this.dimension, {this.name, this.type});

  factory Attribute.fromJSon(String dimension, Map<String, dynamic> fromJson) {
    return new Attribute(dimension,
        name: fromJson['Name'], type: fromJson['Type']);
  }

  @override
  String createTM1Path() {
    return 'api/v1/Dimensions(\'}ElementAttributes_$dimension\')/Hierarchies(\'}ElementAttributes_$dimension\')/Elements';
  }

  @override
  String body() {
    Map<String, dynamic> bodyMap = {
      '"Name"': '"$name"',
      '"Type"': '"$type"'
    };
    return bodyMap.toString();
  }
}
