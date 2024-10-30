import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:calculator/button_values.dart';

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  String number1 = "";
  String operand = "";
  String number2 = "";
  final int maxDigitsAfterDot = 10;
  final int maxDigitsNumber = 15;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    String expression = number1 +
        (("$number1$operand$number2").length <= maxDigitsNumber ? "" : "\n") +
        operand +
        number2;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Column(
            children: [
              // Output
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    alignment: Alignment.topRight,
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      expression,
                      style: TextStyle(
                          fontSize: expression.length <= maxDigitsNumber - 3
                              ? 48
                              : 32,
                          fontWeight: FontWeight.w500),
                      textAlign: TextAlign.end,
                    ),
                  ),
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Material(
                    child: InkWell(
                      onTap: deleteTap,
                      borderRadius: BorderRadius.circular(100),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: const Icon(Icons.backspace),
                      ),
                    ),
                  )
                ],
              ),

              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                child: Divider(
                  color: const Color.fromRGBO(46, 88, 255, 1),
                ),
              ),

              // buttons
              Wrap(
                children: Btn.buttonValues
                    .map((value) => SizedBox(
                        width: (screenSize.width - 16) / 4,
                        height: (screenSize.width - 16) / 4,
                        child: buildButton(value)))
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildButton(value) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Material(
        color: [Btn.calculate].contains(value)
            ? Color.fromARGB(255, 17, 226, 249)
            : Color.fromARGB(255, 63, 119, 184),
        clipBehavior: Clip.hardEdge,
        borderRadius: BorderRadius.circular(100),
        child: InkWell(
          onTap: () => onBtnTap(value),
          child: Center(
            child: Text(
              value,
              style: TextStyle(
                  fontSize: 24,
                  color: [Btn.clear].contains(value)
                      ? Color.fromARGB(255, 255, 106, 83)
                      : [Btn.calculate].contains(value)
                          ? Color.fromARGB(255, 0, 0, 0)
                          : Color.fromARGB(255, 9, 214, 255),
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }

  void deleteTap() {
    if (number2.isNotEmpty) {
      setState(() {
        number2 = number2.substring(0, number2.length - 1);
      });
    } else if (operand.isNotEmpty) {
      setState(() {
        operand = "";
      });
    } else if (number1.isNotEmpty) {
      setState(() {
        number1 = number1.substring(0, number1.length - 1);
      });
    }
  }

  void clearAll() {
    setState(() {
      number1 = "";
      operand = "";
      number2 = "";
    });
  }

  double convertFormatNumToDouble(String num) {
    if (num.contains(Btn.subtract)) {
      return -double.parse(num.substring(1));
    } else if (num.contains(Btn.percent)) {
      return double.parse(num.substring(0, num.length - 1)) / 100;
    } else {
      return double.parse(num);
    }
  }

  void calculate() {
    if (number1.isEmpty || operand.isEmpty || number2.isEmpty) return;

    final double num1 = convertFormatNumToDouble(number1);
    final double num2 = convertFormatNumToDouble(number2);

    var result = 0.0;
    switch (operand) {
      case Btn.add:
        result = num1 + num2;
        break;
      case Btn.subtract:
        result = num1 - num2;
        break;
      case Btn.multiply:
        result = num1 * num2;
        break;
      case Btn.divide:
        result = num1 / num2;
        break;
    }

    List<String> afterDotArr = result.toString().split(Btn.dot);

    setState(() {
      if (int.parse(afterDotArr[1]) == int.parse(Btn.num0)) {
        number1 = afterDotArr[0];
      } else if (afterDotArr[1].length > maxDigitsAfterDot) {
        number1 = result.toStringAsFixed(10);
      } else {
        number1 = result.toString();
      }

      number2 = "";
      operand = "";
    });

    result = 0;
  }

  String getNumValue(String num, String valueTap) {
    if (valueTap == Btn.dot && !num.contains(Btn.dot)) {
      return num += num.isEmpty ? Btn.num0 + Btn.dot : Btn.dot;
    } else if (valueTap == Btn.percent && !num.contains(Btn.percent)) {
      return num += Btn.percent;
    } else if (valueTap == Btn.convert && num.isNotEmpty) {
      return num.contains(Btn.subtract)
          ? num.replaceAll(Btn.subtract, "")
          : Btn.subtract + num;
    } else if (int.tryParse(valueTap) != null) {
      return num.length < maxDigitsNumber ? num += valueTap : num;
    } else {
      return num;
    }
  }

  bool isValidOperand(String valueTap) {
    return int.tryParse(valueTap) == null &&
        ![Btn.percent, Btn.calculate, Btn.convert, Btn.dot]
            .contains(valueTap) &&
        number1.isNotEmpty;
  }

  void onBtnTap(String valueTap) {
    if (valueTap == Btn.clear) return clearAll();
    if (valueTap == Btn.calculate) return calculate();

    if (isValidOperand(valueTap)) {
      return setState(() {
        operand = valueTap;
      });
    }

    if (operand.isEmpty) {
      return setState(() {
        number1 = getNumValue(number1, valueTap);
      });
    } else {
      return setState(() {
        number2 = getNumValue(number2, valueTap);
      });
    }
  }
}
