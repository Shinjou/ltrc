import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'zaoju_page.dart';
/*
import 'package:provider/provider.dart';
import 'services/database_service.dart';
import 'services/tts_service.dart';
import 'services/audio_recording_service.dart';
*/

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeRight])
      .then((_) {
    runApp(MyApp());
  });
}
/*
void main() {
  runApp(
    MultiProvider(
      providers: [
        Provider<DatabaseService>(
          create: (_) => DatabaseService(),
        ),
        Provider<TtsService>(
          create: (_) => TtsService(),
        ),
        Provider<AudioRecordingService>(
          create: (_) => AudioRecordingService(),
        ),
      ],
      child: MyApp(),
    ),
  );
}
*/

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Learn Chinese',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: ZaoJu(),
    );
  }
}
