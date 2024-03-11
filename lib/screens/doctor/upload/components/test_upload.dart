import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class TestUpload extends StatefulWidget {
  const TestUpload({super.key});

  @override
  State<TestUpload> createState() => _TestUploadState();
}

class _TestUploadState extends State<TestUpload> {
  final _picker = ImagePicker();
  final _storage = FirebaseStorage.instance;

  String? _videoPath;
  UploadTask? _uploadTask;

  Future<void> _pickVideo() async {
    final video = await _picker.pickVideo(source: ImageSource.gallery);
    if (video != null) {
      setState(() {
        _videoPath = video.path;
      });
    }
  }

  Future<void> _uploadVideo() async {
    if (_videoPath == null) return;

    final file = File(_videoPath!);
    final ref = _storage
        .ref()
        .child('videos/${DateTime.now().microsecondsSinceEpoch}.mp4');

    setState(() {
      _uploadTask = ref.putFile(file);
    });

    final snapshot = await _uploadTask!.whenComplete(() => null);
    final url = await snapshot.ref.getDownloadURL();

    // บันทึก URL วิดีโอลงในฐานข้อมูล
    // ...
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Upload Video')),
      body: Column(
        children: [
          if (_videoPath != null)
            VideoPlayer(VideoPlayerController.file(File(_videoPath!))),
          ElevatedButton(onPressed: _pickVideo, child: Text('เลือกวิดีโอ')),
          if (_uploadTask != null) LinearProgressIndicator(),
          ElevatedButton(onPressed: _uploadVideo, child: Text('อัปโหลดวิดีโอ')),
        ],
      ),
    );
  }
}
