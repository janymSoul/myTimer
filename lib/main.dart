import 'package:flutter/material.dart';
import 'package:my_timer/settings.dart';
import 'package:my_timer/widgets.dart';
import 'package:percent_indicator/percent_indicator.dart';
import './timermodel.dart';
import './timer.dart';

void main() {
  runApp(const MyApp());
}

const defaultPadding = 5.0;
var timer = CountDownTimer();

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    timer.startWork();
    return MaterialApp(
      title: "My Work Timer",
      theme: ThemeData(primarySwatch: Colors.blueGrey),
      home: TimerHomePage(),
    );
  }
}

class TimerHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<PopupMenuItem<String>> menuItems = [];
    menuItems.add(PopupMenuItem(
      child: Text('Settings'),
      value: 'Settings',
    ));
    return Scaffold(
      appBar: AppBar(
        title: Text("Working Timer"),
        actions: [
          PopupMenuButton<String>(
            itemBuilder: (BuildContext context) {
              return menuItems.toList();
            },
            onSelected: (s) {
              if (s == 'Settings') {
                goToSettings(context);
              }
            },
          )
        ],
      ),
      body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        var availableWidth = constraints.maxWidth;
        return Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.all(defaultPadding),
                ),
                Expanded(
                    child: ProductivityButton(
                        colour: Color(0xff009688),
                        text: "Work",
                        onPressed: () => timer.startWork())),
                Padding(
                  padding: EdgeInsets.all(defaultPadding),
                ),
                Expanded(
                    child: ProductivityButton(
                        colour: Color(0xff607D8B),
                        text: "Short Break",
                        onPressed: () => timer.startBreak(true))),
                Padding(
                  padding: EdgeInsets.all(defaultPadding),
                ),
                Expanded(
                    child: ProductivityButton(
                        colour: Color(0xff455A64),
                        text: "Long Break",
                        onPressed: () => timer.startBreak(false))),
                Padding(
                  padding: EdgeInsets.all(defaultPadding),
                ),
              ],
            ),
            StreamBuilder(
                initialData: '00:00',
                stream: timer.stream(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  TimerModel timer = (snapshot.data == '00:00')
                      ? TimerModel(time: '00:00', percent: 1)
                      : snapshot.data;
                  return Expanded(
                    child: CircularPercentIndicator(
                      radius: availableWidth / 2,
                      lineWidth: 10.0,
                      percent: timer.percent,
                      center: Text(timer.time,
                          style: Theme.of(context).textTheme.headline4),
                      progressColor: Color(0xff009688),
                    ),
                  );
                }),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.all(defaultPadding),
                ),
                Expanded(
                    child: ProductivityButton(
                        colour: Color(0xff212121),
                        text: 'Stop',
                        onPressed: () => timer.stopTimer())),
                Padding(
                  padding: EdgeInsets.all(defaultPadding),
                ),
                Expanded(
                    child: ProductivityButton(
                        colour: Color(0xff009688),
                        text: 'Start',
                        onPressed: () => timer.startTimer())),
                Padding(
                  padding: EdgeInsets.all(5),
                ),
              ],
            )
          ],
        );
      }),
    );
  }

  void goToSettings(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => SettingsScreen()));
  }
}
