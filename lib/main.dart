/*
Welcome to the main.dart file for the "Learning To Read Chinese" (ltrc) 
App. This app employs voice interaction, pronouncing new words and sentences 
for the user to listen and read. To aid learning, users can record and playback 
their own pronunciation.

User registration and login are required to use the app. This is to collect
user data such as age and gender in order to present suitable materials. This
login/registration is implemented in Google Cloud PSQL. However, it is disabled
in the demo version.

Chinese characters, phrases and sentenses are stored in a local SQLite database. 
In the future, we should consider making part of this database open to teachers
so that they can create their own words, phrases and sentences for their 
students.

To make the code more modular, we created two services: DbService for the database
methods and VmService for the voice methods. DbService is complete; but VmService
only contains the initialization and dispose. The rest of methods are kept in 
base_voice.dart. This is due to my learning progress in this project. I started 
this project based on the Speech-to-text example. During the course of development,
I added more features and modules and created a lot of fiels and global variables. 
If I restart the whole project, I will move the state management out of
base_voice.dart, and move all voice methods to VmService. 

We use Provider to make these services available to the rest of App. In the 
future, we should use ChangeNotifierProvider. Please note that the code related
to Provider is sensitive. Please make changes with extra care.

Despite having iterated on the code three time for cleaner design and better 
modularity, there's still scope for improvements. For instance, transferring 
all methods from BaseVoicePage to VmService and eliminating global variables 
could be beneficial. Additionally, the UI could be significantly improved 
with features like a reward system to motivate students, tools for teachers 
to monitor students' progress, picture-to-text recognition, and more. In the 
near term, we plan to implement the suggestions provided by 鄭漢文校長 and 
陳素惠老師。

If this app succeeds in engaging its audience, numerous enhancements will 
undoubtedly follow. For example, we could add a pronouciation tools (both
BPMF and Pinyin) and a handwriting function to the App.
*/

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'db_service.dart';
import 'login_page.dart';
import 'vm_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(
    MultiProvider(
      providers: [
        Provider<DbService>(
          create: (context) => DbService(),
          dispose: (context, dbService) => dbService.dispose(),
        ),
        Provider<VmService>(
          create: (context) => VmService(),
          dispose: (context, vmService) => vmService.dispose(),
          lazy:
              false, // lazy: false to ensure the provider will be created immediately
        ),
        /* Remember, if VmService class extends ChangeNotifier and 
        you decide to use ChangeNotifierProvider in the future, we need to 
        replace Provider<VoiceMgmt> with ChangeNotifierProvider<VoiceMgmt> 
        in the code above.
        */
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // this line must be here otherwise _database won't be initialized
    // ignore: unused_local_variable
    var dbService = Provider.of<DbService>(context, listen: false);
    // ignore: unused_local_variable
    var vmService = Provider.of<VmService>(context, listen: false);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '學習閱讀',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const LoginPage(),
    );
  }
}
