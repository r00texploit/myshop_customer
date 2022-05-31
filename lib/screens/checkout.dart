import 'package:cupertino_stepper/cupertino_stepper.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:my_shop/controllers/auth_controller.dart';
import 'package:my_shop/controllers/home_controller.dart';
import 'package:my_shop/screens/Bill.dart';
import 'package:my_shop/screens/bay_by_bank.dart';
import 'package:my_shop/screens/cart.dart';
import 'package:my_shop/widgets/custom_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_shop/widgets/custom_textfield.dart';
import 'package:my_shop/widgets/snackbar.dart';

class CheckOut extends StatelessWidget {
  const CheckOut({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StepperPage();
  }
}

class StepperPage extends StatefulWidget {
  @override
  _StepperPageState createState() => _StepperPageState();
}

class _StepperPageState extends State<StepperPage> {
  int currentStep = 0;
  static FirebaseAuth auth = FirebaseAuth.instance;
  String? uid = auth.currentUser!.uid;
  String? number = auth.currentUser!.phoneNumber;
  TextEditingController rePrice = TextEditingController();
  TextEditingController bankName = TextEditingController();
  TextEditingController accountType = TextEditingController();
  TextEditingController accountNumber = TextEditingController();
  TextEditingController cardNumber = TextEditingController();
  TextEditingController price = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  List<String> ch = ['Pay by bank', 'cash payment'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CheckOut'),
        backgroundColor: Colors.indigo,
      ),
      body: SafeArea(
        child: OrientationBuilder(
          builder: (BuildContext context, Orientation orientation) {
            return GetBuilder<MainController>(builder: (context) {
              return _buildStepper(StepperType.vertical);
            });
          },
        ),
      ),
    );
  }

  CupertinoStepper _buildStepper(StepperType type) {
    MainController controller = Get.find();
    AuthController logic = Get.find();
    final canCancel = currentStep > 0;
    final canContinue = currentStep < 3;
    String delivery;
    // int number = controller.users[0].number!;
    DateTime time = DateTime.now().add(Duration(days: 2));
    return CupertinoStepper(
      type: type,
      currentStep: currentStep,
      onStepTapped: (int step) {
        setState(() {
          currentStep = step;
        });
      },
      onStepCancel: () {
        currentStep > 0 ? setState(() => currentStep -= 1) : null;
      },
      onStepContinue: () {
        currentStep < 2 ? setState(() => currentStep += 1) : null;
      },
      steps: [
        Step(
          title: Text('Delivery'),
          content: LimitedBox(
            maxWidth: 300,
            maxHeight: 300,
            child: Column(
              children: [
                Text(
                  'Choose Delivery Company:  ',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                SizedBox(
                  height: 40,
                ),
                DropdownSearch<String>(
                  mode: Mode.BOTTOM_SHEET,
                  showSelectedItems: true,
                  items: List.generate(controller.delivery.length,
                      (index) => controller.delivery[index].name.toString()),
                  dropdownSearchDecoration: const InputDecoration(
                    labelText: "Deliveries Company",
                    hintText: "select Deliveries Company",
                  ),
                  onChanged: (value) {
                    delivery = value!;
                  },
                  selectedItem: controller.delivery[0].name.toString(),
                ),
                SizedBox(
                  height: 40,
                ),
                Text(
                    'Delivered Time: ' +
                        DateFormat.yMd().format(time).toString() +
                        '  ' +
                        DateFormat.jm().format(time).toString(),
                    style: TextStyle(fontWeight: FontWeight.bold)),
                GetBuilder<AuthController>(
                  builder: (_) {
                    return Text(
                        'Your Number: ' + _.users.first.number.toString(),
                        style: TextStyle(fontWeight: FontWeight.bold));
                  },
                ),
                // DropdownSearch<String>(
                //   mode: Mode.BOTTOM_SHEET,
                //   showSelectedItems: true,
                //   items: ch,
                //   dropdownSearchDecoration: const InputDecoration(
                //     labelText: "Dlivery",
                //     hintText: "select product type",
                //   ),
                //   onChanged: (value) {
                //     controller.check = true;
                //     controller.update();
                //   },
                //   selectedItem: ch[0],
                // ),
                // CustomTextButton(
                //     lable: 'Without delivery',
                //     ontap: () {
                //       showbar('delivery', 'subtitle', 'without delivery', true);
                //       controller.check = true;
                //       controller.update();
                //     },
                //     color: Colors.indigo)
              ],
            ),
          ),
          isActive: currentStep >= 0,
          state: currentStep == 0 ? StepState.editing : StepState.complete,
        ),
        Step(
          title: Text('Summary'),
          content: Column(
            children: [
              LimitedBox(
                maxWidth: 300,
                maxHeight: 280,
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
                            image: NetworkImage(
                                controller.carts.value[index].image!),
                            width: 200,
                            height: 200,
                          ),
                          Text('Name: ' +
                              controller.carts.value[index].name!.toString()),
                          Text('Price: ' +
                              controller.carts.value[index].price!.toString()),
                          // Text('Quantity: ' +
                          //     controller.carts.value[index].count.toString()),
                          // controller.check
                          //     ? SizedBox()
                          //     : Text('Delivery price: 2000')
                        ],
                      ),
                    );
                  },
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'Full Price:  ' + '${controller.totalPrice.value + 200}',
                style: TextStyle(fontWeight: FontWeight.bold),
              )
            ],
          ),
          isActive: currentStep >= 1,
          state: currentStep == 1
              ? StepState.editing
              : currentStep < 1
                  ? StepState.disabled
                  : StepState.complete,
        ),
        Step(
          title: Text('Make Payment'),
          content: Column(
            children: [
              CustomTextButton(
                  lable: 'Make Payment by Bank',
                  ontap: () {
                    Get.to(() => BayByBank());
                    // if (controller.check) {
                    //   controller.makePayment(controller.totalPrice.toInt());
                    // } else {
                    //   if (formKey.currentState!.validate()) {
                    //     controller.makePayment(controller.totalPrice.toInt());
                    //   }
                    // }
                  },
                  color: Colors.indigo),
              SizedBox(
                height: 20,
              ),
              CustomTextButton(
                  lable: 'Make Payment By Cash',
                  ontap: () {
                    Get.to(() => Bill());

                    // if (controller.check) {
                    //   controller.makePayment(controller.totalPrice.toInt());
                    // } else {
                    //   if (formKey.currentState!.validate()) {
                    //     controller.makePayment(controller.totalPrice.toInt());
                    //   }
                    // }
                  },
                  color: Colors.indigo),
            ],
          ),
        )
      ],
    );
  }
}
