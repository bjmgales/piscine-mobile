import 'package:flutter/material.dart';

class HomePage extends StatelessWidget{

  final WidgetStateProperty<Color> Function(Color, Color) setButtonColor;
  const HomePage({super.key, required this.setButtonColor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SimpleText(
              key: ValueKey('simpTxt')
            ),
            const SizedBox(height: 10,),
            SimpleBtn(
              key: const ValueKey('simpBtn'),
              setButtonColor: setButtonColor,
            )
          ])
    ));
  }
}

class SimpleText extends StatelessWidget{

  const SimpleText({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: const BoxDecoration(
        color: Colors.yellow,
        borderRadius: BorderRadius.all(Radius.elliptical(20, 20)),
      ),
      child: const Text(
        'A simple text',
        style:  TextStyle(
          color: Colors.black,
          fontSize: 50,
        ),
      ));
  }
}

class SimpleBtn extends StatelessWidget{

  final WidgetStateProperty<Color> Function(Color, Color) setButtonColor;
  const SimpleBtn({super.key, required this.setButtonColor});
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: (){debugPrint('Button Pressed');},
      style: ButtonStyle(
        backgroundColor: setButtonColor(
            const Color.fromARGB(255, 0, 0, 0), const Color.fromARGB(255, 62, 58, 59)),
      ),
      child: const Text(
        'click me!',
        style: TextStyle(color: Colors.yellow),
      ));
  }
}