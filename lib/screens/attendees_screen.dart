import 'package:devfest_flutter_firebase_chat/helpers/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:devfest_flutter_firebase_chat/models/app_user.dart';
import 'package:devfest_flutter_firebase_chat/models/user_data.dart';
import 'package:devfest_flutter_firebase_chat/services/auth_service.dart';
import 'package:devfest_flutter_firebase_chat/services/database_service.dart';
import 'package:devfest_flutter_firebase_chat/widgets/all_attendees_widget.dart';
import 'package:devfest_flutter_firebase_chat/widgets/app_drawer_widget.dart';
import 'package:provider/provider.dart';

class AttendeesScreen extends StatefulWidget {
  static const String id = 'attendees_screen';

  const AttendeesScreen({Key? key}) : super(key: key);

  @override
  _AttendeesScreenState createState() => _AttendeesScreenState();
}

class _AttendeesScreenState extends State<AttendeesScreen> {
  List<AppUser> _users = [];
  @override
  void initState() {
    super.initState();
    _setupAttendees();
  }

  _setupAttendees() async {
    String currentUserId =
        Provider.of<UserData>(context, listen: false).currentUserId!;
    List<AppUser> users =
        await Provider.of<DatabaseService>(context, listen: false)
            .getAllUsers(currentUserId);
    if (mounted) {
      setState(() {
        _users = users;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        backgroundColor:
            AppConstants.hexToColor(AppConstants.APP_PRIMARY_COLOR),
        title: const Text(
          'Attendees',
          style: TextStyle(
            fontSize: 28.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: Provider.of<AuthService>(context, listen: false).logout,
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          AllAttendees(appUsers: _users),
        ],
      ),
    );
  }
}
