import 'package:tm1_dart/Objects/Axis/ViewSelection.dart';
import 'package:tm1_dart/Objects/Subset.dart';

class ViewAxisSelection extends ViewSelection {

  Subset subset;
  String dimensionName;
  String hierarchyName;


  ViewAxisSelection(this.subset, this.dimensionName, this.hierarchyName)
      : super(subset, dimensionName, hierarchyName);


}