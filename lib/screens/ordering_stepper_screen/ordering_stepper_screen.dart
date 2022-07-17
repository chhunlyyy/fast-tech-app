import 'package:fast_tech_app/const/color_conts.dart';
import 'package:fast_tech_app/core/i18n/i18n_translate.dart';
import 'package:fast_tech_app/helper/order_status_helper.dart';
import 'package:fast_tech_app/widget/show_image_widget.dart';
import 'package:flutter/material.dart';

class OrderingStepperScreen extends StatefulWidget {
  final orderModel;
  final bool isPackage;
  final bool isPickup;
  const OrderingStepperScreen({Key? key, required this.orderModel, required this.isPackage, required this.isPickup}) : super(key: key);

  @override
  State<OrderingStepperScreen> createState() => _OrderingStepperScreenState();
}

class _OrderingStepperScreenState extends State<OrderingStepperScreen> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: ColorsConts.primaryColor),
          elevation: 0,
          backgroundColor: const Color.fromRGBO(250, 250, 250, 1),
          foregroundColor: ColorsConts.primaryColor,
        ),
        body: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    return Column(
      children: [
        _detailWidget(),
        const Spacer(),
        _stepperWidget(),
      ],
    );
  }

  Widget _stepperWidget() {
    return Container(
      padding: const EdgeInsets.all(50),
      decoration: BoxDecoration(color: ColorsConts.primaryColor.withOpacity(.3), borderRadius: const BorderRadius.only(topLeft: Radius.circular(50), topRight: Radius.circular(50))),
      width: MediaQuery.of(context).size.width,
      child: Stepper(
        currentStep: 1,
        onStepCancel: null,
        onStepContinue: null,
        onStepTapped: null,
        steps: !widget.isPickup
            ? [
                Step(title: Text(I18NTranslations.of(context).text(OrderStatusHelper.getDesc(0))), content: const SizedBox.shrink(), isActive: widget.orderModel.status == 0),
                Step(title: Text(I18NTranslations.of(context).text(OrderStatusHelper.getDesc(1))), content: const SizedBox.shrink(), isActive: widget.orderModel.status == 1),
                Step(title: Text(I18NTranslations.of(context).text(OrderStatusHelper.getDesc(2))), content: const SizedBox.shrink(), isActive: widget.orderModel.status == 2),
                Step(title: Text(I18NTranslations.of(context).text(OrderStatusHelper.getDesc(3))), content: const SizedBox.shrink(), isActive: widget.orderModel.status == 3),
              ]
            : [
                Step(title: Text(I18NTranslations.of(context).text(OrderStatusHelper.getDesc(0))), content: const SizedBox.shrink(), isActive: widget.orderModel.status == 0),
                Step(title: Text(I18NTranslations.of(context).text(OrderStatusHelper.getDesc(1))), content: const SizedBox.shrink(), isActive: widget.orderModel.status == 1),
                Step(title: Text(I18NTranslations.of(context).text(OrderStatusHelper.getDesc(3))), content: const SizedBox.shrink(), isActive: widget.orderModel.status == 3),
              ],
        controlsBuilder: (BuildContext context, ControlsDetails controlsDetails) {
          return Row(
            children: <Widget>[
              Container(),
            ],
          );
        },
      ),
    );
  }

  Widget _detailWidget() {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(color: ColorsConts.primaryColor.withOpacity(.5), borderRadius: BorderRadius.circular(20)),
      child: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(child: Center(child: Text(I18NTranslations.of(context).text('user_name') + '\t:\t' + widget.orderModel.user.name))),
            Expanded(child: Center(child: Text(I18NTranslations.of(context).text('phone_number') + '\t:\t' + widget.orderModel.user.phone))),
          ],
        ),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(color: Colors.white38, borderRadius: BorderRadius.circular(20)),
          child: Column(children: [
            Row(
              children: [
                SizedBox(
                  width: 80,
                  height: 80,
                  child: DisplayImage(
                    imageString: widget.orderModel.product.images[0].image,
                    imageBorderRadius: 1,
                    boxFit: BoxFit.cover,
                  ),
                ),
                Expanded(
                    child: Center(
                  child: Text(widget.orderModel.product.name),
                )),
              ],
            ),
            const SizedBox(height: 10),
            !widget.isPackage
                ? Row(
                    children: [
                      Expanded(
                          child: Center(
                        child: Column(
                          children: [
                            Text(I18NTranslations.of(context).text('qty')),
                            Text(widget.orderModel.qty.toString()),
                          ],
                        ),
                      )),
                      Expanded(
                          child: Center(
                        child: Column(
                          children: [
                            Text(I18NTranslations.of(context).text('total_price')),
                            Text((widget.orderModel.qty * widget.orderModel.product.priceAfterDiscount).toString()),
                          ],
                        ),
                      )),
                    ],
                  )
                : const SizedBox.shrink(),
          ]),
        ),
      ]),
    );
  }
}
