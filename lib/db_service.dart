import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'globals_and_utils.dart';

class DbService {
  static const String appVersion =
      "0.0.1"; // Increment this when you update your app or database
  late Database _database;

  DbService() {
    initDb();
  }

  Future<void> initDb() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String previousVersion = prefs.getString("appVersion") ?? "";

    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, "ltrc.db");

    // Check if the database exists
    var exists = await databaseExists(path);
    MyLogEvent(eventDes: 'initDb in progress. path: $path, exists: $exists');

    if (!exists || previousVersion != appVersion) {
      // Create a new copy from assets
      try {
        await _createNewCopyFromAssets(path, exists);
        // The operation was successful if it gets to this line.
        print('_createNewCopy: succeed.');
      } catch (e) {
        // An error occurred. The catch block catches the exception.
        print('_createNewCopy: error: $e');
        // You can handle the error here, for example by showing an error message,
        // or performing some cleanup operations.
      }
    }

    // open the database
    try {
      _database = await openDatabase(path, readOnly: false);
    } catch (e) {
      print('Failed to open database: $e');
      // Handle the exception further according to your application's needs
    }

    MyLogEvent(eventDes: 'openDatabase succeed. _database: $_database');

    final List<Map<String, dynamic>> tables = await _database.rawQuery(
      "SELECT name FROM sqlite_master WHERE type='table' AND name='char_photo_table'",
    );
    final bool tableExists = tables.isNotEmpty;

    if (!tableExists) {
      throw Exception('Table char_photo_table does not exist in the database.');
    }
  }

  /*
  Future<Database?> get database async {
    // Initialize 'database' if it's not already
    // ignore: unnecessary_null_comparison
    if (_database == null) {
      await initDb();
    }
    return _database;
  }
  */
  Future<void> _createNewCopyFromAssets(String path, bool exists) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    print("Creating new copy from asset");
    try {
      await Directory(dirname(path)).create(recursive: true);
    } catch (e) {
      print('createNewCopy failed to create directory: $e');
      // Handle the exception further according to your application's needs
    }

    if (exists) {
      try {
        await File(path).delete();
      } catch (e) {
        print('createNewCopy failed to delete file: $e');
        // Handle the exception further according to your application's needs
      }
    }

    ByteData data = await rootBundle.load(join("assets", "ltrc.db"));
    List<int> bytes =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

    try {
      await File(path).writeAsBytes(bytes, flush: true);
    } catch (e) {
      print('Failed to write bytes to the file at $path. Error: $e');
      throw Exception('Failed to write bytes to the file. Error: $e');
    }

    prefs.setString("appVersion", appVersion);
  }

  Future<List<CharPhoto>> loadCharByType(String characterType) async {
    List<CharPhoto> characters = [];
    List<Map<String, dynamic>> rows;
    print('loadCharByType called, $_database, $characterType');

    if (characterType == 'all') {
      rows = await _database.query(
        'char_photo_table',
      );
    } else {
      rows = await _database.query(
        'char_photo_table',
        where: 'type = ?',
        whereArgs: [characterType],
      );
    }
    print('Number of rows retrieved: ${rows.length}');

    for (Map<String, dynamic> row in rows) {
      // Log all the row data before creating a CharPhoto
      // print('Row data: $row');

      String type =
          row['Type'] ?? 'null'; // Replace 'type' with the actual column name
      String name =
          row['Name'] ?? 'null'; // Replace 'name' with the actual column name
      String photoLink1 = row['Link1'] ??
          'null'; // Replace 'photolink1' with the actual column name
      String photoLink2 = row['Link2'] ??
          'null'; // Replace 'photolink2' with the actual column name
      String photoLink3 = row['Link3'] ??
          'null'; // Replace 'photolink3' with the actual column name
      String photoLink4 = row['Link4'] ??
          'null'; // Replace 'photolink4' with the actual column name

      characters.add(
        CharPhoto(
          type: type,
          name: name,
          photoLink1: photoLink1,
          photoLink2: photoLink2,
          photoLink3: photoLink3,
          photoLink4: photoLink4,
        ),
      );
    }

    return characters;
  }

  /*
  Future<List<CharPhoto>> loadCharByType(String characterType) async {
    print('loadCharByType called with characterType: $characterType');

    List<CharPhoto> characters = [];
    List<Map<String, dynamic>> rows;

    if (characterType == 'all') {
      print('Querying all rows from char_photo_table');

      rows = await _database.query(
        'char_photo_table',
      );
    } else {
      print(
          'Querying char_photo_table with where clause type = $characterType');

      rows = await _database.query(
        'char_photo_table',
        where: 'type = ?',
        whereArgs: [characterType],
      );
    }

    print('Number of rows retrieved: ${rows.length}');

    for (Map<String, dynamic> row in rows) {
      print('Row data: $row');

      characters.add(
        CharPhoto(
          type: row['type'],
          name: row['name'],
          photoLink1: row['photolink1'],
          photoLink2: row['photolink2'],
          photoLink3: row['photolink3'],
          photoLink4: row['photolink4'],
        ),
      );
    }

    print('Characters list length: ${characters.length}');
    return characters;
  }
  */

  /*
  Future<List<CharPhoto>> loadCharByType(String characterType) async {
    List<CharPhoto> characters = [];
    List<Map<String, dynamic>> rows;

    if (characterType == 'all') {
      rows = await _database.query(
        'char_photo_table',
      );
    } else {
      rows = await _database.query(
        'char_photo_table',
        where: 'type = ?',
        whereArgs: [characterType],
      );
    }

    for (Map<String, dynamic> row in rows) {
      characters.add(
        CharPhoto(
          type: row['type'],
          name: row['name'],
          photoLink1: row['photolink1'],
          photoLink2: row['photolink2'],
          photoLink3: row['photolink3'],
          photoLink4: row['photolink4'],
        ),
      );
    }

    MyLogEvent(
        eventDes: 'characterType: $characterType, characters: $characters');

    return characters;
  }
  */

  /* can not make it work now. Leave it in quizchar.dart
  Future<List<CharPhoto>> pickRandomCharacter(List<CharPhoto> character) async {
    List<CharPhoto> characters;

    List<Map<String, dynamic>> rows;

    final random = Random();
    _selectedCharacter = characters[random.nextInt(_characters.length)];

    _choices = List<CharPhoto>.from(characters);
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
  */

  void dispose() {
    _database.close();
  }
}

/*
This DbService class now includes the initDb() method for 
setting up the database. It checks whether the database file already 
exists and whether the app version has changed. If the database does 
not exist or the app version has changed, it copies the new database 
file from the app's assets.

Also, notice the dispose() method. This will ensure the database 
connection is properly closed when the service is disposed of by the 
Provider. It's important to always close connections to resources like 
databases when you're done using them to prevent memory leaks and other 
issues.

This service doesn't include any methods for actually interacting with 
the database yet (like querying for data). You'll need to add those 
based on the needs of your app.

Remember to replace "ltrc.db" and "1.0.1" with the actual name of your 
database file and your current app version, respectively.

A few points on this:

Your Charphoto class was moved into this file so it can be used by the 
DbService. If you prefer to keep your data models in separate 
files, feel free to move Charphoto to its own file and import it here.
The initDb() function now does some extra validation to make sure 
the char_photo_table table exists in the database after it's opened. 
This incorporates the functionality of your initDbDatabase() 
function.
The loadCharphotos() function is now a method on DbService. It 
uses
*/
