import 'package:fast_tech_app/core/i18n/i18n_translate.dart';
import 'package:flutter/material.dart';

class ChangeOrderStatusBottomSheet {
  static void show(BuildContext context, var orderModel, {bool isPackage = false, bool isPickUp = true}) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return SizedBox(
            height: MediaQuery.of(context).size.height / 2,
            child: ChangeOrderStatusWidget(
              orderModel: orderModel,
              isPacakge: isPackage,
              isPickUp: isPickUp,
            ),
          );
        });
  }
}

class ChangeOrderStatusWidget extends StatefulWidget {
  final bool isPacakge;
  final bool isPickUp;
  final orderModel;
  const ChangeOrderStatusWidget({Key? key, required this.isPickUp, required this.isPacakge, required this.orderModel}) : super(key: key);

  @override
  State<ChangeOrderStatusWidget> createState() => _ChangeOrderStatusWidgetState();
}

class _ChangeOrderStatusWidgetState extends State<ChangeOrderStatusWidget> {
  // void getPackageOrder(int userId) {
  //   Future.delayed(Duration.zero, () async {
  //     await orderService.getPackageOrder(userId, false).then((value) {
  //       Provider.of<PackageOrderModelProvider>(context, listen: false).setPackageupOrderModel(value);
  //     });
  //   });
  // }

  // void getPickupOrder(int userId) {
  //   Future.delayed(Duration.zero, () async {
  //     await orderService.getPickupOrder(userId, false).then((value) {
  //       Provider.of<PickupOrderModelProvider>(context, listen: false).setPickupOrderModel(value);
  //     });
  //   });
  // }

  // void getDeliveryOrder(int userId) {
  //   Future.delayed(Duration.zero, () async {
  //     await orderService.getDeliveryOrder(userId, false).then((value) {
  //       Provider.of<DeliveryOrderModelProvider>(context, listen: false).setDeliveryModel(value);
  //     });
  //   });
  // }

  void _onChangeStatus(int status) {
    // int userId = Provider.of<UserModelProvider>(context, listen: false).userModel!.id;

    // orderService.updateOrderStatus(widget.orderModel.id.toString(), status, widget.isPacakge ? 1 : 0).then((value) {
    //   if (value == '200') {
    //     userService.getToken(widget.orderModel.user.phone.toString(), status);
    //     DialogWidget.show(context, I18NTranslations.of(context).text('change_status_success'), dialogType: DialogType.SUCCES);
    //     getDeliveryOrder(userId);
    //     getPickupOrder(userId);
    //     getPackageOrder(userId);
    //     Future.delayed(const Duration(seconds: 2)).whenComplete(() {
    //       Navigator.pop(context);
    //     }).whenComplete(() {
    //       Future.delayed(const Duration(milliseconds: 200)).whenComplete(() {
    //         Navigator.pop(context);
    //       });
    //     });
    //   } else {
    //     DialogWidget.show(context, I18NTranslations.of(context).text('change_status_error'), dialogType: DialogType.ERROR);
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30),
            Text(I18NTranslations.of(context).text('user_name') + '\t:\t' + widget.orderModel.user.name),
            Text(I18NTranslations.of(context).text('phone_number') + '\t:\t' + widget.orderModel.user.phone),
            Text(I18NTranslations.of(context).text('product_name') + '\t:\t' + widget.orderModel.product.name),
            !widget.isPacakge ? Text(I18NTranslations.of(context).text('qty') + '\t:\t' + widget.orderModel.qty.toString()) : const SizedBox.shrink(),
            !widget.isPacakge
                ? Text(I18NTranslations.of(context).text('total') + '\t:\t' + r'$' + (widget.orderModel.product.priceAfterDiscount * widget.orderModel.qty).toString())
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }

  Widget _buildItem(String i18ntext, Color color, int status) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 60,
      color: color,
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _onChangeStatus(status),
          child: Center(
              child: Text(
            I18NTranslations.of(context).text(i18ntext),
            style: const TextStyle(color: Colors.white),
          )),
        ),
      ),
    );
  }
}
