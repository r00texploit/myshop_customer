import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_shop/screens/details.dart';
import 'package:my_shop/screens/gender_page.dart';
import 'package:my_shop/widgets/bottom_nav_bar.dart';

import '../controllers/home_controller.dart';
import '../widgets/collection_box.dart';
import '../widgets/new_item.dart';
import '../widgets/popular_item.dart';
import 'color.dart';
import 'data.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  MainController controller = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.indigo,
          title: Text('Home Screen'),
          centerTitle: true,
        ),
        backgroundColor: appBgColor,
        bottomNavigationBar: BottomNavigation(),
        body: CustomScrollView(
          slivers: [
            // SliverAppBar(
            //   backgroundColor: appBarColor,
            //   pinned: true,
            //   snap: true,
            //   floating: true,
            //   title: getAppBar(),
            // ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => buildBody(),
                childCount: 1,
              ),
            )
          ],
        ));
  }

  Widget getAppBar() {
    return Container(
      color: Colors.indigo,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Icon(
                  //   Icons.shopping_cart,
                  //   color: labelColor,
                  //   size: 20,
                  // ),
                  // SizedBox(
                  //   width: 5,
                  // ),
                  // Text(
                  //   'My Shop',
                  //   style: TextStyle(
                  //     color: labelColor,
                  //     fontSize: 13,
                  //   ),
                  // ),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Text("Best Product for you !!!",
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  )),
            ],
          )),
        ],
      ),
    );
  }

  buildBody() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 0, bottom: 10),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(
            height: 20,
          ),
          getCollections(),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 0, 15, 25),
            child: Text("Popular",
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 24,
                )),
          ),
          getPopulars(),
          SizedBox(
            height: 20,
          ),
          // Container(
          //   margin: EdgeInsets.only(left: 15, right: 15, bottom: 10, top: 10),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: [
          //       Text(
          //         "New",
          //         style: TextStyle(
          //             fontSize: 22,
          //             fontWeight: FontWeight.w600,
          //             color: textColor),
          //       ),
          //       // Text(
          //       //   "See all",
          //       //   style: TextStyle(fontSize: 14, color: darker),
          //       // ),
          //     ],
          //   ),
          // ),
          // getNewItems(),
        ]),
      ),
    );
  }

  getCollections() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(10),
      scrollDirection: Axis.horizontal,
      child: Row(
          children: List.generate(
              collections.length,
              (index) => Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: GestureDetector(
                      onTap: () {
                        controller
                            .getProductByGender(collections[index]['title']);
                        Get.to(() =>
                            GenderPage(title: collections[index]['title']));
                      },
                      child: CollectionBox(data: collections[index]))))),
    );
  }

  getPopulars() {
    return Obx(() {
      return CarouselSlider(
          options: CarouselOptions(
            autoPlay: true,
            height: 370,
            enlargeCenterPage: true,
            disableCenter: true,
            viewportFraction: .75,
          ),
          items: List.generate(
            controller.products.length,
            (index) => PopularItem(
              data: controller.products[index],
              onTap: () {
                Get.to(() => Details(data1: controller.products[index]));
              },
            ),
          ));
    });
  }

  getNewItems() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(10),
      scrollDirection: Axis.horizontal,
      child: Row(
          children: List.generate(
              news.length,
              (index) => Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: NewItem(
                    data: news[index],
                    onTap: () {},
                  )))),
    );
  }
}
