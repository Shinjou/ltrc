// MainMenuPage

import 'package:flutter/material.dart';
import 'base_voice.dart';
// import 'kantushizi.dart'; commented out for testing 小倉頡
import 'kantushizi.dart'; // added for testing 小倉頡
// import 'paitushizi.dart'; // added for testing 拍圖識字
import 'main_pinzi1.dart'; // added for testing 拼字1
import 'main_pinzi2.dart'; // added for testing 拼字2
import 'zaoju_page.dart'; // added for testing 造句

class MainMenuPage extends BaseVoicePage {
  const MainMenuPage({Key? key}) : super(key: key);

  @override
  _MainMenuPageState createState() => _MainMenuPageState();
}

class _MainMenuPageState extends BaseVoicePageState {
  @override
  Widget build(BuildContext context) {
    // final dbService = Provider.of<DbService>(context, listen: false);
    // final soundService = Provider.of<FtSoundService>(context, listen: false);

    final screenHeight = MediaQuery.of(context).size.height;
    final fontSize = screenHeight * 0.03;

    return Scaffold(
      appBar: AppBar(
        title: const Text('主選單'),
      ),
      body: GridView.count(
        padding: const EdgeInsets.all(20.0),
        crossAxisCount: 2, // two tiles in the horizontal direction
        mainAxisSpacing: 20.0,
        crossAxisSpacing: 20.0,
        children: [
          GestureDetector(
            onTap: () async {
              await speak("看圖識字");
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const KantuShizi(),
                ),
              );
            },
            child: Card(
              child: Center(
                child: Text(
                  "看圖識字",
                  style: TextStyle(fontSize: fontSize),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () async {
              await speak("字卡識字");
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ZiKaShiZhi(),
                ),
              );
            },
            child: Card(
              child: Center(
                child: Text(
                  "字卡識字",
                  style: TextStyle(fontSize: fontSize),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () async {
              await speak("部件識字");
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const BuJianShiZi(),
                ),
              );
            },
            child: Card(
              child: Center(
                child: Text(
                  "部件識字",
                  style: TextStyle(fontSize: fontSize),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () async {
              await speak("閱讀");
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const YueDuShiZhi(),
                ),
              );
            },
            child: Card(
              child: Center(
                child: Text(
                  "閱讀",
                  style: TextStyle(fontSize: fontSize),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () async {
              await speak("拼字1");
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PinZi1Page(),
                ),
              );
            },
            child: Card(
              child: Center(
                child: Text(
                  "拼字1",
                  style: TextStyle(fontSize: fontSize),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () async {
              await speak("拼字2");
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PinZi2Page(),
                ),
              );
            },
            child: Card(
              child: Center(
                child: Text(
                  "拼字2",
                  style: TextStyle(fontSize: fontSize),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () async {
              await speak("造句");
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ZaoJu(), // zaoju_page.dart
                ),
              );
            },
            child: Card(
              child: Center(
                child: Text(
                  "造句",
                  style: TextStyle(fontSize: fontSize),
                ),
              ),
            ),
          ),
          /*
          GestureDetector(
            onTap: () async {
              await speak("拍圖識字");
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PaiTuShiZi(),
                ),
              );
            },
            child: Card(
              child: Center(
                child: Text(
                  "拍圖識字",
                  style: TextStyle(fontSize: fontSize),
                ),
              ),
            ),
          ),
          */
        ],
      ),
    );
  }
}

class ZiKaShiZhi extends StatelessWidget {
  const ZiKaShiZhi({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('字卡'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        color: Colors.black,
        child: const Center(
          child: Text(
            'This is the 字卡識字 page',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}

class BuJianShiZi extends StatelessWidget {
  const BuJianShiZi({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('部件識字'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        color: Colors.black,
        child: const Center(
          child: Text(
            'This is the 部件識字 page',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}

class YueDuShiZhi extends StatelessWidget {
  const YueDuShiZhi({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('閱讀'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        color: Colors.black,
        child: const Center(
          child: Text(
            'This is the 閱讀 page',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
