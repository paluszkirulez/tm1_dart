import 'package:tm1_dart/Objects/Axis/ViewSelection.dart';
import 'package:tm1_dart/Objects/Subset.dart';

class ViewTitleSelection extends ViewSelection {
  Subset subset;
  String selected;

  ViewTitleSelection(this.subset, this.selected)
      : super(subset);

  @override
  Map<String, dynamic> toJson() {
    var preparedBody = super.toJson();
    var selected = createTM1Path().substring(
        0, createTM1Path().length - '/Subsets(\'${subset.name}\')'.length) +
        '/Elements(\'${this.selected}\')';
    preparedBody.addAll({'Selected@odata.bind': selected});
    return preparedBody;
  }

  factory ViewTitleSelection.fromJson(Map<String, dynamic> json) {
    return ViewTitleSelection(
        json['Subset'] as Subset,
        json['Selected'] as String);
  }
}
