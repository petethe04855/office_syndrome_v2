import 'package:flutter/material.dart';
import 'package:office_syndrome_v2/models/product_category_model.dart';
import 'package:office_syndrome_v2/screens/doctor/upload/components/upload_form.dart';

class UploadAdd extends StatefulWidget {
  const UploadAdd({super.key});

  @override
  State<UploadAdd> createState() => _UploadAddState();
}

class _UploadAddState extends State<UploadAdd> {
  final _formKeyAddProduct = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('UploadAdd'),
          actions: [
            //Save Button
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.save),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [UploadForm()],
          ),
        ));
  }
}
