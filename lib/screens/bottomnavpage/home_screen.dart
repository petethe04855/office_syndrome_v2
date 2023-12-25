import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:office_syndrome_v2/app_router.dart';
import 'package:office_syndrome_v2/screens/products/components/product_form.dart';
import 'package:office_syndrome_v2/themes/colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Card(
              color: primaryLight,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Container(
                      height: 200,
                      decoration: BoxDecoration(
                          image: const DecorationImage(
                              image: AssetImage(
                                  'assets/images/1701790858283.jpeg'),
                              fit: BoxFit.cover),
                          borderRadius: BorderRadius.circular(15)),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Text("ชื่ออหัวข้อ", style: TextStyle(fontSize: 24)),
                      ],
                    ),
                    Text("data--------------------------")
                  ],
                ),
              ),
            ),
            Card(
              color: primaryLight,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, AppRouter.productItem);
                        },
                        child: Text(
                          "แสดงทั้งหมด",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 200,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: 10,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: OpenContainer(
                                transitionType: ContainerTransitionType.fade,
                                // transitionDuration กำหนดควาามเร็ว animation
                                transitionDuration: Duration(milliseconds: 600),
                                closedBuilder: (context, action) {
                                  return _listItemHomeScreen();
                                },
                                openBuilder: (context, index) {
                                  return ProductForm();
                                },
                              ),
                            );
                          },
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

  Widget _listItemHomeScreen() {
    return Container(
      height: 300,
      width: 200,
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: AssetImage('assets/images/noavartar.png'),
        ),
        subtitle: Text("subtitle"),
        title: Text("title"),
        trailing: Icon(Icons.chevron_right),
      ),
    );
  }
}
