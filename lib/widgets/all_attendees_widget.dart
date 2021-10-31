import 'package:devfest_flutter_firebase_chat/helpers/app_constants.dart';
import 'package:devfest_flutter_firebase_chat/widgets/user_profile_image.dart';
import 'package:flutter/material.dart';
import 'package:devfest_flutter_firebase_chat/models/app_user.dart';
import 'package:devfest_flutter_firebase_chat/models/user_data.dart';
import 'package:devfest_flutter_firebase_chat/screens/chat_screen.dart';
import 'package:provider/provider.dart';

class AllAttendees extends StatelessWidget {
  final List<AppUser> appUsers;

  const AllAttendees({required this.appUsers, Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    String? currentUserId =
        Provider.of<UserData>(context, listen: false).currentUserId;

    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color:
              AppConstants.hexToColor(AppConstants.APP_BACKGROUND_COLOR_WHITE),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
            itemCount: appUsers.length,
            itemBuilder: (BuildContext context, int index) {
              final AppUser user = appUsers[index];
              return GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ChatScreen(
                      currentUserId: currentUserId!,
                      toUser: user,
                    ),
                  ),
                ),
                child: Container(
                  margin:
                      const EdgeInsets.only(top: 5.0, bottom: 5.0, right: 5.0),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 10.0),
                  decoration: BoxDecoration(
                    color: AppConstants.hexToColor(
                        AppConstants.APP_PRIMARY_TILE_COLOR),
                    borderRadius: const BorderRadius.all(Radius.circular(20.0)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          profileImage(user, avatarRadius: 20),
                          const SizedBox(width: 10.0),
                          Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  user.name!,
                                  style: TextStyle(
                                    color: AppConstants.hexToColor(AppConstants
                                        .APP_PRIMARY_FONT_COLOR_WHITE),
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 5.0),
                                Text(
                                  user.bio!,
                                  style: const TextStyle(
                                    fontSize: 12.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
