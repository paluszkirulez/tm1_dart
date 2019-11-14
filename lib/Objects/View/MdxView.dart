import 'dart:convert';

import 'View.dart';

class MdxView extends View {
  final String name;
  final String cubeName;
  bool private = false;
  String MDX;

  MdxView(this.name, this.cubeName, this.MDX, {this.private})
      : super(name, cubeName, private: private);

  factory MdxView.fromJson(Map<String, dynamic> json) {
    return MdxView(json['Name'] as String, json['Cube']['Name'], json['MDX']);
  }

  Map<String, dynamic> _constructBody() {
    Map<String, dynamic> bodyToReturn = {};
    bodyToReturn.addAll({'@odata.type': 'ibm.tm1.api.v1.MDXView'});
    bodyToReturn.addAll({'Name': name});
    bodyToReturn.addAll({'MDX': MDX});
  }

  @override
  String body() {
    return json.encode(_constructBody());
  }
}
