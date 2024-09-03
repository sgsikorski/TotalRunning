import 'package:flutter/material.dart';
import 'package:petitparser/petitparser.dart';

class Calculator extends StatefulWidget{
  const Calculator({super.key});

  @override
  State<Calculator> createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator>{
  Parser buildCalcParser(){
    final builder = ExpressionBuilder();
    builder.primitive((pattern('+-').optional() &
        digit().plus() &
        (char('.') & digit().plus()).optional() &
        (char(':') & digit().plus()) &
        (pattern('eE') & pattern('+-').optional() & digit().plus()).optional())
        .flatten('number expected'));
    builder.group().wrapper(char('(').trim(), char(')').trim(), (left, value, right) => value);
    builder.group().prefix(char('-').trim(), (operator, value) => -value);
    builder.group()
      ..left(char('*').trim(), (left, operator, right) => left * right)
      ..left(char('/').trim(), (left, operator, right) => left / right);
    builder.group()
      ..left(char('+').trim(), (left, operator, right) => left + right)
      ..left(char('-').trim(), (left, operator, right) => left - right);
    return builder.build().end();
  }
  
  String displayText = '';
  String mode = 'time';
  Widget buildButton(String buttonText) {
    return Expanded(
      child: OutlinedButton(
        onPressed: () => buttonPressed(buttonText),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Text(
            buttonText,
            style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  // xx:xx  xx:xx  xx.xx
  // time = pace × distance
  // xx.xx      xx:xx  xx:xx
  // distance = time / pace
  // xx:xx  xx:xx  xx.xx
  // pace = time / distance
  // xx.xx   xx.xx      xx:xx
  // speed = distance / time

  double evaluate(String expression) {
    // Implement your own evaluation logic
    return 42.0; // Placeholder result
  }

  void buttonPressed(String buttonText) {
    setState(() {
      if (buttonText == 'C') {
        displayText = '';
      } else if (buttonText == '=') {
        // Perform calculation
        try{
          displayText = evaluate(displayText).toString();
        } catch (e) {
          displayText = 'Error';
        }
      }
      else if (buttonText == "<-"){
        if (displayText.isNotEmpty){
          displayText = displayText.substring(0, displayText.length - 1);
        }
      } else if (buttonText == ':' || buttonText == '.'){
        mode = 'time';
      }
      else {
        if (displayText == '0') {
          displayText = buttonText;
        } else {
          displayText += buttonText;
        }
      }
    });
  }

  @override 
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculator'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              alignment: Alignment.bottomRight,
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 12),
              child: Text(
                displayText,
                style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const Divider(),
          Column(
            children: [
              Row(children: <Widget>[
                  buildButton('C'),
                  buildButton("<-"),
                  buildButton(':/.'),
                  buildButton('/')
                ]
              ),
              Row(
                children: <Widget>[
                  buildButton('7'),
                  buildButton('8'),
                  buildButton('9'),
                  buildButton('*')
                ],
              ),
              Row(
                children: <Widget>[
                  buildButton('4'),
                  buildButton('5'),
                  buildButton('6'),
                  buildButton('-')
                ],
              ),
              Row(
                children: <Widget>[
                  buildButton('1'),
                  buildButton('2'),
                  buildButton('3'),
                  buildButton('+')
                ],
              ),
              Row(children: <Widget>[
                buildButton('0'),
                buildButton(':'),
                buildButton('.'),
                buildButton('='),
              ],)
            ],
          )
        ],
      )
    );
  }
}