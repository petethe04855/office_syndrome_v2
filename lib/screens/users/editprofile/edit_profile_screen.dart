import 'dart:io';

import 'package:flutter/material.dart';
import 'package:office_syndrome_v2/components/custom_textfield.dart';
import 'package:office_syndrome_v2/components/rounded_button.dart';
import 'package:office_syndrome_v2/providers/data_user_provider.dart';
import 'package:office_syndrome_v2/providers/getdata_provider.dart';

import 'package:office_syndrome_v2/screens/users/editprofile/components/edit_profile_image.dart';
import 'package:provider/provider.dart';

class EditProfileScreen extends StatefulWidget {
  final Map<String, dynamic>? data;
  const EditProfileScreen({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  // Provider.of<GetDataProvider>(context, listen: false).fetchUserData();
  final _EditKey = GlobalKey<FormState>();
  final _fnameController = TextEditingController();
  final _lnameController = TextEditingController();
  File? _imageFile;
  bool isEdit = false;
  bool isButton = false;

  @override
  Widget build(BuildContext context) {
    final _upDataProvider = Provider.of<DataUserProvider>(context);
    Provider.of<GetDataProvider>(context, listen: false).fetchUserData();

    _fnameController.text = widget.data!['first_name'];
    _lnameController.text = widget.data!['last_name'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _EditKey,
            child: Column(
              children: [
                EditProfileImage(
                  (file) => setState(() {
                    _imageFile = file;
                  }),
                  image: widget.data!['images'],
                ),
                const SizedBox(
                  height: 10,
                ),
                customTextFieldEdit(
                  controller: _fnameController,
                  hintText: 'First Name',
                  prefixIcon: const Icon(Icons.person),
                  obscureText: false,
                  enabledText: isEdit,
                  validator: (value) {},
                ),
                const SizedBox(
                  height: 10,
                ),
                customTextFieldEdit(
                  controller: _lnameController,
                  hintText: 'Last Name',
                  prefixIcon: const Icon(Icons.abc),
                  obscureText: false,
                  enabledText: isEdit,
                  validator: (value) {},
                ),
                const SizedBox(
                  height: 10,
                ),
                RoundedButton(
                  label: isEdit ? 'Save' : 'Edit',
                  onPressed: () {
                    if (isEdit) {
                      // Handle Save logic here
                      _upDataProvider.updateUserData(
                        _fnameController.text,
                        _lnameController.text,
                        _imageFile,
                      );
                      Navigator.pop(context);
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) =>
                      //             const DashboardScreen()));
                    } else {
                      setState(() {
                        isEdit = !isEdit;
                      });
                    }
                  },
                  icon: null,
                ),

                // RoundedButton(
                //   label: 'Save',
                //   onPressed: () {
                //     // _upDataProvider.updateUserData(
                //     //   _fnameController.text,
                //     //   _lnameController.text,
                //     //   _imageFile,
                //     // );
                //     Navigator.pop(context);
                //   },
                //   icon: null,
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
