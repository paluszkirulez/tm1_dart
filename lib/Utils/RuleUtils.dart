enum RuleKeywords { SKIPCHECK, FEEDSTRING, UNDEFVALS, FEEDERS }

String formattedRule(String unformattedBody) {
  /// function will return formula without new line symbols and comments
  ///
  List<String> listOfLine = unformattedBody.split('\n');
  for (int i = 0; i < listOfLine.length; i++) {
    if (listOfLine[i].contains('#')) {
      listOfLine[i] = '';
    }
  }
  var ruleBody = listOfLine.join();

  return ruleBody;
}

bool checkHasFeeders(String formattedRule) {
  if (formattedRule.toLowerCase().contains(
      RuleKeywords.FEEDERS.toString().split('.').last.toLowerCase())) {
    return true;
  }
  return false;
}

bool checkHasSkipcheck(String formattedRule) {
  if (formattedRule.toLowerCase().contains(
      RuleKeywords.SKIPCHECK.toString().split('.').last.toLowerCase())) {
    return true;
  }
  return false;
}

bool checkHasUndefVals(String formattedRule) {
  if (formattedRule.toLowerCase().contains(
      RuleKeywords.UNDEFVALS.toString().split('.').last.toLowerCase())) {
    return true;
  }
  return false;
}

bool checkFeedString(String formattedRule) {
  if (formattedRule.toLowerCase().contains(
      RuleKeywords.FEEDSTRING.toString().split('.').last.toLowerCase())) {
    return true;
  }
  return false;
}
