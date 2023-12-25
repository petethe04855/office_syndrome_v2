// ignore_for_file: avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:office_syndrome_v2/themes/colors.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget webChild;
  final Widget mobileChild;

  const ResponsiveLayout(
      {Key? key, required this.webChild, required this.mobileChild})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          // ปิดคีย์บอร์ดเมื่อกดที่พื้นที่อื่น
          FocusScope.of(context).unfocus();
        },
        child: Container(
          decoration: BoxDecoration(color: primary),
          child: Center(
            child: SingleChildScrollView(
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Card(
                    color: primaryLight,
                    elevation: 12,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),

                    // Using for responsive layout
                    child: LayoutBuilder(builder: (
                      BuildContext context,
                      BoxConstraints constraints,
                    ) {
                      // เราจะใช้ constraints มาเช็คว่าหน้าจอของเรามีขนาดเท่าไหร่
                      Widget childWidget = mobileChild;
                      if (constraints.maxWidth > 800) {
                        childWidget = webChild;
                      }
                      return childWidget;
                    }),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
