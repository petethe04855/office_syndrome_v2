// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileImage extends StatefulWidget {
  final Function(File? file) callBackSetImage;
  final String? image;

  const EditProfileImage(
    this.callBackSetImage, {
    required this.image,
    Key? key,
  }) : super(key: key);

  @override
  State<EditProfileImage> createState() => _EditProfileImageState();
}

class _EditProfileImageState extends State<EditProfileImage> {
  File? _imageFile;
  final _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    print('_imageFile: $_imageFile');
    print('widget.image: ${widget.image}');
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
              onTap: () => _modalPickerImage(),
              child: _imageFile != null
                  ? CircleAvatar(
                      radius: 60,
                      backgroundImage: FileImage(_imageFile!),
                    )
                  : CircleAvatar(
                      radius: 60,
                      backgroundImage: widget.image != null
                          ? NetworkImage(widget.image!)
                          : null,
                    )),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  void _modalPickerImage() {
    buildListTile(
      IconData icon,
      String title,
      ImageSource source,
    ) =>
        ListTile(
          leading: Icon(icon),
          title: Text(title),
          onTap: () {
            Navigator.of(context).pop();
            _pickImage(source);
          },
        );

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              buildListTile(
                Icons.photo_camera,
                'ถ่ายภาพ',
                ImageSource.camera,
              ),
              buildListTile(
                Icons.photo_library,
                'เลือกจากคลังภาพ',
                ImageSource.gallery,
              ),
            ],
          ),
        );
      },
    );
  }

  void _pickImage(ImageSource source) {
    _picker
        .pickImage(
      source: source,
      imageQuality: 70,
      maxHeight: 500,
      maxWidth: 500,
    )
        .then((file) {
      if (file != null) {
        _cropImage(file.path);
      }
    }).catchError((error) {
      //todo
    });
  }

  void _cropImage(String filePath) {
    ImageCropper()
        .cropImage(
      sourcePath: filePath,

      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ],
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Cropper',
          toolbarColor: Colors.deepOrange,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
        ),
        IOSUiSettings(
          title: 'Cropper',
        ),
        WebUiSettings(
          context: context,
        ),
      ],
      maxWidth: 500,
      maxHeight: 500,

      // circleShape: true
    )
        .then((file) {
      if (file != null) {
        setState(
          () {
            _imageFile = File(file.path);
            widget.callBackSetImage(_imageFile);
          },
        );
      }
    });
  }

  Positioned _buildDeleteImageButton() => Positioned(
        right: -10,
        top: 10,
        child: RawMaterialButton(
          onPressed: () => _deleteImage(),
          fillColor: Colors.white,
          shape: const CircleBorder(
            side: BorderSide(
                width: 1, color: Colors.grey, style: BorderStyle.solid),
          ),
          child: const Icon(Icons.clear),
        ),
      );

  void _deleteImage() {
    setState(
      () {
        _imageFile = null;
        widget.callBackSetImage(null);
      },
    );
  }
}
