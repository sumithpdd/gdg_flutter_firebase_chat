import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gdg_flutter_firebase_chat/helpers/app_constants.dart';
import 'package:gdg_flutter_firebase_chat/models/user.dart';
import 'package:gdg_flutter_firebase_chat/models/user_data.dart';
import 'package:gdg_flutter_firebase_chat/screens/edit_profile_screen.dart';
import 'package:gdg_flutter_firebase_chat/services/database_service.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatefulWidget {
  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  _buildActivity(BuildContext context, String userId) {
    return FutureBuilder(
        future: Provider.of<DataBaseService>(context, listen: false)
            .getUser(userId),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return SizedBox.shrink();
          }
          User user = snapshot.data;
          return DrawerHeader(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              
              children: <Widget>[
                CircleAvatar(
                  radius: 20.0,
                  backgroundImage: user.profileImageUrl.isEmpty
                      ? AssetImage('assets/images/user_placeholder.jpg')
                      : CachedNetworkImageProvider(user.profileImageUrl),
                  backgroundColor: Colors.transparent,
                ),
                Text(
                  user.name,
                  style: TextStyle(color: Colors.black),
                ),
                Text(
                  user.bio,
                  style: TextStyle(color: Colors.black),
                ),
                IconButton(
                  icon: Icon(Icons.edit),
                  tooltip: 'Edit Profile',
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EditProfileScreen(
                        user: user,
                      ),
                    ),
                  ),
                  color:
                      AppConstants.hexToColor(AppConstants.APP_PRIMARY_COLOR),
                ),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    String currentUserId = Provider.of<UserData>(context).currentUserId;
    return Drawer(
      child: Column(
        children: <Widget>[
          currentUserId.isNotEmpty
              ? _buildActivity(context, currentUserId)
              : SizedBox.shrink(),
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
}
