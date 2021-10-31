import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:devfest_flutter_firebase_chat/helpers/app_constants.dart';
import 'package:devfest_flutter_firebase_chat/screens/attendees_screen.dart';
// import 'package:devfest_flutter_firebase_chat/screens/chat_screen.dart';
import 'package:devfest_flutter_firebase_chat/screens/login_screen.dart';
import 'package:devfest_flutter_firebase_chat/services/auth_service.dart';
import 'package:devfest_flutter_firebase_chat/services/database_service.dart';
import 'package:devfest_flutter_firebase_chat/services/storage_service.dart';
import 'package:provider/provider.dart';

import 'models/user_data.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserData(),
        ),
        Provider<AuthService>(
          create: (_) => AuthService(),
        ),
        Provider<DatabaseService>(
          create: (_) => DatabaseService(),
        ),
        Provider<StorageService>(
          create: (_) => StorageService(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // final i18n = I18n.delegate;

  @override
  void initState() {
    super.initState();
    //  I18n.onLocaleChanged = onLocaleChange;
  }

  void onLocaleChange(Locale locale) {
    setState(() {
      // I18n.locale = locale;
    });
  }

  Widget _getScreenId() {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasData) {
          Provider.of<UserData>(context).currentUserId = snapshot.data!.uid;
          return const AttendeesScreen();
        } else {
          return LoginScreen();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // localizationsDelegates: [
      //   i18n,
      //   GlobalMaterialLocalizations.delegate,
      //   GlobalWidgetsLocalizations.delegate,
      //   GlobalCupertinoLocalizations.delegate // <-- needed for iOS
      // ],
      // supportedLocales: i18n.supportedLocales,
      title: "GDG Firebase chat",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppConstants.hexToColor(AppConstants.APP_PRIMARY_COLOR),
        backgroundColor:
            AppConstants.hexToColor(AppConstants.APP_BACKGROUND_COLOR),
        primaryColorLight:
            AppConstants.hexToColor(AppConstants.APP_PRIMARY_COLOR_LIGHT),
        accentColor:
            AppConstants.hexToColor(AppConstants.APP_PRIMARY_COLOR_BLACK),
        accentIconTheme: IconThemeData(
            color:
                AppConstants.hexToColor(AppConstants.APP_PRIMARY_COLOR_BLACK)),
        dividerColor:
            AppConstants.hexToColor(AppConstants.APP_BACKGROUND_COLOR_GRAY),
        textTheme: TextTheme(
          caption: TextStyle(
              color: AppConstants.hexToColor(
                  AppConstants.APP_PRIMARY_FONT_COLOR_WHITE)),
        ),
      ),
      home: _getScreenId(),
      routes: {
        LoginScreen.id: (context) => const LoginScreen(),
        AttendeesScreen.id: (context) => const AttendeesScreen(),
      },
    );
  }
}
