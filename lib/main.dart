import 'package:flutter/material.dart';
import 'package:gdg_flutter_firebase_chat/helpers/app_constants.dart';
import 'package:gdg_flutter_firebase_chat/screens/chat_screen.dart';
import 'package:gdg_flutter_firebase_chat/screens/login_screen.dart';

void main() {
  runApp(
    MaterialApp(
      title: "GDG Firebase chat",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppConstants.hexToColor(AppConstants.APP_PRIMARY_COLOR),
        backgroundColor:
            AppConstants.hexToColor(AppConstants.APP_BACKGROUND_COLOR),
        primaryColorLight:
            AppConstants.hexToColor(AppConstants.APP_PRIMARY_COLOR_LIGHT),
        accentColor: Colors.black,
        accentIconTheme: IconThemeData(color: Colors.black),
        dividerColor: Colors.black12,
        textTheme: TextTheme(
          caption: TextStyle(color: Colors.white),
        ),
      ),
      home: LoginScreen(),
    ),
  );
}

_appDrawer() {
  return Drawer(
    child: Column(
      children: <Widget>[
        DrawerHeader(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              CircleAvatar(
                radius: 30.0,
                backgroundImage:
                    AssetImage('assets/images/user_placeholder.jpg'),
                backgroundColor: Colors.transparent,
              ),
              Text(
                'Sumith Damodaran',
                style: TextStyle(color: Colors.black),
              ),
              Text(
                'PM @ Sitecore',
                style: TextStyle(color: Colors.black),
              )
            ],
          ),
        ),
        Spacer(),
        ListTile(
          leading: Icon(Icons.home),
          title: Text('Home'),
          onTap: () {},
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.people),
          title: Text('Attendants'),
          onTap: () {},
        ),
        Spacer(flex: 8),
      ],
    ),
  );
}
