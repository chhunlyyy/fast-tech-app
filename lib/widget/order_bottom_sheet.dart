import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:fast_tech_app/const/color_conts.dart';
import 'package:fast_tech_app/core/i18n/i18n_translate.dart';
import 'package:fast_tech_app/core/models/cart_model.dart';
import 'package:fast_tech_app/core/provider/cart_provider.dart';
import 'package:fast_tech_app/core/provider/user_model_provider.dart';
import 'package:fast_tech_app/helper/navigation_helper.dart';
import 'package:fast_tech_app/screens/map_screen/user_map.dart';
import 'package:fast_tech_app/screens/order_screen/ordering_screen.dart';
import 'package:fast_tech_app/services/order_service/order_service.dart';
import 'package:fast_tech_app/widget/dialog_widget.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class OrderBottomSheet {
  void show(BuildContext context, List<CartModel> cartModelList, Map<String, dynamic> params) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.5,
            child: OrderBottomSheetBody(cartModelList: cartModelList, params: params),
          );
        });
  }
}

class OrderBottomSheetBody extends StatefulWidget {
  final Map<String, dynamic>? params;
  final List<CartModel>? cartModelList;
  const OrderBottomSheetBody({Key? key, required this.cartModelList, required this.params}) : super(key: key);

  @override
  State<OrderBottomSheetBody> createState() => _OrderBottomSheetBodyState();
}

class _OrderBottomSheetBodyState extends State<OrderBottomSheetBody> {
  void _onOrder(Map<String, dynamic> params) {
    orderService.order(params).then((value) {
      if (value == '200') {
        DialogWidget.show(context, I18NTranslations.of(context).text('order_success'), dialogType: DialogType.SUCCES);
        Future.delayed(const Duration(seconds: 2)).whenComplete(() {
          Navigator.pop(context);
          Navigator.pop(context);
          NavigationHelper.push(context, const OrderingScreen());
        });
      } else {
        DialogWidget.show(context, I18NTranslations.of(context).text('order_error'), dialogType: DialogType.ERROR);
      }
    });
  }

  void _onTap(bool isDelivery) {
    if (isDelivery) {
      NavigationHelper.push(context, const UserMapScreen());
    } else {
      if (widget.cartModelList!.isEmpty) {
        widget.params!['delivery_type'] = 0;
        _onOrder(widget.params!);
      } else {
        try {
          for (var cartModel in widget.cartModelList!) {
            Map<String, dynamic> params = {
              'user_id': Provider.of<UserModelProvider>(context, listen: false).userModel!.id,
              'product_id': cartModel.productId,
              'color_id': cartModel.colorId,
              'qty': cartModel.qty,
              'delivery_type': 0,
              'status': 0,
              'is_buy_from_cart': 0,
              'address_id_ref': const Uuid().v4(),
            };
            orderService.order(params);
          }
          DialogWidget.show(context, I18NTranslations.of(context).text('order_success'), dialogType: DialogType.SUCCES);

          Future.delayed(const Duration(seconds: 2)).whenComplete(() {
            Future.delayed(const Duration(milliseconds: 300)).whenComplete(() {
              Navigator.pop(context);
              Navigator.pop(context);
            }).whenComplete(() {
              getCart(Provider.of<UserModelProvider>(context, listen: false).userModel!.id);
              NavigationHelper.push(context, const OrderingScreen());
            });
          });
        } catch (e) {
          DialogWidget.show(context, I18NTranslations.of(context).text('order_error'), dialogType: DialogType.ERROR);
        }
      }
    }
  }

  void getCart(int userId) {
    Future.delayed(Duration.zero, () async {
      await orderService.getProductInCart(userId).then((value) => {
            Provider.of<CartModelProvider>(context, listen: false).setCartModel(value),
          });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        _line(),
        _itemWidget(true),
        _line(),
        _itemWidget(false),
        _line(),
      ],
    );
  }

  Widget _line() {
    return Container(width: MediaQuery.of(context).size.width, height: 1, color: Colors.grey);
  }

  Widget _itemWidget(bool isDelivery) {
    return Material(
      child: InkWell(
        onTap: () {
          _onTap(isDelivery);
        },
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Icon(
                isDelivery ? FontAwesomeIcons.motorcycle : FontAwesomeIcons.shop,
                color: isDelivery ? ColorsConts.primaryColor : Colors.blue,
              ),
              Text(
                I18NTranslations.of(context).text(isDelivery ? 'delivery' : 'pick_up'),
                style: TextStyle(color: isDelivery ? ColorsConts.primaryColor : Colors.blue, fontSize: 18),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
