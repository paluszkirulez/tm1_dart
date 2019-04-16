import 'package:tm1_dart/Objects/Axis/ViewAxisSelection.dart';
import 'package:tm1_dart/Objects/Subset.dart';
import 'package:tm1_dart/Objects/TM1Object.dart';
import 'package:tm1_dart/Objects/UnregSubset.dart';
import 'dart:convert';

class ViewTitleSelection extends ViewAxisSelection {
  String selected;
  ViewTitleSelection(Subset subset, String dimensionName, String hierarchyName, this.selected) : super(subset, dimensionName, hierarchyName);


  @override
  String createTM1Path() {
    return 'Dimensions(\'$dimensionName\')/Hierarchies(\'$hierarchyName\')/Subsets(\'${subset.name}\')';
  }

  @override
  Map<String, dynamic> constructBody() {
    var preparedBody = super.constructBody();
    var selected = createTM1Path().substring(0,createTM1Path().length-'/Subsets(\'${subset.name}\')'.length)+'/Elements(\'${this.selected}\')';
    preparedBody.addAll({'Selected@odata.bind':selected});
    return preparedBody;
  }


}
