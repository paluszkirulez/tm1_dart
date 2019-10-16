import 'dart:convert';

import 'package:tm1_dart/Objects/Subset.dart';
import 'package:tm1_dart/Objects/TM1Object.dart';
import 'package:tm1_dart/Objects/UnregSubset.dart';

abstract class ViewSelection extends TM1Object {
  Subset subset;
  String dimensionName;
  String hierarchyName;

  ViewSelection(this.subset, this.dimensionName, this.hierarchyName);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> preparedBody = {};
    if (subset.runtimeType == UnregSubset) {
      preparedBody.addAll({'Subset': json.decode(subset.body())});
    } else {
      preparedBody.addAll({'Subset@odata.bind': createTM1Path()});
    }
    return preparedBody;
  }

  @override
  String body() {
    return json.encode(toJson());
  }

  @override
  String createTM1Path() {
    return 'Dimensions(\'$dimensionName\')/Hierarchies(\'$hierarchyName\')/Subsets(\'${subset.name}\')';
  }
}
