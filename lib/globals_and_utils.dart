// globals_and_utils.dart. Need to be imported in all modules

import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';

import 'package:intl/intl.dart';

// globals
bool logEvents = true; // set to false in the production code
String currentLocaleId =
    'zh-TW'; // Need to check if the device supports this locale
bool isCurrentLanguageInstalled = false; // set to false in the production code

// For STT
String selectedCharacter = '';
String selectedCharacterImageLink = '';

String sttTranscription = '';
double sttConfidence = 1.0;

bool hasSpeech = false;
bool isListening = false;
bool isRecording = false;
bool onDevice = false; // used as setter, can not be final
final TextEditingController pauseForController =
    TextEditingController(text: '3');
final TextEditingController listenForController =
    TextEditingController(text: '30');
final TextEditingController textEditingController = TextEditingController();
double level = 0.0;
double minSoundLevel = 50000;
double maxSoundLevel = -50000;
String lastWords = '';
String lastError = '';
String lastStatus = '';

List<LocaleName> localeNames = []; // LocalName ?

// Below is for TTS
String? language; // same as currentLocaleId?
String? engine;
double volume = 0.8; // How to adjust volume?
double pitch = 1.0;
double rate = 0.5;

// enum TtsState { playing, stopped, paused, continued }

// TtsState ttsState = TtsState.stopped;

String? newVoiceText;
int?
    _inputLength; // In original code，_inputLength = await flutterTts.getMaxSpeechInputLength;
// But I can not find where it is used.

// utilities
class MyLogEvent {
  late String eventDes;

  MyLogEvent({required this.eventDes}) {
    if (logEvents) {
      var eventTime = DateTime.now();
      var formattedTime = DateFormat('HH:mm:ss.SSS').format(eventTime);
      print('$formattedTime $eventDes');
    }
  }
}

class CharPhoto {
  final String type;
  final String name;
  final String photoLink1;
  final String photoLink2;
  final String photoLink3;
  final String photoLink4;

  CharPhoto(
      {required this.type,
      required this.name,
      required this.photoLink1,
      required this.photoLink2,
      required this.photoLink3,
      required this.photoLink4});

  @override
  String toString() {
    return 'CharPhoto{type: $type, name: $name, photoLink1: $photoLink1, photoLink2: $photoLink2, photoLink3: $photoLink3, photoLink4: $photoLink4}';
  }
}
