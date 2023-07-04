// VmService (voice management service) in voice_mgmt.dart
// only contains the initialization and disposal logic for now.
// Other services such as speak, record, play, etc. are provided
// in BaseVoicePage class. We can move them to VmService in the future.

import 'dart:async';

// import 'package:flutter/material.dart';
import 'dart:io' show Platform;
// import 'dart:math';

import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
// import 'package:speech_app3/tools_and_old_files/main_example.dart';

import 'package:speech_to_text/speech_recognition_error.dart';
// import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_tts/flutter_tts.dart';

import 'package:flutter_sound/flutter_sound.dart'; // recorder and player
// import 'package:path_provider/path_provider.dart';

import 'globals_and_utils.dart';

enum TtsState { playing, stopped, paused, continued }

class VmService {
  // Variables for your text-to-speech, speech-to-text, recorder, and player instances.
  double sttConfidence = 1.0;
  final formatter = DateFormat('mm:ss.SSS');

  // General speech variables
  bool get isIOS => !kIsWeb && Platform.isIOS;
  bool get isAndroid => !kIsWeb && Platform.isAndroid;
  bool get isWindows => !kIsWeb && Platform.isWindows;
  bool get isWeb => kIsWeb;

  // For STT
  SpeechToText stt = SpeechToText();
  SpeechToText get speechToTextInstance => stt; // ?

  // For TTS
  late FlutterTts tts = FlutterTts();
  FlutterTts get flutterTtsInstance => tts;

  TtsState ttsState = TtsState.stopped;

  get isPlaying => ttsState == TtsState.playing;
  get isStopped => ttsState == TtsState.stopped;
  get isPaused => ttsState == TtsState.paused;
  get isContinued => ttsState == TtsState.continued;

  // final int _elapsedTime = 1000; // ms

  // For FS
  late FlutterSoundRecorder fsRecorder = FlutterSoundRecorder();
  FlutterSoundRecorder get flutterSoundRecorderInstance => fsRecorder; // ?
  late FlutterSoundPlayer fsPlayer = FlutterSoundPlayer();
  FlutterSoundPlayer get flutterSoundPlayerInstance => fsPlayer; // ?

  // String _pathToRecording = '';
  //  ValueNotifier<bool> isRecording = ValueNotifier(false);
  bool playerAndRecorderAreInited = false;
  bool isRecording = false;

  // Assume default values for the following
  String currentLocaleId = "cz-TW";
  String engine = "default";
  double volume = 1.0;
  double pitch = 1.0;
  double rate = 1.0;
  bool logEvents = true;
  String lastError = "";
  bool hasSpeech = false;
  String lastStatus = "";

  VmService() {
    print('VmService, constructor called');
    initStt();
    initTts();
    initFs();
  }

  /*
  Future<void> initVm() async {
    MyLogEvent(eventDes: 'initVm called');
    initStt();
    initTts();
    initFs();
  }
  */

  Future<void> initStt() async {
    MyLogEvent(eventDes: 'initStt called');
    try {
      var hasSpeechStt = await stt.initialize(
        onError: _errorListener,
        onStatus: _statusListener,
        debugLogging: logEvents,
      );
      // TBD: Need to verify that currentLocaleId is installed on the device
      if (!hasSpeechStt) {
        MyLogEvent(eventDes: 'initStt error: hasSpeechStt = false');
        return;
      }
      hasSpeech = hasSpeechStt;
      MyLogEvent(eventDes: 'initStt OK, hasSpeech: $hasSpeech');
    } catch (e) {
      lastError = 'initStt failed: ${e.toString()}';
      hasSpeech = false;
      MyLogEvent(eventDes: 'initStt failed: ${e.toString()},$hasSpeech');
    }
  }

  Future<void> initTts() async {
    MyLogEvent(eventDes: 'initTts called');
    // await tts.setSharedInstance(true); Why vsc suggested this
    // Assuming zh_TW is installed. Need to check in the future
    await tts.setLanguage(currentLocaleId);

    if (isAndroid) {
      getDefaultEngine();
      getDefaultVoice();
    }

    tts.setStartHandler(() {
      MyLogEvent(eventDes: "TTS Playing");
      ttsState = TtsState.playing;
    });

    if (isAndroid) {
      tts.setInitHandler(() {
        MyLogEvent(eventDes: "TTS Initialized");
      });
    }

    tts.setCompletionHandler(() {
      MyLogEvent(eventDes: "TTS Completion");
      ttsState = TtsState.stopped;
    });

    tts.setCancelHandler(() {
      MyLogEvent(eventDes: "TTS Cancel");
      ttsState = TtsState.stopped;
    });

    tts.setPauseHandler(() {
      MyLogEvent(eventDes: "TTS Paused");
      ttsState = TtsState.paused;
    });

    tts.setContinueHandler(() {
      MyLogEvent(eventDes: "TTS Continued");
      ttsState = TtsState.continued;
    });

    tts.setErrorHandler((msg) {
      MyLogEvent(eventDes: "TTS error: $msg");
      ttsState = TtsState.stopped;
    });
  } // initTts

  Future<void> initFs() async {
    // init Flutter Sound
    MyLogEvent(eventDes: 'initFs called');
    bool hasError = false;
    String errorMessage = '';
    await fsRecorder.setLogLevel(Level.warning);
    await fsPlayer.setLogLevel(Level.warning);

    try {
      await fsRecorder.openRecorder();
      await fsPlayer.openPlayer();
    } catch (e) {
      hasError = true;
      errorMessage = e.toString();
    }

    if (!hasError) {
      print('initFs: player and recorder are initialized');
      // Update the state here if there was no error
      // setState(() {
      playerAndRecorderAreInited = true;
      // });
    } else {
      // Handle the error case, maybe show a dialog or a snackbar with the error message
      print('initFs: Error opening recorder or player: $errorMessage');
    }
  } // initFs

  dispose() {
    print('VmService, dispose called');

    scheduleMicrotask(() async {
      await tts.stop();
      // Be careful : you must `close` the audio session
      // when you have finished with it.
      await fsPlayer.stopPlayer();
      await fsPlayer.closePlayer();
      await fsRecorder.stopRecorder();
      await fsRecorder.closeRecorder();
    });
    // Dispose your services here.
  }

  Future getDefaultEngine() async {
    var engine = await tts.getDefaultEngine; // engine is a global variable
    if (engine != null) {
      MyLogEvent(eventDes: 'getDefaultEngine: $engine');
    }
  }

  Future getDefaultVoice() async {
    var voice = await tts.getDefaultVoice; // voice is a global variable
    if (voice != null) {
      MyLogEvent(eventDes: 'getDefaultVoice: $voice');
    }
  }

  // _errorListener and _statusListener are only used in _initStt
  void _errorListener(SpeechRecognitionError error) {
    MyLogEvent(
        eventDes: 'errorListener error: $error, listening: ${stt.isListening}');
    // if (mounted) {
    //   setState(() {
    lastError = '${error.errorMsg} - ${error.permanent}';
    //  });
    // }
  }

  void _statusListener(String status) {
    MyLogEvent(
        eventDes:
            'statusListener status: $status, listening: ${stt.isListening}');
    // setState(() {
    lastStatus = status;
    //  });
  }
}
