import 'package:flutter/material.dart';
import 'package:my_color_picker/my_color_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Color color = Colors.black;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          MyColorPopupButton(
            color: color,
            isSelected: true,
            onChanged: (Color? newColor) {
              setState(() {
                color = newColor ?? color;
              });
            },
          )
        ],
      ),
      body: Center(
        child: ColorPickerSlider(
          onChanged: (val) {
            print(val);
          },
          initialValue: 127,
        ),
      ),
    );
  }
}
