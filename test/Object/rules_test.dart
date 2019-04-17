import 'package:tm1_dart/Objects/Rule.dart';
import 'package:flutter_test/flutter_test.dart';

void main(){
  Map<String, dynamic> testRuleBody = {"Rules": "#Region System\nFEEDSTRINGS;\nSKIPCHECK;\n#EndRegion"};
  String ruleName = 'PNLCube';

  Rule rule = Rule.fromJson(ruleName, testRuleBody);

  test('test if rule is created properly',() {
    expect(testRuleBody['Rules'], rule.ruleBody);

  });

  test('test if getting rid of \\n elements work correctly',() {
    String formattedBody = "FEEDSTRINGS;SKIPCHECK;";
    //expect(formattedBody, rule.formattedBody);
    //expect(false, rule.hasFeeders);
    expect(true, rule.hasSkipcheck);
    //expect(false, rule.hasUndefVals);

  });


}