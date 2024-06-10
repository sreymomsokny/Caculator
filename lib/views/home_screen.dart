import 'package:flutter/material.dart';
import 'package:calculator/model/value_calculator.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String num1 = ""; // from . and 0-9
  String oparand = ""; // form + - * /
  String num2 = ""; // from . and 0-9
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: SafeArea(
        child: Column(children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: SingleChildScrollView(
                reverse: true,
                child: Container(
                  alignment: Alignment.bottomRight,
                  //color: Colors.grey[400],
                  child: Text(
                    "$num1$oparand$num2".isEmpty
                        ? "0"
                        : "$num1$oparand$num2", // output values
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.end,
                  ),
                ),
              ),
            ),
          ),
          Wrap(
            children: Btn.buttonValues
                .map(
                  (value) => SizedBox(
                    width: value == Btn.n0
                        ? screenSize.width / 2 // extend size button
                        : (screenSize.width / 4),
                    height: screenSize.width / 5,
                    child: buildButton(value),
                  ),
                )
                .toList(),
          ),
        ]),
      ),
    );
  }

  //Button
  Widget buildButton(value) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Material(
        // Button Color
        color: getBtnColor(value),
        clipBehavior: Clip.hardEdge,
        shape: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.circular(100),
        ),
        child: InkWell(
          // Input Values
          onTap: () => onBtnTap(value),
          child: Center(
            child: Text(
              value,
              style: const TextStyle(
                //color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // funtion for onTap button

  void onBtnTap(String value) {
    if (value == Btn.del) {
      delete();
      return;
    } else if (value == Btn.clr) {
      clearALL();
      return;
    } else if (value == Btn.per) {
      convertPercentage();
      return;
    }else if(value == Btn.calculate){
      calculate();
      return;
    }
    appendValue(value);
  }

  // function calculate
  void calculate() {
    if (num1.isEmpty) return;
    if (oparand.isEmpty) return;
    if (num2.isEmpty) return;

    final double number1 = double.parse(num1);
    final double number2 = double.parse(num2);

    var result = 0.0;

    switch (oparand) {
      case Btn.add:
        result = number1 + number2;
        break;
      case Btn.subtract:
        result = number1 - number2;
        break;
      case Btn.multiply:
        result = number1 * number2;
        break;
      case Btn.divide:
        result = number1 / number2;
        break;
    }

    setState(() {
      num1 = result.toStringAsPrecision(3);
      if (num1.endsWith(".0")) {
        num1 = num1.substring(0, num1.length - 2);
      }
      oparand = "";
      num2 = "";
    });
  }

  // function percent
  void convertPercentage() {
    if (num1.isNotEmpty && oparand.isNotEmpty && num2.isNotEmpty) {
      calculate();
    }
    if (oparand.isNotEmpty) {
      return;
    }
    final num = double.parse(num1);
    setState(() {
      num1 = "${(num / 100)}";
      oparand = "";
      num2 = "";
    });
  }

  // function clear
  void clearALL() {
    setState(() {
      num1 = "";
      oparand = "";
      num2 = "";
    });
  }

  // function Delete
  void delete() {
    if (num2.isNotEmpty) {
      num2 = num2.substring(0, num2.length - 1); // lop pi lek krouy m'dg muy
    } else if (oparand.isNotEmpty) {
      oparand = "";
    } else if (num1.isNotEmpty) {
      num1 = num1.substring(0, num1.length - 1);
    }
    setState(() {});
  }

  // function add value to calculate

  void appendValue(String value) {
    if (value != Btn.dot && int.tryParse(value) == null) {
      if (oparand.isNotEmpty && num2.isNotEmpty) {
        calculate();
      }
      oparand = value;
    } else if (num1.isEmpty || oparand.isEmpty) {
      if (value == Btn.dot && num1.contains(Btn.dot)) return;
      if (value == Btn.dot && (num1.isEmpty || num1 == Btn.dot)) {
        value = "0.";
      }
      num1 += value;
    } else if (num2.isEmpty || oparand.isNotEmpty) {
      if (value == Btn.dot && num2.contains(Btn.dot)) return;
      if (value == Btn.dot && (num2.isEmpty || num2 == Btn.n0)) {
        value = "0.";
      }
      num2 += value;
    }

    setState(() {});
  }

  // method button color
  Color? getBtnColor(value) {
    return [Btn.del, Btn.clr].contains(value)
        ? Colors.grey[500]
        : [
            Btn.multiply,
            Btn.calculate,
            Btn.add,
            Btn.divide,
            Btn.subtract,
            Btn.per,
          ].contains(value)
            ? Colors.orange
            : Colors.black87;
  }
}
