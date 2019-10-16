import 'package:tm1_dart/Objects/Axis/ViewSelection.dart';
import 'package:tm1_dart/Objects/Subset.dart';

class ViewTitleSelection extends ViewSelection {
  String selected;
  ViewTitleSelection(Subset subset, String dimensionName, String hierarchyName, this.selected) : super(subset, dimensionName, hierarchyName);


  @override
  Map<String, dynamic> toJson() {
    var preparedBody = super.toJson();
    var selected = createTM1Path().substring(0,createTM1Path().length-'/Subsets(\'${subset.name}\')'.length)+'/Elements(\'${this.selected}\')';
    preparedBody.addAll({'Selected@odata.bind':selected});
    return preparedBody;
  }


}
