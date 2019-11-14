// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'View.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

View _$ViewFromJson(Map<String, dynamic> json) {
  return View(
    json['name'] as String,
    json['cubeName'] as String,
  )..private = json['private'] as bool;
}

Map<String, dynamic> _$ViewToJson(View instance) => <String, dynamic>{
      'name': instance.name,
      'cubeName': instance.cubeName,
    };
