// charphoto_temp2.dart
import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

import 'package:provider/provider.dart';
import 'db_service.dart';
import 'base_voice.dart';

import 'globals_and_utils.dart';

class CharPhotoPage2 extends BaseVoicePage {
  final String characterType;
  const CharPhotoPage2({Key? key, required this.characterType})
      : super(key: key);

  @override
  CharPhotoPage2State createState() => CharPhotoPage2State(characterType);
}

class CharPhotoPage2State extends BaseVoicePageState {
  final String characterType;
  late DbService dbService;
  // late FtSoundService ftSoundService;
  List<CharPhoto> _characters = []; // Initialize with an empty list
  late CharPhoto _currentCharacter;
  String lastWords = "";
  String selectedCharacter = "";
  int displayedPage = 1;
  Future<List<CharPhoto>>? _charactersFuture;

  CharPhotoPage2State(this.characterType);

  @override
  void initState() {
    super.initState();
    dbService = Provider.of<DbService>(context, listen: false);
    // dbService = context.read<DbService>();
    print('charphoto2 initState called'); // Added a print statement here
    _charactersFuture = _loadCharacters();
    /*
    // Initialize _charactersFuture with a Future.microtask
    _charactersFuture = Future.microtask(() async {
      print('Future.microtask called'); // And here
      dbService = Provider.of<DbService>(context, listen: false);
      ftSoundService = Provider.of<FtSoundService>(context, listen: false);
      final characters = await dbService.loadCharByType(characterType);
      print('Characters loaded: $characters'); // And here

      // log each character after loading
      for (var character in characters) {
        print('Loaded character: $character');
      }

      setState(() {
        _characters = characters;
        _pickRandomCharacter();
      });

      return characters;
    });
    */
  }

  Future<List<CharPhoto>> _loadCharacters() async {
    print('_loadCharacters called');
    dbService = Provider.of<DbService>(context, listen: false);
    final characters = await dbService.loadCharByType('小倉頡');

    /* The following print statements are for testing purpose    
    print('Characters loaded: $characters');
    for (var character in characters) {
      print('Loaded character: $character');
    }
    */

    setState(() {
      _characters = characters;
      _pickRandomCharacter();
    });

    return characters;
  }

  void _nextCharacter() {
    final currentIndex = _characters.indexOf(_currentCharacter);
    final nextIndex = (currentIndex + 1) % _characters.length;
    setState(() {
      _currentCharacter = _characters[nextIndex];
      displayedPage = 1;
      // print('Current character after next: $_currentCharacter'); // And here
    });
    speak(_currentCharacter.name);
  }

  void _pickRandomCharacter() {
    final randomIndex = Random().nextInt(_characters.length);
    setState(() {
      _currentCharacter = _characters[randomIndex];
      displayedPage = 1;
      MyLogEvent(
          eventDes:
              'randomChar: $_currentCharacter, link: ${_currentCharacter.photoLink1}');
    });
    speak(_currentCharacter.name);
  }

  void _nextPage() {
    setState(() {
      displayedPage = (displayedPage + 1) % 4;
    });
    // print('Next page called, displayedPage: $displayedPage'); // And here
    speak(_currentCharacter.name);
  }

  // Define CharPhotoPageView as a method within CharPhotoPageState
  Widget characterPageView(CharPhoto currentCharacter, double screenWidth,
      double screenHeight, int displayedPage) {
    Widget buildCharacter() {
      return GestureDetector(
        onTap: () => speak(currentCharacter.name),
        child: Center(
          child: AutoSizeText(
            currentCharacter.name,
            style: const TextStyle(fontSize: 150),
            maxLines: 1,
          ),
        ),
      );
    }

    Widget buildImage() {
      String image = currentCharacter.photoLink1;
      // print(
      //     'buildImage: $image, ${currentCharacter.name}, ${currentCharacter.photoLink1}');
      return GestureDetector(
        onTap: () => speak(currentCharacter.name),
        child: Image.asset(
          image,
          fit: BoxFit.contain,
        ),
      );
    }

    Widget buildImageGrid() {
      List<String> images = [
        currentCharacter.photoLink1 ?? 'assets/placeholder.png',
        currentCharacter.photoLink2 ?? 'assets/placeholder.png',
        currentCharacter.photoLink3 ?? 'assets/placeholder.png',
        currentCharacter.photoLink4 ?? 'assets/placeholder.png',
      ];
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: images.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10, // Horizontal padding
          mainAxisSpacing: 10, // Vertical padding
        ),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => speak(currentCharacter.name),
            child: Padding(
              padding: const EdgeInsets.all(8.0), // Padding around each image
              child: Image.asset(
                images[index],
                fit: BoxFit.contain,
              ),
            ),
          );
        },
      );
    }

    if (displayedPage == 1) {
      return Column(
        children: [
          const SizedBox(height: 20),
          SizedBox(
            width: screenWidth,
            height: screenHeight * 0.25,
            child: buildImage(),
          ),
        ],
      );
    } else if (displayedPage == 2) {
      return Column(
        children: [
          const SizedBox(height: 20),
          SizedBox(
            width: screenWidth,
            height:
                screenHeight * 0.5, // adjust the height as per your requirement
            child: buildImageGrid(),
          ),
        ],
      );
    } else if (displayedPage == 3) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: screenWidth,
            height: screenHeight * 0.5,
            child: buildCharacter(),
          ),
        ],
      );
    } else {
      return Container(); // just in case, it should never get here.
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final fontSize = screenHeight * 0.03;

    // Wrap your widget tree that depends on _characters in a FutureBuilder
    return FutureBuilder<List<CharPhoto>>(
      future: _charactersFuture,
      builder: (BuildContext context, AsyncSnapshot<List<CharPhoto>> snapshot) {
        print(
            'FutureBuilder build called, connectionState: ${snapshot.connectionState}'); // And here
        // print("Snapshot data: ${snapshot.data}");
        print("Snapshot error: ${snapshot.error}");
        if (snapshot.connectionState == ConnectionState.waiting) {
          // If the Future is not completed, show a loading spinner
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          // If there's an error, show an error message
          print('Error in FutureBuilder: ${snapshot.error}'); // And here
          return Text('Error: ${snapshot.error}');
        } else {
          // If the Future is completed, show your normal widget
          _characters = snapshot.data!;
          // print('Characters in FutureBuilder: $_characters'); // And here
          return Scaffold(
            appBar: AppBar(
              title: Text(characterType),
            ),
            body: _characters.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    children: [
                      Expanded(
                          child: characterPageView(_currentCharacter,
                              screenWidth, screenHeight, displayedPage)),
                      // ),
                      ControlButtons(
                        onSpeak: () => speak(_currentCharacter.name),
                        onNext: () {
                          if (displayedPage == 1 || displayedPage == 2) {
                            _nextPage();
                          } else if (displayedPage == 3) {
                            _nextCharacter();
                          }
                        },
                        onRecordWaitPlay: () => recordWaitPlay(),
                        lastWords: lastWords,
                        isRecording: isRecording,
                        fontSize: fontSize,
                      ),
                    ],
                  ),
          );
        }
      },
    );
  }
}

class ControlButtons extends StatelessWidget {
  final VoidCallback onSpeak;
  final VoidCallback onNext;
  final VoidCallback onRecordWaitPlay;
  final String lastWords;
  final bool isRecording;
  final double fontSize;

  const ControlButtons({
    Key? key,
    required this.onSpeak,
    required this.onNext,
    required this.onRecordWaitPlay,
    required this.lastWords,
    required this.isRecording,
    required this.fontSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // print(
    //     'ControlButtons build called, isRecording: ${ftSoundService.isRecording.value}'); // Added a print statement here

    return Container(
      padding: const EdgeInsets.all(10.0),
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        childAspectRatio: 2.0,
        padding: const EdgeInsets.all(20),
        mainAxisSpacing: 7.0,
        crossAxisSpacing: 7.0,
        children: [
          GestureDetector(
            onTap: onRecordWaitPlay,
            child: Card(
              color: isRecording ? Colors.red.shade100 : null,
              child: Center(
                child: Icon(
                  Icons.mic,
                  size: fontSize * 1.5,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: onNext, // Next page
            child: Card(
              child: Center(
                child: Icon(
                  Icons.arrow_forward,
                  size: fontSize * 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
