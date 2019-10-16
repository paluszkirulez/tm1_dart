import 'package:json_annotation/json_annotation.dart';
import 'package:tm1_dart/Objects/TM1Object.dart';

part 'View.g.dart';

@JsonSerializable(explicitToJson: true)
class View extends TM1Object {
  final String name;
  final String cubeName;


  View(this.name, this.cubeName);

  factory View.fromJson(Map<String, dynamic> json) => _$ViewFromJson(json);

  Map<String, dynamic> toJson() => _$ViewToJson(this);

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
