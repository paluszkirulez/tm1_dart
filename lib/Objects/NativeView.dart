import 'package:tm1_dart/Objects/View.dart';

class NativeView extends View{
  /// this is the abstracion of natve view

 // final String name;
  //final String cubeName;
  bool suppressEmptyColumns=true;
  bool suppressEmptyRows=true;
  String format = "0.#########";
  List<String> rows;
  List<String> titles;
  List<String> columns;

}