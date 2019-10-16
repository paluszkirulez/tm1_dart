abstract class TM1Object{
  String name;
  final String classType = '';


  Map<String, dynamic> toJson();

  String createTM1Path(){
    return 'api/v1/$classType';
  }
  /// abstraction of all classes that tm1 consist off
  TM1Object();

  String body();



}