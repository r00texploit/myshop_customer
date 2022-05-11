import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_shop/constants.dart';
import 'package:my_shop/controllers/home_controller.dart';

import '../../widgets/feature_item.dart';
import '../details.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.indigo,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics()),
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: defaultPadding,
            ),
            Text(
              "Best $title for you !!!",
              style: TextStyle(fontSize: 18, color: Colors.black),
            ),
            SizedBox(
              height: defaultPadding * 4,
            ),
            getFeature()
          ],
        ),
      ),
    );
  }

  getFeature() {
    return GetBuilder<MainController>(
      builder: (logic) {
        return logic.pro.isEmpty
            ? Center(
                child: Text('No Available $title'),
              )
            : CarouselSlider(
                options: CarouselOptions(
                  height: 300,
                  enlargeCenterPage: true,
                  disableCenter: true,
                  viewportFraction: .75,
                ),
                items: List.generate(
                  logic.pro.length,
                  (index) => FeatureItem(
                    data: logic.pro[index],
                    onTapFavorite: () {},
                    onTap: () {
                      Get.to(() => Details(
                            data1: logic.pro[index],
                          ));
                    },
                  ),
                ),
              );
      },
    );
  }
}
