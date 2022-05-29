import 'package:cached_network_image/cached_network_image.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:my_shop/controllers/home_controller.dart';
import 'package:my_shop/model/cart_model.dart';
import 'package:my_shop/widgets/CustomTextStyle.dart';
import 'package:my_shop/widgets/custom_textfield.dart';
import 'package:my_shop/widgets/snackbar.dart';

import '../constants.dart';
import '../model/product_model.dart';

class Details extends StatelessWidget {
  Details({
    Key? key,
    required this.data1,
  }) : super(key: key);
  final Product data1;
  TextEditingController size = TextEditingController();
  @override
  Widget build(BuildContext context) {
    String color = data1.color![0].toString();
    final data = MediaQuery.of(context);
    final width = data.size.width;
    final height = data.size.height;
    return Scaffold(
        body: ListView(
      children: [
        Stack(
          children: [
            Stack(
              children: [
                Container(
                  // decoration: BoxDecoration(
                  //     // borderRadius: const BorderRadius.only(
                  //     //     bottomLeft: Radius.circular(17),
                  //     //     bottomRight: Radius.circular(17)),
                  //     image: DecorationImage(
                  //   image: NetworkImage(data1.image!),
                  //   fit: BoxFit.cover,
                  // )),
                  height: data.size.height * 0.5,
                  child: CachedNetworkImage(
                    fit: BoxFit.cover,
                    imageUrl: data1.image!,
                    progressIndicatorBuilder:
                        (context, url, downloadProgress) => Center(
                      child: CircularProgressIndicator(
                          value: downloadProgress.progress),
                    ),
                    errorWidget: (context, url, error) =>
                        (const Icon(Icons.error)),
                    width: 1000,
                    height: 190,
                  ),
                ),
                SizedBox(
                  height: data.size.height * 0.5,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(17),
                          bottomRight: Radius.circular(17)),
                      // gradient: LinearGradient(
                      //   begin: Alignment.topCenter,
                      //   end: Alignment.bottomCenter,
                      //   colors: [
                      //     Colors.transparent,
                      //     Colors.black.withOpacity(0.7),
                      //   ],
                      // ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: data.size.height * 0.50,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: width * 0.07, vertical: height * .07),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Get.back();
                          },
                          child: const Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Padding(
          // alignment: Alignment.bottomCenter,
          padding: const EdgeInsets.all(15),
          child: Container(
            // height: data.size.height,
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: Center(
              child: Form(
                // key: logic.formKey2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            data1.name!,
                            style: Theme.of(context).textTheme.headline6,
                          ),
                        ),
                        const SizedBox(width: defaultPadding),
                        Text(
                          data1.price.toString() + '\$',
                          style: CustomTextStyle.textFormFieldBlack
                              .copyWith(color: Colors.green),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: defaultPadding),
                      child: Text(
                        data1.description.toString(),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: defaultPadding),
                      child: TextFormField(
                          controller: size,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'please enter field';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            errorBorder: const UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.red, width: 3.0),
                            ),
                            focusedBorder: const UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.white, width: 2.0),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.black.withOpacity(.7),
                                  width: 1.0),
                            ),
                            prefixIcon: Icon(Icons.numbers),

                            labelText: 'size',

                            labelStyle: const TextStyle(color: Colors.black),
                            // hintText: hint,
                            hintStyle: const TextStyle(color: Colors.black),
                          ),
                          keyboardType: TextInputType.text),
                    ),
                    Text(
                      "Colors",
                      style: Theme.of(context).textTheme.subtitle2,
                    ),
                    const SizedBox(height: defaultPadding / 2),
                    DropdownSearch<String>(
                      mode: Mode.BOTTOM_SHEET,
                      showSelectedItems: true,
                      items: List.generate(data1.color!.length,
                          (index) => data1.color![index].toString()),
                      dropdownSearchDecoration: const InputDecoration(
                        labelText: "Product color",
                        hintText: "select product type",
                      ),
                      onChanged: (value) {
                        color = value!;
                      },
                      selectedItem: data1.color![0].toString(),
                    ),
                    const SizedBox(height: defaultPadding * 2),
                    Center(
                      child: SizedBox(
                        width: 200,
                        height: 48,
                        child: GetBuilder<MainController>(
                          builder: (logic) {
                            return ElevatedButton(
                              onPressed: () {
                                if (size.text.isNotEmpty) {
                                  bool ch = false;
                                  var res =
                                      logic.carts.value.forEach((element) {
                                    if (element.name == data1.name) {
                                      ch = true;
                                    }
                                  });
                                  if (ch) {
                                    showbar('Add To  Cart', 'subtitle',
                                        'ALREADY ADDED', true);
                                  } else {
                                    logic.carts.value.add(Cart(
                                        count: 1,
                                        type: data1.type,
                                        price: data1.price,
                                        color: color,
                                        image: data1.image,
                                        name: data1.name,
                                        description: data1.description,
                                        number: data1.number,
                                        size: size.text));
                                    logic.totalPrice += data1.price!;
                                    showbar('Add To  Cart', 'subtitle',
                                        'Added Successfully', true);
                                  }
                                } else {
                                  showbar(
                                      'add Size', 'subtitle', 'desc', false);
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.indigo,
                                  shape: const StadiumBorder()),
                              child: const Text("Add to Cart"),
                            );
                          },
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    ));
  }
}
