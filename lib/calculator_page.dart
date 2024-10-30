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

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
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
                      "$number1$operand$number2",
                      style: const TextStyle(
                          fontSize: 48, fontWeight: FontWeight.w500),
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

              Wrap(
                children: Btn.buttonValues
                    .map((value) => SizedBox(
                        width: (screenSize.width - 16) / 4,
                        height: (screenSize.width - 16) / 4,
                        child: buildButton(value)))
                    .toList(),
              ),
              // buttons
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

  void calculate() {
    if (number1.isEmpty || operand.isEmpty || number2.isEmpty) return;

    final double num1 = double.parse(number1);
    final double num2 = double.parse(number2);

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

    setState(() {
      number1 = (result.toString().split(".")[1].startsWith("0")
              ? result.toInt()
              : result)
          .toString();
      number2 = "";
      operand = "";
    });

    result = 0;
  }

  void onBtnTap(String value) {
    // Clear
    if (value == Btn.clear) {
      return clearAll();
    }

    // Calculate
    if (value == Btn.calculate) {
      return calculate();
    }

    if (operand.isEmpty) {
      if (value == Btn.dot && !number1.contains(Btn.dot)) {
        return setState(() {
          number1 += number1.isEmpty ? "0." : ".";
        });
      } else if (value == Btn.percent) {
        return setState(() {
          number1 += "%";
        });
      }

      if (int.tryParse(value) != null) {
        return setState(() {
          number1 += value;
        });
      } else {
        return setState(() {
          operand = value;
        });
      }
    } else {
      if (value == Btn.dot && !number2.contains(Btn.dot)) {
        return setState(() {
          number2 += number2.isEmpty ? "0." : ".";
        });
      } else if (value == Btn.percent) {
        return setState(() {
          number2 += "%";
        });
      }

      if (int.tryParse(value) != null) {
        return setState(() {
          number2 += value;
        });
      }
    }
  }
}
