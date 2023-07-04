import 'package:flutter/material.dart';

import 'base_voice.dart';
import 'charphoto_page.dart';
import 'charphoto_temp2.dart'; // temp added for testing 小倉頡
// import 'charphoto_temp3.dart'; // temp added for testing 小倉頡
import 'quizchar.dart';

class KantuShizi extends BaseVoicePage {
  const KantuShizi({Key? key}) : super(key: key);

  @override
  _KantuShiziState createState() => _KantuShiziState();
}

class _KantuShiziState extends BaseVoicePageState {
  @override
  Widget build(BuildContext context) {
    // final dbService = Provider.of<DbService>(context, listen: false);
    // final soundService = Provider.of<FtSoundService>(context, listen: false);

    final screenHeight = MediaQuery.of(context).size.height;
    final fontSize = screenHeight * 0.03;

    return Scaffold(
      appBar: AppBar(
        title: const Text('看圖識字'),
      ),
      body: GridView.count(
        padding: const EdgeInsets.all(20.0),
        crossAxisCount: 2,
        mainAxisSpacing: 20.0,
        crossAxisSpacing: 20.0,
        children: [
          GestureDetector(
            onTap: () async {
              await speak("小倉頡");
              // await _ttsService.delaySpeak();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      const CharPhotoPage(characterType: '小倉頡'),
                ),
              );
            },
            child: Card(
              child: Center(
                child: Text(
                  "小倉頡",
                  style: TextStyle(fontSize: fontSize),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () async {
              await speak("倉頡2");
              // await _ttsService.delaySpeak();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      const CharPhotoPage2(characterType: '倉頡2'),
                ),
              );
            },
            child: Card(
              child: Center(
                child: Text(
                  "倉頡2",
                  style: TextStyle(fontSize: fontSize),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () async {
              await speak("動物");
              // await _ttsService.delaySpeak();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      const CharPhotoPage(characterType: '動物'),
                ),
              );
            },
            child: Card(
              child: Center(
                child: Text(
                  "動物",
                  style: TextStyle(fontSize: fontSize),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () async {
              await speak("食物");
              // await _ttsService.delaySpeak();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      const CharPhotoPage(characterType: '食物'),
                ),
              );
            },
            child: Card(
              child: Center(
                child: Text(
                  "食物",
                  style: TextStyle(fontSize: fontSize),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () async {
              await speak("人物");
              // await _ttsService.delaySpeak();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      const CharPhotoPage(characterType: '人物'),
                ),
              );
            },
            child: Card(
              child: Center(
                child: Text(
                  "人物",
                  style: TextStyle(fontSize: fontSize),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () async {
              await speak("試識看");
              // await _ttsService.delaySpeak();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const QuizcharPage(),
                ),
              );
            },
            child: Card(
              child: Center(
                child: Text(
                  "試識看",
                  style: TextStyle(fontSize: fontSize),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
