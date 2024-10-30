import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';

class Btn {
  static final Widget del = SvgPicture.asset("assets/icons/del.svg");
  static const String clear = "C";
  static const String percent = "%";
  static const String add = "+";
  static const String subtract = "−";
  static const String multiply = "×";
  static const String divide = "÷";
  static const String calculate = "=";
  static const String dot = ".";
  static const String roundBrackets = "( )";
  static const String convert = "+/-";

  static const String num0 = "0";
  static const String num1 = "1";
  static const String num2 = "2";
  static const String num3 = "3";
  static const String num4 = "4";
  static const String num5 = "5";
  static const String num6 = "6";
  static const String num7 = "7";
  static const String num8 = "8";
  static const String num9 = "9";

  static const List<String> buttonValues = [
    clear,
    roundBrackets,
    percent,
    divide,
    num7,
    num8,
    num9,
    multiply,
    num4,
    num5,
    num6,
    subtract,
    num1,
    num2,
    num3,
    add,
    convert,
    num0,
    dot,
    calculate
  ];
}
