import 'package:tm1_dart/Objects/TM1Object.dart';

class View extends TM1Object {
  final String name;
  final String cubeName;

  View({this.name, this.cubeName});

  factory View.fromJson(Map<String, dynamic> parsedJson) {
    return new View(name: parsedJson['Name'], cubeName: parsedJson['Cube']);
  }
  @override
  String createTM1Path() {
    return 'api/v1/Cubes\'$cubeName\')/Views';
  }

  @override
  String body() {
    // TODO: implement body
    return null;
  }
}
