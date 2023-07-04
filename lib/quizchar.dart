// quizchar.dart is a page that allows users to test their knowledge of Chinese characters.
import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
// import 'package:auto_size_text/auto_size_text.dart';

import 'package:provider/provider.dart';
// import 'ft_sound_service.dart';
import 'db_service.dart';
import 'base_voice.dart';

import 'globals_and_utils.dart';

class QuizcharPage extends BaseVoicePage {
  const QuizcharPage({Key? key}) : super(key: key);

  @override
  QuizcharPageState createState() => QuizcharPageState();
}

class QuizcharPageState extends BaseVoicePageState {
  late DbService dbService;
  // late FtSoundService ftSoundService;
  String characterType = 'all'; // To get all characters from the database
  List<CharPhoto> _characters = []; // Initialize with an empty list
  // late CharPhoto _currentCharacter;
  late List<CharPhoto> _choices;
  late CharPhoto _selectedCharacter;
  late Future<List<CharPhoto>> _charactersFuture;

  @override
  void initState() {
    super.initState();

    // Initialize _charactersFuture with a Future.microtask
    _charactersFuture = Future.microtask(() async {
      dbService = Provider.of<DbService>(context, listen: false);
      final characters = await dbService.loadCharByType(characterType);

      setState(() {
        _characters = characters;
        _pickRandomCharacter();
      });

      return characters;
    });
  }

  void _pickRandomCharacter() {
    final random = Random();
    _selectedCharacter = _characters[random.nextInt(_characters.length)];

    _choices = List<CharPhoto>.from(_characters);
    _choices
        .remove(_selectedCharacter); // remove selected character from choices
    _choices.shuffle();
    _choices = _choices.sublist(0, 3); // take only three random characters
    _choices.add(_selectedCharacter); // add the selected character

    MyLogEvent(eventDes: '$_selectedCharacter, choices: $_choices');

    _choices.shuffle(); // shuffle the choices again

    MyLogEvent(eventDes: '$_selectedCharacter, choices: $_choices');

    setState(() {});
    Future.microtask(() => speak(_selectedCharacter.name));
  }

  // Not working yet?
  void playErrorSound() {
    try {
      playFrom('assets/mixkit-game-show-wrong-answer-buzz-950.mp3');
    } catch (e) {
      print('Failed to play the audio file: $e');
      // Handle the exception further according to your application's needs
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final fontSize = screenHeight * 0.03;

    return Scaffold(
      appBar: AppBar(
        title: const Text('試識看'),
        // Add more AppBar properties if needed
      ),
      body: Column(
        children: [
          Expanded(
            child: Column(
              children: [
                const SizedBox(height: 20),
                SizedBox(
                  width: screenWidth,
                  height: screenHeight * 0.25,
                  child: GestureDetector(
                    onTap: () => speak(_selectedCharacter.name),
                    child: Image.asset(
                      _selectedCharacter.photoLink1,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ],
            ),
          ),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            childAspectRatio: 2.0,
            padding: const EdgeInsets.all(20),
            mainAxisSpacing: 7.0,
            crossAxisSpacing: 7.0,
            children: _choices.map((character) {
              return GestureDetector(
                onTap: () {
                  speak(character.name);
                  if (character == _selectedCharacter) {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text(
                            "答對了!",
                            style: TextStyle(fontSize: fontSize),
                          ),
                          content: const Icon(Icons.thumb_up,
                              color: Colors.green, size: 60),
                          actions: [
                            TextButton(
                              child: Text(
                                '繼續',
                                style: TextStyle(fontSize: fontSize),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                                _pickRandomCharacter();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  } else {
                    MyLogEvent(
                        eventDes:
                            'expected: $_selectedCharacter.name, answer: $character.name');
                    // playErrorSound(); // Uncomment this line when the function is fixed
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text(
                            "不對，請再試!",
                            style: TextStyle(fontSize: fontSize),
                          ),
                          content: const Icon(Icons.thumb_down,
                              color: Colors.red, size: 60),
                          actions: [
                            TextButton(
                              child: Text('繼續',
                                  style: TextStyle(fontSize: fontSize)),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
                child: Card(
                  child: Center(
                    child: Text(
                      character.name,
                      style: TextStyle(fontSize: screenHeight * 0.03),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
