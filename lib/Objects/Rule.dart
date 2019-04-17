import 'package:tm1_dart/Objects/TM1Object.dart';
import 'package:tm1_dart/Utils/RuleUtils.dart';

class Rule extends TM1Object {
  /// class is abstraction of rules, contains name of the cube where rule
  /// was implemented as well as its body

  final String name;
  final String ruleBody;
  String formattedBody;
  bool hasSkipcheck = false;
  bool hasFeeders = false;
  bool hasUndefVals = false;
  bool hasFeedString = false;

  Rule(this.name,
      {this.ruleBody,
      this.formattedBody,
      this.hasFeedString,
      this.hasFeeders,
      this.hasSkipcheck,
      this.hasUndefVals});

  factory Rule.fromJson(String name, Map<String, dynamic> parsedJson) {
    var _formattedBody = formattedRule(parsedJson['Rules']);
    return new Rule(name,
        ruleBody: parsedJson['Rules'],
        formattedBody: _formattedBody,
        hasFeedString: checkFeedString(_formattedBody),
        hasFeeders: checkHasFeeders(_formattedBody),
        hasSkipcheck: checkHasSkipcheck(_formattedBody),
        hasUndefVals: checkHasUndefVals(_formattedBody));
  }

  @override
  String createTM1Path() {
    return 'api/v1/Cubes(\'$name\')';
  }

  @override
  String body() {
    // TODO: implement body
    return null;
  }
}
