import 'dart:convert';

import 'package:tm1_dart/Services/CubeService.dart';
import 'package:tm1_dart/Services/HierarchyService.dart';
import 'package:tm1_dart/Services/ObjectService.dart';
import 'package:tm1_dart/Utils/JsonConverter.dart';

import 'RESTConnection.dart';

class CellService extends ObjectService {
  static final sandboxDim = 'Sandboxes';
  RESTConnection restConnection = RESTConnection.restConnection;

  Future<dynamic> getValue(String cubeName,
      Map<String, Map<String, List<String>>> dimensionHierarchyElementMap,
      {bool suppressEmptyRows = false,
      bool suppressEmptyColumns = false}) async {
    /*Element_String describes the Dimension-Hierarchy-Element arrangement

        :param cube_name: Name of the cube
        :param dimensionHierarchyElementMap: map of dimensions, hierarchies and elements that will be used,
        if no default element of a first dimension, and first hierarchy is returned; if no default element is
        returned, the first element is returned; if dimension that is not in list of dimensions for a given cubes is selected,
        dimension is omitted, same with elements in hierarchies
        :param dimensions: List of dimension names in correct order
        :return: */

    // prepare a map of dimension/list/elements

    List<String> dimensionNames = await CubeService()
        .getDimensions(cubeName)
        .then((x) => x.map((d) => d.name).toList());
    List<String> listOfDimsFromParam =
        dimensionHierarchyElementMap.keys.toList();
    for (String dim in listOfDimsFromParam) {
      if (!dimensionNames.contains(dim)) {
        dimensionHierarchyElementMap.remove(dim);
      }
    }
    for (String dim in dimensionNames) {
      if (!listOfDimsFromParam.contains(dim)) {
        String newElement = await HierarchyService().getDefaultMember(dim, dim);
        if (newElement.length == 0) {
          newElement = await HierarchyService()
              .getElements(dim, dim)
              .then((x) => x.keys.toList()[0]);
        }
        Map<String, Map<String, List<String>>> newEntry = {
          'dim': {
            'dim': [newElement]
          }
        };
        dimensionHierarchyElementMap.addAll(newEntry);
      }
    }
    //Refresh list as new elements were added
    listOfDimsFromParam = dimensionHierarchyElementMap.keys.toList();

    //take all dimensions into rows and get the last one to the columns
    List<String> listOfDimsForRows =
        listOfDimsFromParam.sublist(0, listOfDimsFromParam.length - 1);
    List<String> listOfDimsForColumns =
        listOfDimsFromParam.sublist(listOfDimsFromParam.length - 1);
    List<String> listOfDimsForTitles = [];

    String mdx = _prepareMDX(
        cubeName,
        suppressEmptyRows,
        suppressEmptyColumns,
        listOfDimsForRows,
        listOfDimsForColumns,
        listOfDimsForTitles,
        dimensionHierarchyElementMap);
  }

  String _prepareMDX(
      String cubeName,
      bool suppressEmptyRows,
      bool suppressEmptyColumns,
      List<String> listOfDimsForRows,
      List<String> listOfDimsForColumns,
      List<String> listOfDimsForTitles,
      Map<String, Map<String, List<String>>> dimensionHierarchyElementMap) {
    StringBuffer mdx = StringBuffer('SELECT ');
    List<List<String>> axisList = [listOfDimsForRows, listOfDimsForColumns];
    for (List<String> axis in axisList) {
      bool suppress =
          axis == axisList[0] ? suppressEmptyRows : suppressEmptyColumns;
      suppress ? mdx.write('NON EMPTY ') : mdx.write('*');
      int maxI = axis.length;
      for (int i = 0; i < maxI; i++) {
        mdx.write('{');
        String dimensionName = axis[i];
        Map<String, List<String>> HierarchyMap =
            dimensionHierarchyElementMap[dimensionName];
        List<String> hierarchiesList = HierarchyMap.keys.toList();
        for (String hierarchyName in hierarchiesList) {
          List<String> elementsList = HierarchyMap[hierarchyName];
          for (String elementName in elementsList) {
            mdx.write('[' +
                dimensionName +
                '].[' +
                hierarchyName +
                '].[' +
                elementName +
                ']');
          }
        }
        mdx.write('}');
        i < maxI - 1 ? mdx.write(', ') : ' ';
      }
      String axisName = axis == axisList[0] ? 'ROWS, ' : 'COLUMNS ';
      mdx.write('ON $axisName');
      suppressEmptyColumns ? mdx.write('NON EMPTY ') : mdx.write('*');
    }
    mdx.write('FROM [' + cubeName + '] ');
    if (listOfDimsForTitles.length > 0) {
      mdx.write('WHERE(');
      int maxI = listOfDimsForTitles.length;
      for (int i = 0; i < maxI; i++) {
        String dimensionName = listOfDimsForTitles[i];
        Map<String, List<String>> HierarchyMap =
            dimensionHierarchyElementMap[dimensionName];
        List<String> hierarchiesList = HierarchyMap.keys.toList();
        for (String hierarchyName in hierarchiesList) {
          List<String> elementsList = HierarchyMap[hierarchyName];
          for (String elementName in elementsList) {
            mdx.write('[' +
                dimensionName +
                '].[' +
                hierarchyName +
                '].[' +
                elementName +
                ']');
          }
        }

        i < maxI - 1 ? mdx.write(', ') : ' ';
      }
      mdx.write(')');
    }
    return mdx.toString();
  }

  Future<dynamic> _executeMdx(String mdx,
      {List<String> cellProperties,
      String top = '',
        skipContexts = false}) async {
    /*Execute MDX and return the cells with their properties
        :param mdx: MDX Query, as string
        :param cell_properties: properties to be queried from the cell. E.g. Value, Ordinal, RuleDerived, ...
        :param top: integer
        :param skip_contexts: skip elements from titles / contexts in response
        :return: content in sweet concise structure.*/
    int cellsetID = await _createCellSet(mdx);
  }

  Future<int> _createCellSet(String mdx) async {
    String path = '/api/v1/ExecuteMDX';
    Map<String, dynamic> body = {'MDX': mdx};
    var response = await restConnection.runPost(path, {}, body.toString());
    var decodedJson = jsonDecode(await transformJson(response));
    int cellSetId = decodedJson['ID'];
    return cellSetId;
  }

  Future<Map<String, dynamic>> _extractCellSet(int cellSetId,
      {List<String> cellProperties,
        bool deleteCellSet = true,
        String top = '',
        skipContexts = false}) {
    cellProperties = cellProperties.isEmpty ? ['Value'] : cellProperties;

    var rawCallSet = _extractCellSetRaw(cellSetId,
        cellProperties: cellProperties,
        elemProperties: ['UniqueName'],
        memberProperties: ['UniqueName'],
        top: top,
        skipContexts: skipContexts,
        deleteCellSet: deleteCellSet);

    Future<Map<String, dynamic>> Content = _buildContentFromCellSet(
        rawCallSet, top);
  }

  Future<Map<String, dynamic>> _extractCellSetRaw(int cellSetId,
      {List<String> cellProperties,
        List<String> elemProperties,
        List<String> memberProperties,
        String top = '',
        bool skipContexts = false,
        bool deleteCellSet}) async {
    cellProperties = cellProperties.isEmpty ? ['Value'] : cellProperties;
    memberProperties = memberProperties.isEmpty ? ['Name'] : memberProperties;
    elemProperties = elemProperties.isEmpty ? [''] : elemProperties;
    String selectMemberProperties = '\$select=' + memberProperties.join(',');
    String expandElementProperties =
        ';\$expand=Element(\$select=' + elemProperties.join(',') + ')';
    String joinCellProperties = cellProperties.join(',');

    String filterAxis = skipContexts ? '\$filter=Ordinal ne 2;' : '';

    String path = '''
/api/v1/Cellsets(\'$cellSetId\')?\$expand=Cube(\$select=Name;\$expand=Dimensions(\$select=Name)),
Axes($filterAxis\$expand=Tuples(\$expand=Members($selectMemberProperties $expandElementProperties)\$top=$top)),
Cells(\$select=$joinCellProperties\$top=$top)''';

    var bodyReturned = await restConnection.runGet(path);
    var decodedJson = jsonDecode(await transformJson(bodyReturned));
    return decodedJson;
  }

  _buildContentFromCellSet(Future<Map<String, dynamic>> rawCallSet,
      String top) {}
}
