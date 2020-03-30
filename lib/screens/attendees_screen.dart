import 'package:flutter/material.dart';
import 'package:gdg_flutter_firebase_chat/models/user.dart';
import 'package:gdg_flutter_firebase_chat/models/user_data.dart';
import 'package:gdg_flutter_firebase_chat/services/auth_service.dart';
import 'package:gdg_flutter_firebase_chat/services/database_service.dart';
import 'package:gdg_flutter_firebase_chat/widgets/all_attendees_widget.dart';
import 'package:gdg_flutter_firebase_chat/widgets/app_drawer_widget.dart';
import 'package:provider/provider.dart';

class AttendeesScreen extends StatefulWidget {
   static final String id ='attendees_screen';

  @override
  _AttendeesScreenState createState() => _AttendeesScreenState();
}

class _AttendeesScreenState extends State<AttendeesScreen> {
  List<User> _users = [];
  @override
  void initState() {
    super.initState();
    _setupAttendees();
  }

  _setupAttendees() async {
    String currentUserId =Provider.of<UserData>(context, listen: false).currentUserId;
    List<User> users = await Provider.of<DataBaseService>(context, listen: false)
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
      backgroundColor: Theme.of(context).primaryColor,
            drawer: AppDrawer(),

      appBar: AppBar(
         
        title: Text(
          'Attendees',
          style: TextStyle(
            fontSize: 28.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: Provider.of<AuthService>(context, listen: false).logout,
          ),
        ],
      ),
      body: Column(
        children: <Widget>[ 
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).accentColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0),
                ),
              ),
              child: Column(
                children: <Widget>[ 
                   AllAttendees(users:_users),
                ],
              ),
            ),
          ),
        ],
      ),
    ); 
  }
} 
