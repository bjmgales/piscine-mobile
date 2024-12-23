import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart' as math_exp;

bool isNum(String lastChar) {
  return RegExp(r'[0-9]').hasMatch(lastChar) ? true : false;
}

bool isOperator(String lastChar) {
  return RegExp(r'[x\-+/]').hasMatch(lastChar) ? true : false;
}

bool isClear(String lastChar) {
  return lastChar == 'C' ? true : false;
}

bool isAllClear(String expression) {
  return expression.contains('AC') ? true : false;
}

bool isEqual(String lastChar) {
  return lastChar == '=' ? true : false;
}

bool isDot(String lastChar) {
  return lastChar == '.' ? true : false;
}

String truncateBeforeLastNum(String expression, int lastIndex) {
  String lastChar = expression[lastIndex];
  while (lastIndex > 0 && (isNum(lastChar) || isDot(lastChar))) {
    lastIndex--;
    lastChar = expression[lastIndex];
  }
  if (lastIndex == 0) {
    return '';
  }
  return expression.substring(0, lastIndex + 1);
}

String truncatePenultimateNum(String expression, int lastIndex) {
  String lastChar = expression[lastIndex];
  while (lastIndex > 0 && (isNum(lastChar) || isDot(lastChar))) {
    lastIndex--;
    lastChar = expression[lastIndex];
  }
  return expression.substring(lastIndex);
}

String remLastChar(String expression) {
  return expression.substring(0, expression.length - 1);
}

String zeroHandler(String expression, String text, int lastIndex) {
  String lastChar = expression[lastIndex];

  String lastEntry = truncatePenultimateNum(expression, lastIndex);
  int i = 0;
  if (isOperator(lastChar) && (text == '0' || text == '00')) {
    return '${expression}0';
  }
  if (isOperator(lastEntry)) {
    i++;
  }
  for (i; i < lastEntry.length; i++) {
    if (lastEntry[i] != '0') {
      return ('$expression$text');
    }
  }
  if (isNum(text) && text != '0' && text != '00') {
    return '${expression.substring(0, expression.length - 1)}$text';
  }
  return expression;
}

String convertScientificNotation(String result) {
  double toto = double.parse(result);
  String expression = toto.toStringAsFixed(20);
  if (expression.contains('.')) {
    int i = expression.length - 1;
    while (expression[i] == '0') {
      i--;
    }
    expression = expression.substring(0, i + 1);
  }
  return expression;
}

List<String> completeExpression(
    String expression, String text, String result, BuildContext context) {
  if (result != '0') {
    if (isNum(text) || text == 'C') {
      result = '0';
    } else if (result != 'undefined') {
      if (result.contains('e')) {
        expression = convertScientificNotation(result);
        if (expression.contains('e')) {
          expression = '';
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                  "Scientific notation conversion is impossible. What a big number."),
              duration: Duration(seconds: 3),
            ),
          );
        }
      } else {
        expression = result;
      }
    }
    result = '0';
  }

  int lastIndex = expression.length - 1;
  bool emptyExp = expression.isEmpty;
  String lastChar = !emptyExp ? expression[lastIndex] : '';

  if (emptyExp && (isDot(text) || isOperator(text))) {
    if (text == '-') {
      return [text, result];
    }
    return ["0$text", result];
  } else if (!emptyExp && (text == '0' || text == '00')) {
    return [zeroHandler(expression, text, lastIndex), result];
  } else if (emptyExp && isNum(text) && text.length == 1) {
    return [text, result];
  } else if (emptyExp) {
    return ['', result];
  } else if (isDot(lastChar) && isDot(text)) {
    return [expression, result];
  } else if (isDot(text) &&
      truncatePenultimateNum(expression, lastIndex).contains('.')) {
    return [expression, result];
  } else if (isOperator(lastChar) && isOperator(text)) {
    return ['${remLastChar(expression)}$text', result];
  } else if (isAllClear(text)) {
    return ['', '0'];
  } else if (isClear(text)) {
    return [remLastChar(expression), result];
  } else if (isOperator(lastChar) && isDot(text)) {
    return ['${expression}0$text', result];
  } else if (isDot(lastChar) && isOperator(text)) {
    return ['${remLastChar(expression)}$text', result];
  } else if (!emptyExp && isNum(text) && lastChar == '0') {
    return [zeroHandler(expression, text, lastIndex), result];
  }
  return ['$expression$text', result];
}

String calculateExpression(String expression, BuildContext context) {
  int lastIndex = expression.length - 1;
  String lastChar = expression[lastIndex];

  if (isDot(lastChar) || isOperator(lastChar)) {
    expression = remLastChar(expression);
  }
  expression = expression.replaceAll('x', '*');

  math_exp.Parser p = math_exp.Parser();
  math_exp.Expression exp = p.parse(expression);
  double result =
      exp.evaluate(math_exp.EvaluationType.REAL, math_exp.ContextModel());
  try {
    if (result % 1 == 0) {
      return result.toStringAsFixed(0);
    }
  } catch (e) {
    debugPrint('Error:$e');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Colors.yellow,
        content: Text(
          "Reminder: division by zero is impossible.\n"
          "Or maybe you used an insanely and unwisely large number",
          style: TextStyle(color: Colors.black),
        ),
        duration: Duration(seconds: 3),
      ),
    );
    return ('undefined');
  }
  return result.toString();
}
