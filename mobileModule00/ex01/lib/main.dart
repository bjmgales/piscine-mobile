import 'package:flutter/material.dart';
import 'homepage.dart';

class MyApp extends StatelessWidget{
  const MyApp({super.key});
  WidgetStateProperty<Color> _setButtonColor(
    Color def, Color pressed) {
      return WidgetStateProperty.resolveWith((Set<WidgetState> states) {
      if (states.contains(WidgetState.pressed)){
        return pressed;
      }
      return def;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: HomePage(
        key: const ValueKey('home'),
        setButtonColor: _setButtonColor,
      ),
    );
  }
}

void main(){
  runApp(const MyApp());
}