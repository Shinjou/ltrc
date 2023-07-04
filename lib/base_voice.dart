// base_voice.dart

import 'dart:async';

import 'package:flutter/material.dart';
import 'dart:io' show Platform;
import 'dart:math';

import 'package:intl/intl.dart';
// import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_tts/flutter_tts.dart';

import 'package:flutter_sound/flutter_sound.dart'; // recorder and player
import 'package:path_provider/path_provider.dart';

import 'globals_and_utils.dart';
import 'vm_service.dart';

abstract class BaseVoicePage extends StatefulWidget {
  const BaseVoicePage({Key? key}) : super(key: key);
}

enum TtsState { playing, stopped, paused, continued }

abstract class BaseVoicePageState<T extends BaseVoicePage> extends State<T> {
  VmService? vmService; // per chat
  SpeechToText? stt; // per chat
  FlutterTts? tts; // per chat
  FlutterSoundRecorder? fsRecorder; // per chat
  FlutterSoundPlayer? fsPlayer; // per chat

  double sttConfidence = 1.0;
  final formatter = DateFormat('mm:ss.SSS');

  // General speech variables
  bool get isIOS => !kIsWeb && Platform.isIOS;
  bool get isAndroid => !kIsWeb && Platform.isAndroid;
  bool get isWindows => !kIsWeb && Platform.isWindows;
  bool get isWeb => kIsWeb;

  // For STT

  // For TTS
  TtsState ttsState = TtsState.stopped;

  get isPlaying => ttsState == TtsState.playing;
  get isStopped => ttsState == TtsState.stopped;
  get isPaused => ttsState == TtsState.paused;
  get isContinued => ttsState == TtsState.continued;

  final int _elapsedTime = 1000; // ms

  // For FS
  // late FlutterSoundRecorder _recorder;
  // late FlutterSoundPlayer _player;
  String _pathToRecording = '';
  //  ValueNotifier<bool> isRecording = ValueNotifier(false);
  bool playerAndRecorderAreInited = false;
  bool isRecording = false;

  @override
  void initState() {
    super.initState();

    vmService = context.read<VmService>(); // ??
    stt = vmService?.speechToTextInstance; // ??
    tts = vmService?.flutterTtsInstance; // ??
    fsRecorder = vmService?.flutterSoundRecorderInstance; // ??
    fsPlayer = vmService?.flutterSoundPlayerInstance; // ??
  }

  @protected
  Future<dynamic> _getLanguages() async => await tts?.getLanguages;

  @protected
  Future<dynamic> _getEngines() async => await tts?.getEngines;

  @protected
  Future getDefaultEngine() async {
    var engine = await tts?.getDefaultEngine; // engine is a global variable
    if (engine != null) {
      MyLogEvent(eventDes: 'getDefaultEngine: $engine');
    }
  }

  @protected
  Future getDefaultVoice() async {
    var voice = await tts?.getDefaultVoice; // voice is a global variable
    if (voice != null) {
      MyLogEvent(eventDes: 'getDefaultVoice: $voice');
    }
  }

  @protected
  Future delaySpeak() async {
    await Future.delayed(
        Duration(milliseconds: _elapsedTime)); // delay before speak
  }

  @protected
  Future<void> speak(String text) async {
    // input: text to speak
    if (isIOS) {
      // if iOS, then use speaker (instead of ear phone) for voice
      await tts?.setIosAudioCategory(IosTextToSpeechAudioCategory.playback,
          [IosTextToSpeechAudioCategoryOptions.allowBluetooth]);
    }

    await tts?.setLanguage(currentLocaleId);
    await tts?.setVolume(volume);
    await tts?.setSpeechRate(rate);
    await tts?.setPitch(pitch);

    if (text.isNotEmpty) {
      setState(() {
        isListening = false;
      });
      delaySpeak();
      await tts?.speak(text);
      MyLogEvent(eventDes: 'speak completed, $text');
    }
  } // speak

  @protected
  Future setAwaitOptions() async {
    await tts?.awaitSpeakCompletion(true);
    MyLogEvent(eventDes: '_setAwaitOptions, await speak complete');
  }

  /* Move to VmService 
  @override
  @protected
  Future<void> dispose() async {
    tts.stop();

    // Be careful : you must `close` the audio session
    // when you have finished with it.
    await _player.stopPlayer();
    await _player.closePlayer();
    await _recorder.stopRecorder();
    await _recorder.closeRecorder();

    super.dispose();

    MyLogEvent(eventDes: 'dispose base_voice.dart');
  }
  */

  @override
  @protected
  void dispose() {
    print('BaseVoicePageState, dispose called');

    super.dispose();
    /*
    scheduleMicrotask(() async {
      await tts.stop();

      // Be careful : you must `close` the audio session
      // when you have finished with it.
      await _player.stopPlayer();
      await _player.closePlayer();
      await _recorder.stopRecorder();
      await _recorder.closeRecorder();
    });
    */
  }

  @protected
  void _onChange(String text) {
    //  if ($mounted) {
    setState(() {
      newVoiceText = text;
    });
    //  }
  }

  @protected
  void _showDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // This is called each time the users wants to start a new speech
  // recognition session
  @protected
  void startListening() {
    MyLogEvent(eventDes: 'startListening: $currentLocaleId');
    // lastWords = ''; defined in globals_and_utils.dart
    // lastError = ''; defined in globals_and_utils.dart
    final pauseFor = int.tryParse(pauseForController.text);
    final listenFor = int.tryParse(listenForController.text);
    // Note that `listenFor` is the maximum, not the minimun, on some
    // systems recognition will be stopped before this value is reached.
    // Similarly `pauseFor` is a maximum not a minimum and may be ignored
    // on some devices.
    stt?.listen(
      onResult: _resultListener,
      listenFor: Duration(seconds: listenFor ?? 30),
      pauseFor: Duration(seconds: pauseFor ?? 3),
      partialResults: true,
      localeId: currentLocaleId,
      onSoundLevelChange: _soundLevelListener,
      cancelOnError: true,
      listenMode: ListenMode.confirmation,
      onDevice: onDevice,
    );
    setState(() {
      isListening = true;
      lastWords = "";
    });
  }

  @protected
  void stopListening() {
    stt?.stop();
    setState(() {
      isListening = false;
      level = 0.0;
    });
    MyLogEvent(eventDes: 'stopListening');
  }

  @protected
  void _cancelListening() {
    stt?.cancel();
    setState(() {
      isListening = false;
      level = 0.0;
    });
    MyLogEvent(eventDes: 'cancelListening');
  }

  /// These callbacks are invoked each time new recognition results are
  /// available after `listen` is called.
  @protected
  void _resultListener(SpeechRecognitionResult result) {
    MyLogEvent(
        eventDes:
            'resultListener final: ${result.finalResult}, words: ${result.recognizedWords}');
    setState(() {
      lastWords = '${result.recognizedWords} - ${result.finalResult}';
    });
  }

  @protected
  void _soundLevelListener(double level) {
    minSoundLevel = min(minSoundLevel, level);
    maxSoundLevel = max(maxSoundLevel, level);
    // MyLogEvent(eventDes:'soundLevel $level: $minSoundLevel - $maxSoundLevel ');
    setState(() => level = level);
  }

  /// This initializes SpeechToText. That only has to be done
  /// once per application, though calling it again is harmless
  /// it also does nothing. The UX of the sample app ensures that
  /// it can only be called once.

  /* Move initStt, initTts and initFs to VmService and called in 
     the main.dart.
  @protected
  Future<void> initStt() async {
    MyLogEvent(eventDes: 'initStt');
    late SpeechToText stt = SpeechToText();
    try {
      var hasSpeechStt = await stt?.initialize(
        onError: _errorListener,
        onStatus: _statusListener,
        debugLogging: logEvents,
      );

      // Need to verify that currentLocaleId is installed on the device
      if (!hasSpeechStt) {
        MyLogEvent(eventDes: 'initStt error: hasSpeechStt = false');
        return;
      }

      if (!mounted) return;

      setState(() {
        hasSpeech = hasSpeechStt; // hasSpeech is in Global
        MyLogEvent(
            eventDes: 'initStt, mounted: $mounted, hasSpeech: $hasSpeech');
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          lastError = 'Speech recognition failed: ${e.toString()}';
          hasSpeech = false;
          MyLogEvent(eventDes: 'initStt error: ${e.toString()},$hasSpeech');
        });
      }
    }
  } // initStt

  @protected
  Future<void> initTts() async {
    MyLogEvent(
        eventDes:
            'initTts, language: $currentLocaleId, engine: $engine, volume: $volume, pitch: $pitch, rate: $rate');
    FlutterTts tts = FlutterTts(); // duplicate? It is in Global aleardy
    setAwaitOptions();

    // Assuming zh_TW is installed. Need to check in the future
    await tts.setLanguage(currentLocaleId);

    if (isAndroid) {
      getDefaultEngine();
      getDefaultVoice();
    }

    tts.setStartHandler(() {
      setState(() {
        MyLogEvent(eventDes: "TTS Playing");
        ttsState = TtsState.playing;
      });
    });

    if (isAndroid) {
      tts.setInitHandler(() {
        setState(() {
          MyLogEvent(eventDes: "TTS Initialized");
        });
      });
    }

    tts.setCompletionHandler(() {
      setState(() {
        MyLogEvent(eventDes: "TTS Completion");
        ttsState = TtsState.stopped;
      });
    });

    tts.setCancelHandler(() {
      setState(() {
        MyLogEvent(eventDes: "TTS Cancel");
        ttsState = TtsState.stopped;
      });
    });

    tts.setPauseHandler(() {
      setState(() {
        MyLogEvent(eventDes: "TTS Paused");
        ttsState = TtsState.paused;
      });
    });

    tts.setContinueHandler(() {
      setState(() {
        MyLogEvent(eventDes: "TTS Continued");
        ttsState = TtsState.continued;
      });
    });

    tts.setErrorHandler((msg) {
      setState(() {
        MyLogEvent(eventDes: "TTS error: $msg");
        ttsState = TtsState.stopped;
      });
    });
  } // initTts

  @protected
  Future<void> initFs() async {
    // init Flutter Sound
    bool hasError = false;
    String errorMessage = '';
    await _recorder.setLogLevel(Level.debug);
    await _player.setLogLevel(Level.debug);

    try {
      _recorder = FlutterSoundRecorder();
      _player = FlutterSoundPlayer();
      await _recorder.openRecorder();
      await _player.openPlayer();
    } catch (e) {
      hasError = true;
      errorMessage = e.toString();
    }

    if (!hasError) {
      print('initFs: player and recorder are initialized');
      // Update the state here if there was no error
      setState(() {
        playerAndRecorderAreInited = true;
      });
    } else {
      // Handle the error case, maybe show a dialog or a snackbar with the error message
      print('initFs: Error opening recorder or player: $errorMessage');
    }
  } // initTts
  */

  @protected
  Future<void> startRecording() async {
    var tempDir = await getTemporaryDirectory();
    _pathToRecording = '${tempDir.path}/flutter_sound-tmp.aac';
    print('startRecording: $_pathToRecording');
    try {
      await fsRecorder?.startRecorder(toFile: _pathToRecording);
      setState(() {
        isRecording = true;
      });
    } catch (e) {
      print('startRecording failed: $e');
      // Handle the exception further according to your application's needs
    }
  }

  @protected
  Future<void> stopRecording() async {
    print('stopRecording: $_pathToRecording');
    try {
      await fsRecorder?.stopRecorder();
      setState(() {
        isRecording = false;
      });
    } catch (e) {
      print('startRecording failed: $e');
      // Handle the exception further according to your application's needs
    }
  }

  @protected
  Future<void> playRecording() async {
    print('playRecording: $_pathToRecording');
    try {
      await fsPlayer?.startPlayer(fromURI: _pathToRecording);
    } catch (e) {
      print('playRecording failed: $e');
      // Handle the exception further according to your application's needs
    }
  }

  @protected
  Future<void> stopPlaying() async {
    await fsPlayer?.stopPlayer();
  }

  @protected
  // Play from an existing file
  Future<void> playFrom(String path) async {
    print('playFrom: $path');
    try {
      await fsPlayer?.startPlayer(fromURI: path);
    } catch (e) {
      print('playFrom failed: $e');
      // Handle the exception further according to your application's needs
    }
  }

  @protected
  // Add this method to perform the entire sequence: record -> wait -> play
  Future<void> recordWaitPlay() async {
    await startRecording();
    await Future.delayed(
        const Duration(seconds: 2)); // Replace with the duration you want
    await stopRecording();
    await Future.delayed(
        const Duration(milliseconds: 300)); // Delay for 1 second before playing
    await playRecording();
  }

  // _errorListener and _statusListener are only used in _initStt
  @protected
  void _errorListener(SpeechRecognitionError error) {
    MyLogEvent(
        eventDes:
            'errorListener error: $error, listening: ${stt?.isListening}');
    if (mounted) {
      setState(() {
        lastError = '${error.errorMsg} - ${error.permanent}';
      });
    }
  }

  @protected
  void _statusListener(String status) {
    MyLogEvent(
        eventDes:
            'statusListener status: $status, listening: ${stt?.isListening}');
    setState(() {
      lastStatus = status;
    });
  }

  // sttTranscription and selectedCharacter are global
  // variables. They are not passed to _verifySpeech()
  @protected
  void _verifySpeech() {
    MyLogEvent(eventDes: '${formatter.format(DateTime.now())}: 開始驗證。。。');
    if (sttTranscription == selectedCharacter) {
      _showDialog('答對了', '恭喜你，你很厲害！');
      speak('答對了！');
    } else {
      _showDialog('答錯了', '再試一次吧！');
      speak('答錯了！');
    }
  }

  @protected
  void _speakAgain() {
    MyLogEvent(eventDes: '請再說一次 $selectedCharacter');
    speak(selectedCharacter);
  }

  @protected
  Future _stopSpeaking() async {
    var result = await tts?.stop();
    if (result == 1) setState(() => ttsState = TtsState.stopped);
    MyLogEvent(eventDes: '_stopSpeaking, $result');
  }

  @protected
  Future _pauseSpeaking() async {
    var result = await tts?.pause();
    if (result == 1) setState(() => ttsState = TtsState.paused);
    MyLogEvent(eventDes: '_pauseSpeaking, $result');
  }

  // This is not right. Should follow the logic of "recognitionComplete"
  @protected
  void _listenAndVerify() {
    MyLogEvent(eventDes: '_listenAndVerify 開始聆聽。。。');
    startListening();

    MyLogEvent(eventDes: '_listenAndVerify 停止聆聽。。。');
    _verifySpeech();
  }
}
