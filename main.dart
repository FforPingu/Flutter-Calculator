import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';



void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Calculator',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({Key? key}) : super(key: key);

  @override
  CalculatorScreenState createState() => CalculatorScreenState();
}

class CalculatorScreenState extends State<CalculatorScreen> {
  String _input = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:const  Color.fromARGB(255, 43, 73, 119),
      body: Column(
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.all(16.0),
              child: Text(
                _input,
                style: const TextStyle(
                  fontSize: 50.0,
                  color: Color.fromARGB(255, 15, 15, 15)
                ),
              ),
            ),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            padding: const EdgeInsets.only(bottom: 30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildButton('7'),
                    _buildButton('8'),
                    _buildButton('9'),
                    _buildButton('/'),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildButton('4'),
                    _buildButton('5'),
                    _buildButton('6'),
                    _buildButton('*'),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildButton('1'),
                    _buildButton('2'),
                    _buildButton('3'),
                    _buildButton('-'),
                  ],
                ),
               const  SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildButton('C'),
                    _buildButton('0'),
                    _buildButton('='),
                    _buildButton('+'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton(String value) {
    return ElevatedButton(
      onPressed: () => _handleButtonPress(value),
      style: ElevatedButton.styleFrom(
        backgroundColor:const Color.fromARGB(255, 5, 22, 39),
        padding: const EdgeInsets.all(27),
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(20.0),
        ),
      ),
      child: Text(
        value,
        style: const TextStyle(
          fontSize: 20.0,
          color: Color.fromARGB(255, 69, 143, 207)
        ),
      ),
    );
  }

  void _handleButtonPress(String value) {
    setState(() {
      if (value == 'C') {
        _input = '';
      } else if (value == '=') {
        try {
          _input = _evaluateExpression(_input);
        } catch (e) {
          _input = 'Error';
        }
      } else {
        _input += value;
      }
    });
  }

  String _evaluateExpression(String expression) {
    Parser p = Parser();
    Expression exp = p.parse(expression);
    ContextModel cm = CalculatorContextModel();
    double eval = exp.evaluate(EvaluationType.REAL, cm);
    return eval.toString();
  }
}

class CalculatorContextModel extends ContextModel {
  Map<String, Expression> _variables = {};

  @override
  Map<String, Expression> get variables => _variables;

  @override
  set variables(Map<String, Expression> value) {
    _variables = value;
  }

  double evaluateVariable(Variable variable) {
    String variableName = variable.name;

    if (_variables.containsKey(variableName)) {
      return _variables[variableName]!.evaluate(EvaluationType.REAL, this);
    } else {
      throw Exception("Variabile non definita: $variableName");
    }
  }
}
