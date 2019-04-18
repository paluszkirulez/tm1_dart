import 'package:tm1_dart/Objects/Axis/ViewAxisSelection.dart';
import 'package:tm1_dart/Objects/Axis/ViewTitleSelection.dart';
import 'package:tm1_dart/Objects/Element.dart';
import 'package:tm1_dart/Objects/Subset.dart';
import 'package:tm1_dart/Objects/UnregSubset.dart';
import 'package:tm1_dart/Objects/View/View.dart';

class NativeView extends View{
  /// this is the abstracion of natve view

  final String name;
  final String cubeName;
  bool suppressEmptyColumns=true;
  bool suppressEmptyRows=true;
  String format = "0.#########";
  List<ViewAxisSelection> rows;
  List<ViewTitleSelection> titles;
  List<ViewAxisSelection> columns;

  NativeView(this.name, this.cubeName, this.suppressEmptyColumns,
      this.suppressEmptyRows, this.format, this.rows, this.titles,
      this.columns);

  String prepareMDXQueryView(){
    List<List<ViewAxisSelection>> axisList = [columns,rows];
    StringBuffer mdx = StringBuffer('SELECT ');

    // preparation of 'SELECT .... (FROM)
    for(List<dynamic> axis in axisList){
      suppressEmptyRows ? mdx.write('NON EMPTY '):   mdx.write('*');
      for(ViewAxisSelection axe in axis){
        Subset subset = axe.subset;
        if(subset.runtimeType == UnregSubset){
          if(subset.MDX!=''){
            mdx.write(subset.MDX+' ');
          }
          else{
            StringBuffer uniqNames = StringBuffer('');
            for(int i = 0;i<subset.elements.length;i++){
              uniqNames.write('[${subset.dimensionName}].[${subset.elements[i].name}]');
              if(i<subset.elements.length-1){
                uniqNames.write(', ');
              }
            }
            mdx.write('{');
            mdx.write(uniqNames.toString());
            mdx.write('} ');
          }
        }
        else{
          mdx.write('TM1SubsetToSet([{${subset.dimensionName}],"{${subset.name}")');
        }
      }
      if(axis == rows){
        mdx.write('ON ROWS ');
      }
      else{
        mdx.write('ON COLUMNS, ');
      }
    }

    //FROM processing
    mdx.write('FROM [' + cubeName+'] ');

    //WHERE processing
    if(titles.length > 0){
      StringBuffer uniqNames = StringBuffer('');
      for(int i =0;i<titles.length;i++){
        uniqNames.write('[${titles[i].dimensionName}].[${titles[i].selected}]');
        if(i<titles.length-1){
          uniqNames.write(', ');
        }
      }
      mdx.write('WHERE (');
      mdx.write(uniqNames.toString());
      mdx.write(')');
    }
    return mdx.toString();
  }




}