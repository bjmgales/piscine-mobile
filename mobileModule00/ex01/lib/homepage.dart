import 'package:flutter/material.dart';

class HomePage extends StatefulWidget{

  final WidgetStateProperty<Color> Function(Color, Color) setButtonColor;
  const HomePage({super.key, required this.setButtonColor});
  @override
  State<HomePage> createState() => _HomePageState();
}
class _HomePageState extends State<HomePage>{

  String displayText = 'A simple text';
  void updateText(){
    setState((){
      displayText = displayText == "A simple text" ? "Hello World!" : "A simple text";
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SimpleText(
              key: const ValueKey('simpTxt'),
              text: displayText
            ),
            const SizedBox(height: 10,),
            SimpleBtn(
              key: const ValueKey('simpBtn'),
              setButtonColor: widget.setButtonColor,
              onPressed : updateText,
            )
        ])
    ));
  }
}

class SimpleText extends StatelessWidget{

  final String text;
  const SimpleText({super.key, required this.text});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: const BoxDecoration(
        color: Colors.yellow,
        borderRadius: BorderRadius.all(Radius.elliptical(20, 20)),
      ),
      child: Text(
        text,
        style:  const TextStyle(
          color: Colors.black,
          fontSize: 50,
        ),
      ));
  }
}

class SimpleBtn extends StatelessWidget{

  final WidgetStateProperty<Color> Function(Color, Color) setButtonColor;
  final void Function() onPressed;
  const SimpleBtn({super.key, required this.setButtonColor, required this.onPressed});
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: setButtonColor(
            const Color.fromARGB(255, 0, 0, 0),
            const Color.fromARGB(255, 62, 58, 59)),
      ),
      child: const Text(
        'click me!',
        style: TextStyle(color: Colors.yellow),
      ));
  }
}