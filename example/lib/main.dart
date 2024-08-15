import 'package:widget_flip/widget_flip.dart';
import 'package:flutter/material.dart';

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
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool directionChecked = false;
  bool loopChecked = false;
  final controller = FlipWidgetController();

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 50),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Horizontal'),
                Switch(
                    value: directionChecked,
                    onChanged: (_) => setState(() {
                          directionChecked = !directionChecked;
                        })),
                const Text('Vertical')
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Loop'),
                Switch(
                    value: loopChecked,
                    onChanged: (_) => setState(() {
                          loopChecked = !loopChecked;
                        }))
              ],
            ),
            const SizedBox(height: 50),
            Container(
              alignment: Alignment.center,
              width: 300,
              height: 250,
              child: GestureDetector(
                onTap: () => controller.flip(),
                child: FlipWidget(
                  controller: controller,
                  front: Container(
                    color: Colors.blue,
                    padding: const EdgeInsets.all(10),
                    child: Image.asset(
                      'assets/images/front.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                  back: Container(
                    color: Colors.red,
                    child: Center(
                        child: Container(
                            padding: const EdgeInsets.all(20),
                            color: Colors.white,
                            child: const Text('Hello'))),
                  ),
                  direction: directionChecked
                      ? FlipWidgetDirection.vertical
                      : FlipWidgetDirection.horizontal,
                  autoStart: true,
                  loop: loopChecked,
                  duration: const Duration(seconds: 2),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
