import 'package:json_annotation/json_annotation.dart';
import 'package:tm1_dart/Objects/TM1Object.dart';

part 'Chore.g.dart';

@JsonSerializable()
class Chore extends TM1Object {
  final String name;
  final String startTime;
  final String DSTSensitive;
  final bool active;
  final String executionMode;
  final String frequency;
  final String tasks;

  factory Chore.fromJson(Map<String, dynamic> json) => _$ChoreFromJson(json);

  Map<String, dynamic> toJson() => _$ChoreToJson(this);

  @override
  String body() {
    // TODO: implement body
    return null;
  }

  Chore(this.name, this.startTime, this.DSTSensitive, this.active,
      this.executionMode, this.frequency, this.tasks);
}
