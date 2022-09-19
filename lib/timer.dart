import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import './timermodel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CountDownTimer {
  int longBreak = 20;
  int shortBreak = 5;
  double radius = 1;
  bool isActive = false;
  late Timer timer;

  late Duration fullTime;

  int work = 30;
  late Duration time = Duration(minutes: work);

  String returnTime(Duration t) {
    String minutes = (t.inMinutes < 1)
        ? '0' + t.inMinutes.toString()
        : t.inMinutes.toString();
    int numSeconds = t.inSeconds - (t.inMinutes * 60);
    String seconds =
        (numSeconds < 10) ? '0' + numSeconds.toString() : numSeconds.toString();
    String formattedTime = minutes + ":" + seconds;
    return formattedTime;
  }

  void startWork() async {
    readSettings();
    radius = 1;
    time = Duration(minutes: this.work, seconds: 0);
    fullTime = time;
  }

  void playSound() async {
    final player = AudioPlayer();
    player.play(AssetSource("sound.wav"));
  }

  Stream<TimerModel> stream() async* {
    yield* Stream.periodic(Duration(seconds: 1), (int a) {
      String timeo;
      if (this.isActive) {
        time = time - Duration(seconds: 1);
        radius = time.inSeconds / fullTime.inSeconds;
        if (time.inSeconds <= 0) {
          isActive = false;
          playSound();
        }
      }
      timeo = returnTime(time);
      return TimerModel(time: timeo, percent: radius);
    });
  }

  void stopTimer() {
    isActive = false;
  }

  void startTimer() {
    if (time.inSeconds > 0) {
      this.isActive = true;
    }
  }

  void startBreak(bool isShort) async {
    readSettings();
    radius = 1;
    time = Duration(minutes: (isShort) ? shortBreak : longBreak, seconds: 0);
    fullTime = time;
  }

  Future readSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    work = prefs.getInt("workTime") == null ? 30 : prefs.getInt("workTime")!;
    shortBreak =
        prefs.getInt("shortBreak") == null ? 5 : prefs.getInt("shortBreak")!;
    longBreak =
        prefs.getInt("longBreak") == null ? 20 : prefs.getInt("longBreak")!;
  }
}
