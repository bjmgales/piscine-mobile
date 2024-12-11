import 'package:flutter/material.dart';
import 'button_handler.dart';

class Expression extends StatelessWidget {
  final String expression;
  const Expression({super.key, required this.expression});

  @override
  Widget build(BuildContext context) {
    return (SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      reverse: true,
      child: Text(expression.isEmpty ? '0' : expression,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
          softWrap: false,
          overflow: TextOverflow.clip,
          textAlign: TextAlign.left),
    ));
  }
}

class Result extends StatelessWidget {
  final String result;
  const Result({
    super.key,
    required this.result,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      result,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 20,
      ),
    );
  }
}

class ButtonGrid extends StatelessWidget {
  final void Function(String text) onPressed;
  final Orientation orientation;
  const ButtonGrid(
      {super.key, required this.onPressed, required this.orientation});

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.black,
        alignment: Alignment.centerRight,
        child: GridView(
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
            crossAxisSpacing: orientation == Orientation.landscape ? 40 : 10,
            mainAxisSpacing: 10,
            childAspectRatio: orientation == Orientation.landscape ? 3 : 1,
          ),
          children: [
            SimpleBtn(onPressed: onPressed, btnText: '7'),
            SimpleBtn(onPressed: onPressed, btnText: '8'),
            SimpleBtn(onPressed: onPressed, btnText: '9'),
            SimpleBtn(onPressed: onPressed, btnText: 'C'),
            SimpleBtn(onPressed: onPressed, btnText: 'AC'),
            SimpleBtn(onPressed: onPressed, btnText: '4'),
            SimpleBtn(onPressed: onPressed, btnText: '5'),
            SimpleBtn(onPressed: onPressed, btnText: '6'),
            SimpleBtn(onPressed: onPressed, btnText: '+'),
            SimpleBtn(onPressed: onPressed, btnText: '-'),
            SimpleBtn(onPressed: onPressed, btnText: '1'),
            SimpleBtn(onPressed: onPressed, btnText: '2'),
            SimpleBtn(onPressed: onPressed, btnText: '3'),
            SimpleBtn(onPressed: onPressed, btnText: 'x'),
            SimpleBtn(onPressed: onPressed, btnText: '/'),
            SimpleBtn(onPressed: onPressed, btnText: '0'),
            SimpleBtn(onPressed: onPressed, btnText: '.'),
            SimpleBtn(onPressed: onPressed, btnText: '00'),
            SimpleBtn(onPressed: onPressed, btnText: '='),
            const SimpleBtn(btnText: '')
          ],
        ));
  }
}

class SimpleBtn extends StatelessWidget {
  final void Function(String text) onPressed;
  final String btnText;
  const SimpleBtn(
      {super.key, this.onPressed = _dummyPress, required this.btnText});
  static void _dummyPress(String thisIsBs) {}

  WidgetStateProperty<Color> setButtonColor(Color def, Color pressed) {
    return WidgetStateProperty.resolveWith((Set<WidgetState> states) {
      if (states.contains(WidgetState.pressed)) {
        return pressed;
      }
      return def;
    });
  }

  Color setTextColor(String btnText) {
    if (isClear(btnText) || isAllClear(btnText)) {
      return const Color.fromARGB(255, 255, 0, 0);
    } else if (isOperator(btnText) || isEqual(btnText) || btnText == 'x') {
      return const Color.fromARGB(255, 0, 8, 255);
    }
    return const Color.fromARGB(255, 0, 0, 0);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 0,
        height: 0,
        child: ElevatedButton(
            onPressed: () => onPressed(btnText),
            style: ButtonStyle(
              backgroundColor: setButtonColor(
                  const Color.fromARGB(255, 255, 247, 0),
                  const Color.fromARGB(255, 211, 182, 15)),
            ),
            child: Text(
              btnText,
              softWrap: false,
              style: TextStyle(
                  color: setTextColor(btnText),
                  fontWeight: FontWeight.w900,
                  fontSize: 15),
            )));
  }
}
