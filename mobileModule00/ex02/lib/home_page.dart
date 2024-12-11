import 'package:ex02/calculator.dart';
import 'package:flutter/material.dart';
import 'button_handler.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});
  @override
  State<Homepage> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<Homepage> {
  String expression = '';
  String result = '0';

  void onPressed(String text) {
    debugPrint('Button pressed: $text');
    setState(() {
      List<String> updatedValues =
          completeExpression(expression, text, result, context);

      expression = updatedValues[0];
      result = updatedValues[1];
      if (expression.contains('=')) {
        result = calculateExpression(remLastChar(expression), context);
        expression = '';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Orientation orientation = MediaQuery.of(context).orientation;
    double screenHeight = MediaQuery.of(context).size.height;
    double height = orientation == Orientation.landscape
        ? screenHeight * 0.25
        : screenHeight * 0.4;
    final padding = MediaQuery.of(context).padding;
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: const MyAppBar(),
        body: Padding(
          padding: EdgeInsets.only(
            right: orientation == Orientation.landscape ? padding.right : 0,
            left: orientation == Orientation.landscape ? padding.right : 0,
          ),
          child: Column(
            children: [
              Align(
                  alignment: Alignment.topRight,
                  child: Expression(expression: expression)),
              Align(
                  alignment: Alignment.topRight,
                  child: Result(
                    result: result,
                  )),
              SizedBox(height: height - 30),
              Expanded(
                  child: ButtonGrid(
                      onPressed: onPressed, orientation: orientation))
            ],
          ),
        ));
  }
}

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.black,
      title: const Text('Calculator'),
      titleTextStyle: const TextStyle(
        color: Colors.yellow,
        fontSize: 20,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(50.0);
}
