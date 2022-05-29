import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_shop/screens/home.dart';
import 'package:my_shop/widgets/custom_button.dart';

import '../controllers/home_controller.dart';

class Bill extends StatelessWidget {
  const Bill({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MainController controller = Get.find();
    return Scaffold(
      appBar: AppBar(
        title: Text('Bill'),
      ),
      body: Center(
        child: Container(
          alignment: Alignment.center,
          width: 300,
          height: 350,
          child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: controller.carts.value.length,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                elevation: 2,
                child: Column(
                  children: [
                    Image(
                      image: NetworkImage(controller.carts.value[index].image!),
                      width: 200,
                      height: 200,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text('Name: ' +
                          controller.carts.value[index].name!.toString()),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text('Price: ' +
                          controller.carts.value[index].price!.toString()),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text('Quantity: ' +
                          controller.carts.value[index].count.toString()),
                    ),
                    controller.check
                        ? SizedBox()
                        : Text('Delivery price: 2000'),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CustomTextButton(
                          lable: 'Go Home',
                          ontap: () {
                            controller.carts.value.clear();
                            Get.offAll(() => HomePage());
                          },
                          color: Colors.indigo),
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
