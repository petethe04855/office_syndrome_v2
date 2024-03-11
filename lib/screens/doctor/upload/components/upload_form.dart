import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:office_syndrome_v2/components/custom_textfield.dart';
import 'package:office_syndrome_v2/components/rounded_button.dart';
import 'package:office_syndrome_v2/models/brand_category_model.dart';
import 'package:office_syndrome_v2/screens/doctor/upload/components/upload_image.dart';
import 'package:office_syndrome_v2/services/product_service.dart';
import 'package:office_syndrome_v2/services/upload_video_services.dart';
import 'package:video_player/video_player.dart';

class UploadForm extends StatefulWidget {
  const UploadForm({
    Key? key,
  }) : super(key: key);

  @override
  State<UploadForm> createState() => _UploadFormState();
}

class _UploadFormState extends State<UploadForm> {
  final FirebaseAuth _authUser = FirebaseAuth.instance;
  final ProductService _productService = ProductService();
  final formKey = GlobalKey<FormState>();

  final _categoryNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _roundController = TextEditingController();
  VideoPlayerController? _videoController;

  File? _imageFile;

  File? _videoFile; // เพิ่มตัวแปรเก็บไฟล์วิดีโอ

  String? _imageName;

  String? _videoUrl;

  List<BrandCategory> _brands = [];

  String _selectedCategory = "";
  String _selectedCategoryId = "";
  String _selectedCategoryName = "";

  Future<void> _fetchData() async {
    try {
      List<BrandCategory> brands = await _productService.getBrands();

      setState(() {
        _brands = brands;
      });
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  void _pickVideo() async {
    String? videoUrl = await pickVideo();
    if (videoUrl != null) {
      _videoUrl = videoUrl;
      _videoFile = File(videoUrl); // เพิ่มบรรทัดนี้เพื่อเก็บไฟล์วิดีโอ
      _initializeVideoPlayer();
    }
  }

  pickVideo() async {
    final picker = ImagePicker();
    XFile? videoFile;
    try {
      videoFile = await picker.pickVideo(source: ImageSource.gallery);
      return videoFile!.path;
    } catch (e) {
      print('Error Picking Video : $e');
    }
  }

  void _initializeVideoPlayer() {
    if (_videoUrl != null) {
      _videoController = VideoPlayerController.file(File(_videoUrl!))
        ..initialize().then((_) {
          setState(() {});
          _videoController!.play();
        });
    }
  }

  @override
  void initState() {
    _fetchData();
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Padding(
        key: formKey,
        padding: const EdgeInsets.only(top: 16.0, left: 8.0, right: 8.0),
        child: Column(
          children: [
            customTextFieldProduct(
              controller: _categoryNameController,
              obscureText: false,
              hintText: 'ชื่อท่ากายภาพ',
              prefixIcon: null,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'กรุณากรอกชื่อสินค้า';
                }
                return null;
              },
              onSaved: (value) {},
            ),
            const SizedBox(
              height: 20,
            ),
            customTextFieldProduct(
              controller: _descriptionController,
              obscureText: false,
              hintText: 'คำอธิบายท่ากายภาพ',
              prefixIcon: null,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'กรุณากรอกชื่อสินค้า';
                }
                return null;
              },
              onSaved: (value) {},
            ),
            const SizedBox(
              height: 20,
            ),
            customTextFieldProduct(
              controller: _roundController,
              obscureText: false,
              hintText: 'รอบการทำกายภาพ',
              prefixIcon: null,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'กรุณากรอกชื่อสินค้า';
                }
                return null;
              },
              onSaved: (value) {},
            ),
            const SizedBox(
              height: 20,
            ),
            customDropdown(),
            const SizedBox(
              height: 20,
            ),
            Center(
              child: _videoFile != null
                  ? _videoPreviewWiget()
                  : const Text('No video Selected'),
            ),
            ElevatedButton(
              onPressed: () => _pickVideo(),
              child: Text("UpLoadVideo"),
            ),
            const SizedBox(
              height: 20,
            ),
            UploadImage(
              (file) => setState(() {
                _imageFile = file;
              }),
              image: _imageName,
            ),
            const SizedBox(
              height: 20,
            ),
            // customDropdown(),
            RoundedButton(
                label: 'บันทึก',
                onPressed: () {
                  _productService.addToProductCategory(
                    _authUser.currentUser!.uid,
                    _selectedCategoryId,
                    _selectedCategoryName,
                    _categoryNameController.text,
                    _descriptionController.text,
                    _roundController.text,
                    _imageFile,
                    _videoFile,
                  );
                  Navigator.pop(context);
                  print("_imageFile ${_imageFile}");
                  print("_videoFile ${_videoFile}");
                },
                icon: null),
          ],
        ),
      ),
    );
  }

  Widget customDropdown() {
    List<String> _nameCategory =
        _brands.map((category) => category.brandName).toList();

    String initialHint =
        _nameCategory.isNotEmpty ? _nameCategory.first : "Select Category";
    return DropdownButtonFormField<String>(
      hint: Text(initialHint),
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(40),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(40),
        ),
        hintStyle: const TextStyle(color: Colors.grey),
        filled: true,
        isDense: true,
      ),
      items: _brands.map((category) {
        return DropdownMenuItem<String>(
          key: Key(category.brandId),
          child: Text(category.brandName),
          value: category.brandId,
        );
      }).toList(),
      onChanged: (value) async {
        setState(() {
          _selectedCategory = value.toString();
          _selectedCategoryId = value.toString(); // Set selectedRegionId
          _selectedCategoryName = _brands
              .firstWhere((region) => region.brandId == value)
              .brandName; // Set selectedRegion
        });
      },
    );
  }

  Widget _videoPreviewWiget() {
    if (_videoController != null) {
      return AspectRatio(
        aspectRatio: _videoController!.value.aspectRatio,
        child: VideoPlayer(_videoController!),
      );
    } else {
      return const CircularProgressIndicator();
    }
  }

  // Widget customDropdown() {
  //   List<String> _nameRegion =
  //       _regions.map((region) => region.regionName).toList();

  //   return DropdownButtonFormField<String>(
  //     hint: Text(_nameRegion.first),
  //     decoration: InputDecoration(
  //       border: OutlineInputBorder(
  //         borderRadius: BorderRadius.circular(40),
  //       ),
  //       focusedBorder: OutlineInputBorder(
  //         borderRadius: BorderRadius.circular(40),
  //       ),
  //       hintStyle: const TextStyle(color: Colors.grey),
  //       filled: true,
  //       isDense: true,
  //     ),
  //     items: _regions.map((region) {
  //       return DropdownMenuItem<String>(
  //         key: Key(region.regionId),
  //         child: Text(region.regionName),
  //         value: region.regionId,
  //       );
  //     }).toList(),
  //     onChanged: (value) async {
  //       setState(() {
  //         _selectedRegion = value.toString();
  //         _selectedRegionId = value.toString(); // Set selectedRegionId
  //         _selectedRegionName = _regions
  //             .firstWhere((region) => region.regionId == value)
  //             .regionName; // Set selectedRegionName

  //         print('Selected regionId: $_selectedRegionId');
  //         print('Selected regionName: $_selectedRegionName');
  //       });
  //     },
  //   );
  // }
}
