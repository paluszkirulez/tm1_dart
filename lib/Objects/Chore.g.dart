// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Chore.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Chore _$ChoreFromJson(Map<String, dynamic> json) {
  return Chore(
    json['name'] as String,
    json['startTime'] as String,
    json['DSTSensitive'] as String,
    json['active'] as bool,
    json['executionMode'] as String,
    json['frequency'] as String,
    json['tasks'] as String,
  );
}

Map<String, dynamic> _$ChoreToJson(Chore instance) => <String, dynamic>{
      'name': instance.name,
      'startTime': instance.startTime,
      'DSTSensitive': instance.DSTSensitive,
      'active': instance.active,
      'executionMode': instance.executionMode,
      'frequency': instance.frequency,
      'tasks': instance.tasks,
    };
