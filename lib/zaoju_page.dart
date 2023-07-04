import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'setup_page.dart';
import 'sentence_builder_page.dart';

class ZaoJu extends StatefulWidget {
  ZaoJu({Key? key}) : super(key: key);

  @override
  _ZaoJuState createState() => _ZaoJuState();
}

class _ZaoJuState extends State<ZaoJu> {
  // This would probably be replaced with data from your database
  final List<String> sentences = [
    "今天是颱風天，風雨很大。我很害怕！",
    // Rest of the sentences
  ];

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeRight]);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Learn Chinese'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SetupPage()),
              );
            },
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Choose a sentence to start:',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            ...sentences.map((sentence) => TextButton(
                  child: Text(
                    sentence,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SentenceBuilderPage(
                          sentence: sentence.runes.map((rune) {
                            var character = String.fromCharCode(rune);
                            return character;
                          }).toList(),
                        ),
                      ),
                    );
                  },
                ))
          ],
        ),
      ),
    );
  }
}
