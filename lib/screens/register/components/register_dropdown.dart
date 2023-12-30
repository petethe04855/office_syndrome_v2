import 'package:flutter/material.dart';
import 'package:office_syndrome_v2/providers/location_provider%20.dart';

class RegisterDropdown extends StatefulWidget {
  const RegisterDropdown({super.key});

  @override
  State<RegisterDropdown> createState() => _RegisterDropdownState();
}

class _RegisterDropdownState extends State<RegisterDropdown> {
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      hint: Text('เลือกจังหวัด'),
      onChanged: (value) {},
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(40),
        ),
      ),
      items: LocationProvider().province.map((String province) {
        return DropdownMenuItem<String>(
          value: province,
          child: Text(province),
        );
      }).toList(),
    );
  }
}
