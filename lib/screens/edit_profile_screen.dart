import 'dart:io';

import 'package:devfest_flutter_firebase_chat/widgets/user_profile_image.dart';
import 'package:flutter/material.dart';
import 'package:devfest_flutter_firebase_chat/helpers/app_constants.dart';
import 'package:devfest_flutter_firebase_chat/models/app_user.dart';
import 'package:devfest_flutter_firebase_chat/services/storage_service.dart';
import 'package:devfest_flutter_firebase_chat/services/database_service.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileScreen extends StatefulWidget {
  static const String id = 'edit_profile_screen';

  final AppUser user;
  const EditProfileScreen({required this.user, Key? key}) : super(key: key);
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  File? _profileImage;
  String _name = '';
  String _bio = '';
  bool _isLoading = false;
  @override
  void initState() {
    super.initState();
    _name = widget.user.name!;
    _bio = widget.user.bio!;
  }

  _handleImageFromGallery() async {
    XFile? imageFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (imageFile != null) {
      setState(() {
        _profileImage = File(imageFile.path);
      });
    }
  }

  _displayProfileImage() {
    if (_profileImage == null) {
      // User profile image exists
      return profileImage(widget.user);
    } else {
      // New profile image
      return CircleAvatar(
        radius: 60.0,
        backgroundColor:
            AppConstants.hexToColor(AppConstants.APP_BACKGROUND_COLOR_GRAY),
        backgroundImage: FileImage(_profileImage!),
      );
    }
  }

  _submit() async {
    if (_formKey.currentState!.validate() && !_isLoading) {
      _formKey.currentState!.save();

      setState(() {
        _isLoading = true;
      });

      // Update user in database
      String? _profileImageUrl = '';

      if (_profileImage == null) {
        _profileImageUrl = widget.user.profileImageUrl;
      } else {
        _profileImageUrl = await StorageService.uploadUserProfileImage(
          widget.user.profileImageUrl!,
          _profileImage!,
        );
      }

      AppUser user = AppUser(
        id: widget.user.id,
        name: _name,
        profileImageUrl: _profileImageUrl,
        bio: _bio,
      );
      // Database update
      DatabaseService.updateUser(user);

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            AppConstants.hexToColor(AppConstants.APP_PRIMARY_COLOR),
        title: const Text(
          'Edit Profile',
          style: TextStyle(
            fontSize: 28.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: ListView(
          children: <Widget>[
            _isLoading
                ? LinearProgressIndicator(
                    backgroundColor:
                        AppConstants.hexToColor(AppConstants.APP_PRIMARY_COLOR),
                    valueColor: AlwaysStoppedAnimation(AppConstants.hexToColor(
                        AppConstants.APP_PRIMARY_COLOR)),
                  )
                : const SizedBox.shrink(),
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    _displayProfileImage(),
                    TextButton(
                      onPressed: _handleImageFromGallery,
                      child: Text(
                        'Change Profile Image',
                        style: TextStyle(
                            color: AppConstants.hexToColor(
                                AppConstants.APP_PRIMARY_COLOR_ACTION),
                            fontSize: 16.0),
                      ),
                    ),
                    TextFormField(
                      initialValue: _name,
                      style: const TextStyle(fontSize: 18.0),
                      decoration: const InputDecoration(
                        icon: Icon(
                          Icons.person,
                          size: 30.0,
                        ),
                        labelText: 'Name',
                      ),
                      validator: (input) => input!.trim().isEmpty
                          ? 'Please enter a valid name'
                          : null,
                      onSaved: (input) => _name = input!,
                    ),
                    TextFormField(
                      initialValue: _bio,
                      style: const TextStyle(fontSize: 18.0),
                      decoration: const InputDecoration(
                        icon: Icon(
                          Icons.book,
                          size: 30.0,
                        ),
                        labelText: 'Bio',
                      ),
                      validator: (input) => input!.trim().length > 150
                          ? 'Please enter a bio less than 150 characters'
                          : null,
                      onSaved: (input) => _bio = input!,
                    ),
                    Container(
                      margin: const EdgeInsets.all(40.0),
                      height: 40.0,
                      width: 250.0,
                      child: FlatButton(
                        onPressed: _submit,
                        color: AppConstants.hexToColor(
                            AppConstants.APP_PRIMARY_COLOR),
                        textColor: AppConstants.hexToColor(
                            AppConstants.APP_PRIMARY_FONT_COLOR_WHITE),
                        child: const Text(
                          'Save Profile',
                          style: TextStyle(fontSize: 18.0),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
