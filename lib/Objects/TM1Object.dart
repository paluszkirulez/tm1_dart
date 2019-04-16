abstract class TM1Object{
  String name;
  final String classType = '';


  String body();

  String createTM1Path(){
    return 'api/v1/$classType';
  }
  /// abstraction of all classes that tm1 consist off
  TM1Object();



}