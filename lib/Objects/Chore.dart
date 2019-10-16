import 'dart:convert';

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


  Chore(this.name, this.startTime, this.DSTSensitive, this.active,
      this.executionMode, this.frequency, this.tasks);

  @override
  String body() {
    return json.encode(toJson());
  }

  @override
  String createTM1Path() {
    return 'api/v1/Chores';
  }
}
