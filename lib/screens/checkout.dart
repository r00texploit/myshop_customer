import 'package:cupertino_stepper/cupertino_stepper.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:my_shop/controllers/home_controller.dart';
import 'package:my_shop/widgets/custom_button.dart';

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
            switch (orientation) {
              case Orientation.portrait:
                return _buildStepper(StepperType.vertical);
              case Orientation.landscape:
                return _buildStepper(StepperType.horizontal);
              default:
                throw UnimplementedError(orientation.toString());
            }
          },
        ),
      ),
    );
  }

  CupertinoStepper _buildStepper(StepperType type) {
    MainController controller = Get.find();
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
                Text('Your Number: ' + controller.number.toString(),
                    style: TextStyle(fontWeight: FontWeight.bold))
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
                          Text('Quantity: ' +
                              controller.carts.value[index].count.toString())
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
                'Full Price:  ' + controller.totalPrice.toString(),
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
          content: LimitedBox(
            maxWidth: 300,
            maxHeight: 300,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Full Price :' + controller.totalPrice.toString()),
                Text('Your Salary: ' + '50000000000'),
                CustomTextButton(
                    lable: 'Make Payment',
                    ontap: () {
                      controller.makePayment(controller.totalPrice.toInt());
                    },
                    color: Colors.indigo)
              ],
            ),
          ),
          isActive: currentStep >= 2,
          state: currentStep == 2
              ? StepState.editing
              : currentStep < 2
                  ? StepState.disabled
                  : StepState.complete,
        ),
      ],
    );
  }
}
