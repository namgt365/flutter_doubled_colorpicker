
import 'package:flutter/material.dart';
import 'package:flutter_doubled_colorpicker/flutter_doubled_colorpicker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.blue,
        ),
        home: const SamplePage());
  }
}




class SamplePage extends StatefulWidget {
  const SamplePage({Key? key}) : super(key: key);

  @override
  State<SamplePage> createState() => _SamplePageState();
}

class _SamplePageState extends State<SamplePage> {
  Color currentColor = Colors.black;

  onColorChanging(Color color) {}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("sample")),
      body: Center(
        child: Container(
          width: 200,
          height:200,
          color: currentColor,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
           showDialog(
              context: context,
              barrierDismissible: true,
              builder: (BuildContext context)
           {
             return Stack(children: [
               Align(
                 alignment: Alignment.bottomCenter,
                 child: ColorPicker(onChangedColor: _onChangedColor,),
               ),
             ]);
           });
        },
        child: const Icon(Icons.color_lens),
      ),
    );
  }

  void _onChangedColor(Color color) {
      setState(() {
        currentColor = color;
      });
  }
}
