import 'dart:math';

import 'package:flutter/material.dart';
// import 'package:flutter_tts/flutter_tts.dart';

class PinZi1Page extends StatefulWidget {
  const PinZi1Page({Key? key}) : super(key: key);

  @override
  _PinZi1PageState createState() => _PinZi1PageState();
}

class _PinZi1PageState extends State<PinZi1Page> {
  late String character;
  late String shapeComponent;
  late String soundComponent;
  late String structure;
  late List<String> phrases;

  late List<String> shapeComponentOptions;
  late List<String> soundComponentOptions;

  late String selectedShapeComponent;
  late String selectedSoundComponent;
  late bool isCorrect;

  // final FlutterTts flutterTts = FlutterTts();

  late double screenHeight;
  late double screenWidth;
  late double fontSize;
  late double fontSize2;
  late double fontSize3;
  late double spaceHeight;
  late double containerSize;
  late double vRectangleW;
  late double vRectangleL;
  late double hRectangleW;
  late double hRectangleTtL;
  late double hRectangleTbL;
  late double hRectangleBtL;
  late double hRectangleBbL;
  Color shapeColor = Colors.lightBlue;
  Color soundColor = Colors.lightGreen;

  @override
  void initState() {
    super.initState();
    //
    character = '明';
    shapeComponent = '日';
    soundComponent = '月';
    structure = '左';
    phrases = ['明天', '明亮'];
    shapeComponentOptions = ['日', '力', '亻', '彳'];
    soundComponentOptions = ['月', '合', '隹', '召'];
    //
    /*
    character = '草';
    shapeComponent = '艹';
    soundComponent = '早';
    structure = '上';
    phrases = ['小草', '草地'];
    shapeComponentOptions = ['艹', '亠', '宀', '穴'];
    soundComponentOptions = ['早', '雨', '厶', '川'];
    */

    selectedShapeComponent = '';
    selectedSoundComponent = '';
    isCorrect = false;
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    fontSize = screenHeight * 0.03;
    fontSize2 = fontSize * 2;
    fontSize3 = fontSize * 3;
    spaceHeight = fontSize * 0.30;
    containerSize = fontSize2 * 3.2;
    vRectangleW = fontSize2 * 1.25;
    vRectangleL = fontSize2 * 2.0;
    hRectangleW = fontSize2 * 1.25;
    hRectangleTtL = fontSize2 * 0.75;
    hRectangleTbL = fontSize2 * 1.5;
    hRectangleBtL = fontSize2 * 1.5;
    hRectangleBbL = fontSize2 * 0.75;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chinese Character Learning'),
      ),
      body: Column(
        children: [
          // Structure in top right corner
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: EdgeInsets.all(spaceHeight),
              child: Text(
                structure,
                style: TextStyle(fontSize: fontSize),
              ),
            ),
          ),

          // Display character
          Flexible(
              flex: 4, // takes up 1/3 of the total available space
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    character,
                    style: TextStyle(fontSize: fontSize3),
                  ),
                ],
              )),

          // Component selection containers
          Flexible(
            flex: 4, // takes up 1/3 of the total available space
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildComponentContainer('形', shapeComponentOptions, fontSize2),
                SizedBox(width: spaceHeight),
                _buildComponentContainer('聲', soundComponentOptions, fontSize2),
              ],
            ),
          ),

          // Frames for components
          Flexible(
            flex: 3, // takes up 1/4 of the total available space
            child: Column(
              children: _buildFrames(structure, fontSize2),
            ),
          ),

          SizedBox(height: spaceHeight), // Add space

          // Check or More bar
          Flexible(
            flex: 1, // takes up 1/12 of the total available space
            child: isCorrect ? _buildMoreBar() : _buildCheckBar(),
          ),

          SizedBox(height: spaceHeight * 2), // Add space
        ],
      ),
    );
  }

  Widget _buildComponentContainer(
      String label, List<String> options, double fontSize) {
    Color color = shapeColor;

    if (label == '聲') {
      color = soundColor;
    }

    return Container(
      width: containerSize,
      height: containerSize,
      color: color,
      margin: EdgeInsets.all(spaceHeight),
      child: GridView.builder(
        padding: EdgeInsets.all(spaceHeight),
        itemCount: options.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onDoubleTap: () {
              _moveComponent(options[index], label);
            },
            child: Center(
              child: Text(
                options[index],
                style: TextStyle(fontSize: fontSize2),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCheckBar() {
    return Container(
      width: double.infinity, // Make the bar as wide as the screen
      child: ElevatedButton(
        child: const Text('Check'),
        onPressed: () {
          setState(() {
            isCorrect = selectedShapeComponent == shapeComponent &&
                selectedSoundComponent == soundComponent;
          });
          if (isCorrect) _showPhrases();
        },
      ),
    );
  }

  Widget _buildMoreBar() {
    return Container(
      width: double.infinity, // Make the bar as wide as the screen
      child: ElevatedButton(
        child: const Text('More'),
        onPressed: () {
          // Implement more logic.
          // This would involve showing and pronouncing phrases associated with the character.
        },
      ),
    );
  }
  /* This widget 
  Widget _buildContainer(String label, Color color, double fontSize) {
    return Container(
      width: fontSize * 10,
      color: color,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(label,
              style: TextStyle(color: Colors.white, fontSize: fontSize)),
        ],
      ),
    );
  }
  */

  Widget _createRectangle(double width, double height, Color color) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(color: color),
    );
  }

  List<Widget> _buildFrames(String structure, double fontSize) {
    double maxRectangleH =
        max(hRectangleTtL + hRectangleTbL, hRectangleBtL + hRectangleBbL) +
            spaceHeight;

    return [
      Expanded(
        child: Container(
          height: maxRectangleH,
          // margin: EdgeInsets.all(spaceHeight),
          margin: const EdgeInsets.all(0),
          child: Center(
            child: (structure == '左' || structure == '右')
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: _buildComponentsAndFrames(structure, fontSize2),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: _buildComponentsAndFrames(structure, fontSize2),
                  ),
          ),
        ),
      ),
    ];
  }

  List<Widget> _buildComponentsAndFrames(String structure, double fontSize) {
    Widget shapeFrame, soundFrame;

    switch (structure) {
      case '左':
        shapeFrame = _createRectangle(vRectangleW, vRectangleL, shapeColor);
        soundFrame = _createRectangle(vRectangleW, vRectangleL, soundColor);
        break;
      case '右':
        shapeFrame = _createRectangle(vRectangleW, vRectangleL, soundColor);
        soundFrame = _createRectangle(vRectangleW, vRectangleL, shapeColor);
        break;
      case '上':
        shapeFrame = _createRectangle(hRectangleW, hRectangleTtL, shapeColor);
        soundFrame = _createRectangle(hRectangleW, hRectangleTbL, soundColor);
        break;
      case '下':
        shapeFrame = _createRectangle(hRectangleW, hRectangleBtL, soundColor);
        soundFrame = _createRectangle(hRectangleW, hRectangleBbL, shapeColor);
        break;
      default:
        shapeFrame = _createRectangle(vRectangleW, vRectangleL, shapeColor);
        soundFrame = _createRectangle(vRectangleW, vRectangleL, soundColor);
        break;
    }

    return [
      Stack(
        alignment: Alignment.center,
        children: [
          shapeFrame,
          Text(
            selectedShapeComponent,
            style: TextStyle(fontSize: fontSize),
          ),
        ],
      ),
      /*
      SizedBox(
        width: spaceHeight / 4,
        height: spaceHeight / 4,
      ),
      */
      Stack(
        alignment: Alignment.center,
        children: [
          soundFrame,
          Text(
            selectedSoundComponent,
            style: TextStyle(fontSize: fontSize),
          ),
        ],
      ),
    ];
  }

  void _moveComponent(String component, String type) {
    setState(() {
      if (type == '形') {
        if (structure == '左' || structure == '上') {
          selectedShapeComponent = component;
        } else if (structure == '右' || structure == '下') {
          selectedSoundComponent = component;
        }
        shapeComponentOptions.remove(component);
      } else if (type == '聲') {
        if (structure == '左' || structure == '上') {
          selectedSoundComponent = component;
        } else if (structure == '右' || structure == '下') {
          selectedShapeComponent = component;
        }
        soundComponentOptions.remove(component);
      }
    });
  }

  void _pronounceWord(String word) async {
    // await flutterTts.setLanguage("zh-CN");
    // await flutterTts.speak(word);
    print('pronounce $word');
  }

  void _showPhrases() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ListView.builder(
          itemCount: phrases.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Text(phrases[index]),
              onTap: () {
                Navigator.pop(context);
                _pronounceWord(phrases[index]);
              },
            );
          },
        );
      },
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: PinZi1Page(),
  ));
}
