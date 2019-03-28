import 'dart:convert';
class Converter{
  String convertToB64(String text){
    var bytes = utf8.encode(text);
    var base64Str = base64.encode(bytes);
    return base64Str;
  }
}