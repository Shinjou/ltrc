// LoginPage
// import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'globals_and_utils.dart';
import 'base_voice.dart';
import 'main_menu.dart';

class LoginPage extends BaseVoicePage {
  const LoginPage({Key? key}) : super(key: key);

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends BaseVoicePageState {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _gradeController = TextEditingController();

  bool _isLoginForm = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    /* Stt, Tts, Fs are initialized in main.dart
    initStt().then((result) {
      // Use the result when the Future completes successfully.
      MyLogEvent(eventDes: 'initStt Success');
    }).catchError((error) {
      // Handle the error if the Future fails.
      MyLogEvent(eventDes: 'initStt Error: $error');
    }).whenComplete(() {
      // This block will always be executed, regardless of whether the Future
      // completed successfully or with an error.
      MyLogEvent(eventDes: 'initStt Async operation completed');
    });

    initTts().then((result) {
      // Use the result when the Future completes successfully.
      MyLogEvent(eventDes: 'initTts Success');
    }).catchError((error) {
      // Handle the error if the Future fails.
      MyLogEvent(eventDes: 'initTts Error: $error');
    }).whenComplete(() {
      // This block will always be executed, regardless of whether the Future
      // completed successfully or with an error.
      MyLogEvent(eventDes: 'initTts Async operation completed');
    });

    // new for flutter sound
    initFs().then((result) {
      // Use the result when the Future completes successfully.
      MyLogEvent(eventDes: 'initFs Success');
    }).catchError((error) {
      // Handle the error if the Future fails.
      MyLogEvent(eventDes: 'initFs Error: $error');
    }).whenComplete(() {
      // This block will always be executed, regardless of whether the Future
      // completed successfully or with an error.
      MyLogEvent(eventDes: 'initFs Async operation completed');
    });
    */
  }

  @override
  Future<void> dispose() async {
    // Clean up the controller when the widget is disposed.
    _usernameController.dispose();
    _passwordController.dispose();
    _gradeController.dispose();
    MyLogEvent(eventDes: 'dispose LoginPageState');

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('ltrc 歡迎您！'),
        ),
        body: Container(
          padding: const EdgeInsets.all(14.0),
          child: SingleChildScrollView(
            reverse: true,
            padding: const EdgeInsets.all(14.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                TextFormField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    labelText: '用戶名',
                  ),
                ),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: '密碼',
                  ),
                  obscureText: true,
                ),
                TextFormField(
                  controller: _gradeController,
                  decoration: const InputDecoration(
                    labelText: '年級',
                  ),
                ),
                const SizedBox(
                  height: 14.0,
                ),
                CupertinoButton.filled(
                  child: Text(_isLoginForm ? '登錄' : '註冊'),
                  onPressed: () {
                    if (_isLoginForm) {
                      // Perform login logic
                      _performLogin();
                    } else {
                      // Perform registration logic. Comment out for testing in the iPhone
                      // _performRegistration();
                    }
                  },
                ),
                _buildSwitchFormButton(),
                Text(
                  _errorMessage,
                  style: const TextStyle(
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Widget _buildSwitchFormButton() {
    return CupertinoButton(
      child: Text(
        _isLoginForm ? '創建一個帳戶' : '已有帳戶？',
        style: const TextStyle(
          color: Colors.blue,
        ),
      ),
      onPressed: () {
        setState(() {
          _isLoginForm = !_isLoginForm;
          _errorMessage = '';
        });
      },
    );
  }

  void _performLogin() async {
    // Get the username and password entered by the user
    final String username = _usernameController.text.trim();
    final String password = _passwordController.text.trim();
    /*
    // * comment out login checking for testing in the iPhone
    // Check if the username and password are not empty
    if (username.isEmpty || password.isEmpty) {
      setState(() {
        _errorMessage = '請輸入用戶名和密碼';
      });
      return;
    }

    // Check if the user exists in the database
    final user = await _getUserFromDatabase();
    if (user == null) {
      setState(() {
        _errorMessage = '請先註冊再登入';
      });
      return;
    }

    // Check if the password is correct
    if (password != user['password']) {
      setState(() {
        _errorMessage = '用戶名或密碼不正確';
      });
      return;
    }
    // * comment out login checking for testing in the iPhone
    */

    // Login successful, navigate to MainMenuPage in main_menu.dart
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const MainMenuPage()));
  }

  /* temp comment out for testing in the iPhone
  Future<Map<String, dynamic>?> _getUserFromDatabase() async {
    final String username = _usernameController.text.trim();

    // Call getUserFromDatabase() function from db_access.dart file
    final user = await getUserFromDatabase(username);

    if (user != null) {
      MyLogEvent(eventDes: '用戶名: $user');
      return user;
    } else {
      MyLogEvent(eventDes: '找不到用戶名');
      setState(() {
        _errorMessage = '找不到用戶名';
      });
      return null;
    }
  } // _getUserFromDatabase()

  Future<Map<String, dynamic>?> _performRegistration() async {
    final String username = _usernameController.text.trim();
    final String password = _passwordController.text.trim();
    final String grade = _gradeController.text.trim();

    // Call performRegistration() function from db_access.dart file
    final success = await performRegistration(username, password, grade);

    if (success) {
      MyLogEvent(eventDes: 'Registration successful');
      // Registration successful, navigate to MainPage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainMenuPage()),
      );
      return null;
    } else {
      MyLogEvent(eventDes: 'Registration unsuccessful');
      setState(() {
        _errorMessage = 'Registration unsuccessful';
      });
      return null;
    }
  } // _performRegistration()
  */
} // LoginPageState

/* 
This loginpage.dart performs the following tasks:
 - loginPage, then go to main_menu.dart
 - initStt
 - initTts

The init parts are based on Speech_to_text example in // https://pub.dev/packages/speech_to_text/example.
and flutter_tts example in https://pub.dev/packages/flutter_tts/example.
Originally I was trying to create a VoiceUtils for all modules to share.
But I found out that most of STT functions and some TTS functions will
change the state. So I decided to put STT and TTS functions in each module.
Later on I accidently found out that inheritance can solve the code sharing
problem. So I created a VoiceUtils class and inherited it in each module.
*/
