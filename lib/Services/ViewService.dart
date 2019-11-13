import 'dart:convert';

import 'package:tm1_dart/Objects/Axis/ViewAxisSelection.dart';
import 'package:tm1_dart/Objects/Axis/ViewTitleSelection.dart';
import 'package:tm1_dart/Objects/Subset.dart';
import 'package:tm1_dart/Objects/View/NativeView.dart';
import 'package:tm1_dart/Objects/View/View.dart';
import 'package:tm1_dart/Utils/JsonConverter.dart';

import 'ObjectService.dart';

enum axisType { Columns, Rows, Titles }

class ViewService extends ObjectService {
  Future<View> getView(String cubeName, String viewName,
      {bool private = false}) async {
    String privateName = private ? 'PrivateViews' : 'Views';
    String path = 'api/v1/Cubes(\'$cubeName\')/$privateName(\'$viewName\')';
    var bodyReturned = await restConnection.runGet(path);
    var decodedJson = jsonDecode(await transformJson(bodyReturned));
    Map<String, dynamic> objectMap = {};
    objectMap.addAll(decodedJson);
    objectMap.addAll({'private': private});
    View view = View.fromJson(objectMap);
    return view;
  }

  Future<List<dynamic>> _getSelectionMap(
      String cubeName, String viewName, axisType axisType,
      {bool private = false}) async {
    String axis = axisType.toString().split('.').last;
    String titlesAdd = axis == 'Titles'
        ? ',tm1.NativeView/Titles/Selected(\$select=Name)'
        : '';
    Map<String, dynamic> nativeViewParameters = {
      '\$expand':
          'tm1.NativeView/$axis/Subset(\$expand=Hierarchy(\$select=Name;\$expand=Dimension(\$select=Name)),Elements(\$select=Name);\$select=Expression,UniqueName,Name, Alias)' +
              titlesAdd
    };
    String privateName = private ? 'PrivateViews' : 'Views';
    String path = 'api/v1/Cubes(\'$cubeName\')/$privateName(\'$viewName\')';
    var bodyReturned =
        await restConnection.runGet(path, parameters: nativeViewParameters);
    var decodedJson = jsonDecode(await transformJson(bodyReturned));
    var axisDecoded = decodedJson[axis];
    List<dynamic> objectList = axisDecoded;
    //print(objectMap.toString());
    return objectList;
  }

  Future<List<ViewTitleSelection>> _getTitle(String cubeName, String viewName,
      {bool private = false}) async {
    List<dynamic> objectList = await _getSelectionMap(
        cubeName, viewName, axisType.Titles,
        private: private);
    List<ViewTitleSelection> viewTitleSelectionList = [];
    for (var title in objectList) {
      Map<String, dynamic> objectMap = title;
      Subset subset = Subset.fromJson(objectMap);
      String selected = objectMap['Selected']['Name'];
      viewTitleSelectionList.add(ViewTitleSelection.fromJson(
          {'Subset': subset, 'Selected': selected}));
    }
    return viewTitleSelectionList;
  }

  Future<List<ViewAxisSelection>> _getAxis(
      String cubeName, String viewName, axisType axisType,
      {bool private = false}) async {
    //axisType should be Rows,Columns or Titles
    List<dynamic> objectList =
        await _getSelectionMap(cubeName, viewName, axisType, private: private);
    List<ViewAxisSelection> viewAxisSelectionList = [];
    for (var title in objectList) {
      Map<String, dynamic> objectMap = title;
      Subset subset = Subset.fromJson(objectMap);
      viewAxisSelectionList.add(ViewAxisSelection.fromJson({'Subset': subset}));
    }
    return viewAxisSelectionList;
  }

  Future<NativeView> getNativeView(String cubeName, String viewName,
      {bool private = false}) async {
    String privateName = private ? 'PrivateViews' : 'Views';
    String path = 'api/v1/Cubes(\'$cubeName\')/$privateName(\'$viewName\')';
    var bodyReturned = await restConnection.runGet(path);
    var decodedJson = jsonDecode(await transformJson(bodyReturned));
    Map<String, dynamic> objectMap = {};
    objectMap.addAll(decodedJson);
    objectMap.addAll({'cubeName': cubeName});
    List<ViewTitleSelection> titles =
        await _getTitle(cubeName, viewName, private: private);
    List<ViewAxisSelection> rows =
        await _getAxis(cubeName, viewName, axisType.Rows, private: private);
    List<ViewAxisSelection> columns =
        await _getAxis(cubeName, viewName, axisType.Columns, private: private);
    NativeView view = NativeView.fromJson(objectMap, rows, titles, columns);
    return view;
  }
}
