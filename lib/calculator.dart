import 'package:flutter/material.dart';

class Calculator extends StatefulWidget{
  const Calculator({super.key});

  @override
  State<Calculator> createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator>{ 
  String displayText = '';
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

  String evaluate(String expression) {
    List<String> operands = expression.split(RegExp(r'[+\-*/]'));
    List<bool> isTime = operands.map((operand) => operand.contains(':')).toList();
    List<String> operators = RegExp(r'[+\-*/]')
      .allMatches(expression)
      .map((match) => match.group(0)!)
      .toList();
    // Convert time to seconds
    for (int i = 0; i < operands.length; i++){
      bool currIsTime = operands[i].contains(':');
      List<String> vals = operands[i].split(RegExp(r'[:.]'));
      if (vals.length > 3){
        throw Exception('Too long');
      }
      if (currIsTime){
        if (vals.length == 2){
          operands[i] = (int.parse(vals[0]) * 60 + int.parse(vals[1])).toString();
        } else if (vals.length == 3){
          operands[i] = (int.parse(vals[0]) * 3600 + int.parse(vals[1]) * 60 + int.parse(vals[2])).toString();
        }
      }
    }
    double result = double.parse(operands[0]);
    for (int i = 0; i < operators.length; i++){
      isTime[i+1] = isTime[i] && !isTime[i+1];
      switch (operators[i]){
        case '+':
          if (isTime[i]!=isTime[i+1]) throw Exception('Cannot add time and distance');
          result += double.parse(operands[i + 1]);
          break;
        case '-':
          if (isTime[i]!=isTime[i+1]) throw Exception('Cannot subtract time and distance');
          result -= double.parse(operands[i + 1]);
          break;
        case '*':
          result *= double.parse(operands[i + 1]);
          break;
        case '/':
          result /= double.parse(operands[i + 1]);
          break;
      }
    }
    if (isTime.last){
      int seconds = result.floor();
      int minutes = (seconds / 60).floor();
      int hours = (minutes / 60).floor();
      seconds -= minutes * 60;
      minutes -= hours * 60;
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
    return result.toString();
  }

  void buttonPressed(String buttonText) {
    setState(() {
      if (buttonText == 'Help'){
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Help'),
            content: const Text('''xx:xx  xx:xx  xx.xx 
                                    time = pace * distance
                                    xx.xx      xx:xx  xx:xx
                                    distance = time / pace
                                    xx:xx  xx:xx  xx.xx
                                    pace = time / distance
                                    xx.xx   xx.xx      xx:xx
                                    speed = distance / time'''),
            actions: <Widget>[
              TextButton(
                child: Text('Okay'),
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
              ),
            ],
          ),
        );
      }
      if (buttonText == 'C') {
        displayText = '';
      } else if (buttonText == '=') {
        // Perform calculation
        try{
          displayText = evaluate(displayText);
        } catch (e) {
          displayText = 'Error';
        }
      }
      else if (buttonText == "<-"){
        if (displayText.isNotEmpty){
          displayText = displayText.substring(0, displayText.length - 1);
        }
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
                  buildButton("Help"),
                  buildButton("C"),
                  buildButton('<-'),
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