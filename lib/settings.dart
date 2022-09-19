import 'package:flutter/material.dart';
import 'package:my_timer/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

TextStyle textStyle = TextStyle(fontSize: 24);

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Settings"),
        ),
        body: Settings());
  }
}

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  late TextEditingController txtWork;
  late TextEditingController txtshort;
  late TextEditingController txtlong;
  static const String WORKTIME = "workTime";
  static const String SHORTBREAK = "shortBreak";
  static const String LONGBREAK = "longBreak";
  late int workTime;
  late int shortBreak;
  late int longBreak;
  late SharedPreferences prefs;
  @override
  void initState() {
    txtWork = TextEditingController();
    txtshort = TextEditingController();
    txtlong = TextEditingController();
    readSettings();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GridView.count(
        crossAxisCount: 3,
        childAspectRatio: 3,
        crossAxisSpacing: 10,
        padding: EdgeInsets.all(20.0),
        scrollDirection: Axis.vertical,
        children: [
          Text("Work", style: textStyle),
          Text(""),
          Text(""),
          SettingButton(
            color: Color(0xff455A64),
            text: "-",
            value: -1,
            callback: updateSettings,
            setting: WORKTIME,
          ),
          TextField(
              controller: txtWork,
              style: textStyle,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number),
          SettingButton(
            color: Color(0xff009688),
            text: "+",
            value: 1,
            callback: updateSettings,
            setting: WORKTIME,
          ),
          Text("Short", style: textStyle),
          Text(""),
          Text(""),
          SettingButton(
            setting: SHORTBREAK,
            callback: updateSettings,
            color: Color(0xff455A64),
            text: "-",
            value: -1,
          ),
          TextField(
              controller: txtshort,
              style: textStyle,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number),
          SettingButton(
            color: Color(0xff009688),
            text: "+",
            value: 1,
            callback: updateSettings,
            setting: SHORTBREAK,
          ),
          Text(
            "Long",
            style: textStyle,
          ),
          Text(""),
          Text(""),
          SettingButton(
            color: Color(0xff455A64),
            text: "-",
            value: -1,
            setting: LONGBREAK,
            callback: updateSettings,
          ),
          TextField(
              controller: txtlong,
              style: textStyle,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number),
          SettingButton(
            color: Color(0xff009688),
            text: "+",
            value: 1,
            setting: LONGBREAK,
            callback: updateSettings,
          ),
        ],
      ),
    );
  }

  readSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? workTime;
    workTime = prefs.getInt(WORKTIME);
    if (workTime == null) {
      await prefs.setInt(WORKTIME, int.parse('30'));
      workTime = prefs.getInt(WORKTIME);
    }
    int? shortBreak = prefs.getInt(SHORTBREAK);
    if (shortBreak == null) {
      await prefs.setInt(SHORTBREAK, int.parse('5'));
      shortBreak = prefs.getInt(SHORTBREAK);
    }
    int? longBreak = prefs.getInt(LONGBREAK);
    if (longBreak == null) {
      await prefs.setInt(LONGBREAK, int.parse('20'));
      longBreak = prefs.getInt(LONGBREAK);
    }
    setState(() {
      txtWork.text = workTime.toString();
      txtshort.text = shortBreak.toString();
      txtlong.text = longBreak.toString();
    });
  }

  void updateSettings(String key, int value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    switch (key) {
      case WORKTIME:
        {
          int workTime = prefs.getInt(WORKTIME)!;
          workTime += value;
          if (workTime >= 1 && workTime <= 180) {
            prefs.setInt(WORKTIME, workTime);
            setState(() {
              txtWork.text = workTime.toString();
            });
          }
        }
        return;
      case SHORTBREAK:
        {
          int short = prefs.getInt(SHORTBREAK)!;
          short += value;
          if (short >= 1 && short <= 120) {
            prefs.setInt(SHORTBREAK, short);
            setState(() {
              txtshort.text = short.toString();
            });
          }
        }
        return;
      case LONGBREAK:
        {
          int long = prefs.getInt(LONGBREAK)!;
          long += value;
          if (long >= 1 && long <= 180) {
            prefs.setInt(LONGBREAK, long);
            setState(() {
              txtlong.text = long.toString();
            });
          }
        }
        break;
    }
  }
}
