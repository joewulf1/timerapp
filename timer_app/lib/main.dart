import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rando Timer',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: const MyHomePage(title: 'Rando Timer'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counterSec = 0;
  int _counterMin = 0;
  late Timer _timerSeconds;
  late Timer _timerMinutes;
  bool _isButtonDisabled = true;

  _startTimerMin() {
    _counterMin = randNum() - 1;

    _timerMinutes = Timer.periodic(const Duration(minutes: 1), (timer) {
      setState(
        () {
          if (_counterMin > 0) {
            _counterMin--;
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => timerDead()),
            );
            _timerMinutes.cancel();
            _counterMin = 0;
          }
        },
      );
    });
  }

  _startTimerSec() {
    _counterSec = 59;

    _timerSeconds = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(
        () {
          if (_counterSec > 0) {
            _counterSec--;
          } else if (_counterMin > 0) {
            _counterSec = 59;
          } else {
            _timerSeconds.cancel();
            _counterSec = 0;
          }
        },
      );
    });
  }

  @override
  void initState() {
    _isButtonDisabled = false;
  }

  void disableButton() {
    setState(() {
      _isButtonDisabled = true;
    });
  }

  void enableButton() {
    setState(() {
      _isButtonDisabled = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color.fromARGB(255, 255, 255, 255),
                border: Border.all(color: Colors.black)),
            child: FloatingActionButton.large(
              heroTag: "startTimer",
              onPressed: () {
                if (_isButtonDisabled) {
                  null;
                } else {
                  _startTimerSec();
                  _startTimerMin();
                  _counterMin = randNum();
                  disableButton();
                }
              },
              child: _isButtonDisabled
                  ? const Icon(Icons.block)
                  : const Icon(Icons.timer),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "$_counterMin",
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                const Text(
                  ":",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  "$_counterSec",
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _timerMinutes.cancel();
          _timerSeconds.cancel();
          enableButton();
        },
        heroTag: "timerReset",
        tooltip: 'Reset',
        child: const Icon(Icons.refresh),
      ),
    );
  }
}

randNum() {
  Random random = new Random();
  int rand = random.nextInt(20) + 4;
  return rand;
}

class timerDead extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        content: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text("Timer Done!"),
        FloatingActionButton(
            heroTag: "closePopup",
            child: const Icon(Icons.refresh),
            onPressed: () {
              Navigator.pop(context);
            })
      ],
    ));
  }
}
