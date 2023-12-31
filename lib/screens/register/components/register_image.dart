// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:office_syndrome_v2/services/firbase_auth_services.dart';

class RegisterImage extends StatefulWidget {
  final Function(File? file) callBackSetImage;
  final String? image;

  const RegisterImage(
    this.callBackSetImage, {
    required this.image,
    Key? key,
  }) : super(key: key);

  @override
  State<RegisterImage> createState() => _RegisterImageState();
}

class _RegisterImageState extends State<RegisterImage> {
  File? _imageFile;
  final _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () => _modalPickerImage(),
            child: CircleAvatar(
              radius: 60,
              backgroundImage:
                  _imageFile != null ? FileImage(_imageFile!) : null,
              child: _imageFile == null ? Icon(Icons.person) : null,
            ),
          ),
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
