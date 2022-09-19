import 'package:flutter/material.dart';

typedef CallbackSetting = void Function(String, int);

class ProductivityButton extends StatelessWidget {
  final Color colour;
  final String text;
  final double size;
  final VoidCallback onPressed;
  ProductivityButton(
      {required this.colour,
      this.size = 5,
      required this.text,
      required this.onPressed});
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: this.onPressed,
      color: this.colour,
      minWidth: this.size,
      child: Text(
        this.text,
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }
}

class SettingButton extends StatelessWidget {
  final Color color;
  final String text;
  final int value;
  final String setting;
  final CallbackSetting callback;

  SettingButton({
    required this.color,
    required this.text,
    required this.value,
    required this.setting,
    required this.callback,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: () => this.callback(this.setting, this.value),
      child: Text(
        this.text != null ? this.text : '',
        style: TextStyle(color: Colors.white),
      ),
      color: this.color,
    );
  }
}
