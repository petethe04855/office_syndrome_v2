// providers/location_provider.dart
import 'package:flutter/material.dart';

class LocationProvider with ChangeNotifier {
  String? selectedProvince;
  String? selectedDistrict;

  Map<String, List<String>> districtsByDistrict = {
    'กรุงเทพมหานคร': [
      'เขตพระนคร',
      'เขตดุสิต',
      'เขตหนองจอก', /* ... รายชื่อเขตอื่นๆ ... */
    ],
    'กรุงเทพมหานคร1': [
      'เขตพระนคร1',
      'เขตดุสิต1',
      'เขตหนองจอก2', /* ... รายชื่อเขตอื่นๆ ... */
    ],
    // เพิ่มจังหวัดอื่น ๆ และเขตตามต้องการ
  };

  List<String> province = ["กรุงเทพมหานคร", "เชียงใหม่", "ขอนแก่น"];

  Map<String, List<String>> city = {
    "กรุงเทพมหานคร": ["พระนคร", "ปทุมวัน", "บางรัก"],
    "เชียงใหม่": ["เมืองเชียงใหม่", "เมืองลำปาง", "เมืองลำพูน"],
    "ขอนแก่น": ["เมืองขอนแก่น", "นาอุดม", "หนองเรือ"],
  };

  Map<String, List<String>> subDistrict = {
    "พระนคร": ["ตลาดยอด", "บ้านพานถม", "วังบูรพา"],
    "ปทุมวัน": ["ลุมพินี", "ป้อมปราบศัตรูพ่าย", "มักกะสัน"],
    "บางรัก": ["สีลม", "สุริยวงศ์", "ทุ่งมหาเมฆ"],
    // Add subdistricts for other districts and provinces
  };

  setselectedProvince(province) {
    selectedProvince = province;
    notifyListeners();
  }

  setselectedDistrict(district) {
    selectedDistrict = district;
    notifyListeners();
  }
  // List<Location> _locations = [
  //   Location(province: 'กรุงเทพ', districts: ['เขต1', 'เขต2', 'เขต3']),
  //   Location(province: '1', districts: ['111', '222', '333']),
  //   Location(province: '2', districts: ['11', '22', '33']),
  //   // เพิ่มจังหวัดและเขตตามต้องการ
  // ];

  // String _selectedProvince = 'เลือกจังหวัด';
  // String _selectedDistrict = 'เลือกเขต';

  // List<String> get provinceNames =>
  //     _locations.map((location) => location.province).toList();

  // List<String> get districtNames {
  //   final selectedLocation = _locations
  //       .firstWhere((location) => location.province == _selectedProvince);

  //   return selectedLocation.districts;
  // }

  // List<Location> get locations => _locations;
  // String get selectedProvince => _selectedProvince;
  // String get selectedDistrict => _selectedDistrict;

  // setSelectedProvince(province) {
  //   _selectedProvince = province;
  //   notifyListeners();
  // }

  // setselectedDistrict(district) {
  //   _selectedDistrict = district;
  //   notifyListeners();
  // }

  // var locations = ["กรุงเทพมหานคร", "เชียงใหม่", "นครปฐม", "นนทบุรี"];
  // List<dynamic> countryValue = [
  //   (
  //     "กรุงเทพมหานคร",
  //     ['1', '2'],
  //   ),
  //   ("เชียงใหม่", ['2']),
  //   ("นครปฐม", ['3']),
  //   ("นนทบุรี", ['4']),
  // ];
  // var selectedCountryValue;
  // var selectedLocation;

  // setCountryValue(value) {
  //   selectedLocation = value;
  //   notifyListeners();
  // }

  // setselectedCountryValue(value) {
  //   selectedCountryValue = value;
  //   notifyListeners();
  // }
}
