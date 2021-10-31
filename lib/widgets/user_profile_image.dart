import 'package:devfest_flutter_firebase_chat/helpers/app_constants.dart';
import 'package:devfest_flutter_firebase_chat/models/app_user.dart';
import 'package:flutter/material.dart';

Widget profileImage(AppUser user, {double avatarRadius = 25}) {
  // No new profile image
  if (user.profileImageUrl!.isEmpty) {
    // Display placeholder
    return CircleAvatar(
      radius: avatarRadius,
      backgroundImage: const AssetImage('assets/images/user_placeholder.jpg'),
      backgroundColor:
          AppConstants.hexToColor(AppConstants.APP_PRIMARY_COLOR_ACTION),
    );
  } else {
    // User profile image exists
    return CircleAvatar(
      radius: avatarRadius,
      backgroundImage: NetworkImage(user.profileImageUrl!),
      backgroundColor: Colors.transparent,
    );
  }
}
