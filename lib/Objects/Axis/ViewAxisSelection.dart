import 'package:tm1_dart/Objects/Axis/ViewSelection.dart';
import 'package:tm1_dart/Objects/Subset.dart';

class ViewAxisSelection extends ViewSelection {
  Subset subset;


  ViewAxisSelection(this.subset)
      : super(subset);

  factory ViewAxisSelection.fromJson(Map<String, dynamic> json) {
    return ViewAxisSelection(json['Subset'] as Subset);
  }
}
