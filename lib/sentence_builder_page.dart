import 'package:flutter/material.dart';

class SentenceBuilderPage extends StatefulWidget {
  final List<String> sentence;

  SentenceBuilderPage({Key? key, required this.sentence}) : super(key: key);

  @override
  _SentenceBuilderPageState createState() => _SentenceBuilderPageState();
}

class _SentenceBuilderPageState extends State<SentenceBuilderPage> {
  late List<String> sentenceInProgress;
  late List<String> shuffledWords;
  int wordCount = 0;

  @override
  void initState() {
    super.initState();
    wordCount = widget.sentence.length;
    sentenceInProgress = List<String>.filled(wordCount, '', growable: false);
    shuffledWords = widget.sentence.toList()..shuffle();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double paddingSize = MediaQuery.of(context).padding.top * 2.0;
    double maxWordCount = 12;
    double gridSize = (screenWidth - paddingSize) / maxWordCount;
    double fontSize = gridSize / 1.75;

    return Scaffold(
      appBar: AppBar(
        title: Text('Sentence Builder'),
        actions: [
          IconButton(
            icon: Icon(Icons.mic),
            onPressed: () {
              print(
                  'hello world'); // Call your function to pronounce the whole sentence here.
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(top: paddingSize + 20), // Padding added here
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  flex: 1,
                  child: GridView.builder(
                    itemCount: wordCount,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount:
                          (wordCount > maxWordCount ? maxWordCount : wordCount)
                              .toInt(),
                    ),
                    itemBuilder: (context, index) {
                      return DragTarget<String>(
                        builder: (context, candidateData, rejectedData) {
                          return Container(
                            width: gridSize,
                            height: gridSize,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.blueAccent),
                              color: sentenceInProgress[index] == ''
                                  ? Colors.blue.shade200
                                  : Colors.blue.shade200,
                            ),
                            child: Center(
                              child: Text(
                                sentenceInProgress[index],
                                style: TextStyle(fontSize: fontSize),
                              ),
                            ),
                          );
                        },
                        onWillAccept: (data) => sentenceInProgress[index] == '',
                        onAccept: (data) {
                          setState(() {
                            if (data == widget.sentence[index]) {
                              sentenceInProgress[index] = data;
                              shuffledWords.remove(data);
                            } else {
                              // Insert the code that should be executed when the word is incorrect.
                              // For instance, play a sound and return the word to the word pool.
                            }
                          });
                        },
                      );
                    },
                  ),
                ),
                const Divider(color: Colors.black, thickness: 4),
                Flexible(
                  flex: 1,
                  child: GridView.builder(
                    itemCount: shuffledWords.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount:
                          (wordCount > maxWordCount ? maxWordCount : wordCount)
                              .toInt(),
                    ),
                    itemBuilder: (context, index) {
                      return Draggable<String>(
                        data: shuffledWords[index],
                        feedback: Material(
                          color: Colors.transparent,
                          child: SizedBox(
                            width: gridSize,
                            height: gridSize,
                            child: Center(
                              child: Text(
                                shuffledWords[index],
                                style: TextStyle(fontSize: fontSize),
                              ),
                            ),
                          ),
                        ),
                        childWhenDragging: Container(
                          width: gridSize,
                          height: gridSize,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.greenAccent),
                          ),
                        ),
                        child: Container(
                          width: gridSize,
                          height: gridSize,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.greenAccent),
                            color: Colors.green.shade200,
                          ),
                          child: Center(
                            child: Text(
                              shuffledWords[index],
                              style: TextStyle(fontSize: fontSize),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
