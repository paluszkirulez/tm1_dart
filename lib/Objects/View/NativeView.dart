import 'package:tm1_dart/Objects/Axis/ViewAxisSelection.dart';
import 'package:tm1_dart/Objects/Axis/ViewTitleSelection.dart';
import 'package:tm1_dart/Objects/Subset.dart';
import 'package:tm1_dart/Objects/UnregSubset.dart';
import 'package:tm1_dart/Objects/View/View.dart';

class NativeView extends View {
  /// this is the abstracion of native view

  String name;
  final String cubeName;
  bool suppressEmptyColumns = true;
  bool suppressEmptyRows = true;
  String format = "0.#########";
  List<ViewAxisSelection> rows;
  List<ViewTitleSelection> titles;
  List<ViewAxisSelection> columns;
  bool private = false;

  NativeView(this.name, this.cubeName, this.suppressEmptyColumns,
      this.suppressEmptyRows, this.format, this.rows, this.titles, this.columns,
      {this.private = false})
      : super(name, cubeName, private: private);

  factory NativeView.fromJson(Map<String, dynamic> json,
      List<ViewAxisSelection> rows,
      List<ViewTitleSelection> titles,
      List<ViewAxisSelection> columns,
      {bool private = false}) {
    return NativeView(
        json['Name'] as String,
        json['Cube']['Name'] as String,
        json['SupressEmptyColumns'] as bool,
        json['SupressEmptyRows'] as bool,
        json['FormatString'] as String,
        rows,
        titles,
        columns,
        private: private);
  }

  String prepareMDXQueryView() {
    List<List<ViewAxisSelection>> axisList = [columns, rows];
    StringBuffer mdx = StringBuffer('SELECT ');

    // preparation of 'SELECT .... (FROM)
    for (List<dynamic> axis in axisList) {
      suppressEmptyRows ? mdx.write('NON EMPTY ') : mdx.write('*');
      for (ViewAxisSelection axe in axis) {
        Subset subset = axe.subset;
        if (subset.runtimeType == UnregSubset) {
          if (subset.expression != '') {
            mdx.write('{');
            mdx.write(subset.expression + '} ');
          } else {
            StringBuffer uniqNames = StringBuffer('');
            List<String> tempListElements = subset.elements.keys.toList();
            for (int i = 0; i < tempListElements.length; i++) {
              uniqNames
                  .write('[${subset.dimensionName}].[${tempListElements[i]}]');
              if (i < tempListElements.length - 1) {
                uniqNames.write(', ');
              }
            }
            mdx.write('{');
            mdx.write(uniqNames.toString());
            mdx.write('} ');
          }
        } else {
          mdx.write(
              'TM1SubsetToSet([${subset.dimensionName}],"${subset.name}")');
        }
      }
      if (axis == rows) {
        mdx.write('ON ROWS ');
      } else {
        mdx.write('ON COLUMNS, ');
      }
    }

    //FROM processing
    mdx.write('FROM [' + cubeName + '] ');

    //WHERE processing
    if (titles.length > 0) {
      StringBuffer uniqNames = StringBuffer('');
      for (int i = 0; i < titles.length; i++) {
        uniqNames.write(
            '[${titles[i].subset.dimensionName}].[${titles[i].selected}]');
        if (i < titles.length - 1) {
          uniqNames.write(', ');
        }
      }
      mdx.write('WHERE (');
      mdx.write(uniqNames.toString());
      mdx.write(')');
    }
    return mdx.toString();
  }

  @override
  String body() {
    return _constructBody();
  }

  String _constructBody() {
    /// create json representation of json data
    ///
    StringBuffer totalString = StringBuffer('');
    String topBody =
        '{"@odata.type": "ibm.tm1.api.v1.NativeView","Name": "$name",';
    StringBuffer columsBody = StringBuffer('');
    for (int i = 0; i < columns.length; i++) {
      columsBody.write(columns[i].body());
      if (i < columns.length - 1) {
        columsBody.write(',');
      }
    }
    StringBuffer rowsBody = StringBuffer('');
    for (int i = 0; i < rows.length; i++) {
      rowsBody.write(rows[i].body());
      if (i < rows.length - 1) {
        rowsBody.write(',');
      }
    }
    StringBuffer titlesBody = StringBuffer('');
    for (int i = 0; i < titles.length; i++) {
      titlesBody.write(titles[i].body());
      if (i < titles.length - 1) {
        titlesBody.write(',');
      }
    }
    String epilogBody =
        '"SuppressEmptyColumns": $suppressEmptyColumns,"SuppressEmptyRows":$suppressEmptyRows,"FormatString":"$format"}';

    totalString.write('' + topBody + '');
    totalString.write('"Columns": [' + columsBody.toString() + '], ');
    totalString.write('"Rows": [' + rowsBody.toString() + '], ');
    totalString.write('"Titles": [' + titlesBody.toString() + '], ');
    totalString.write('' + epilogBody + '');
    return totalString.toString();
  }
}
