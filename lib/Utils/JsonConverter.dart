import 'dart:io';

import 'dart:convert';

Future<String> transformJson(HttpClientResponse response){
  return response.transform(Utf8Decoder()).join();
}