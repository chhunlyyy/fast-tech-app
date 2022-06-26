import 'package:fast_tech_app/const/color_conts.dart';
import 'package:fast_tech_app/core/i18n/i18n_translate.dart';
import 'package:fast_tech_app/core/models/pickup_order_model.dart';
import 'package:fast_tech_app/core/provider/pickup_order_provider.dart';
import 'package:fast_tech_app/core/provider/user_model_provider.dart';
import 'package:fast_tech_app/helper/order_status_helper.dart';
import 'package:fast_tech_app/services/order_service/order_service.dart';
import 'package:fast_tech_app/widget/show_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderingScreen extends StatefulWidget {
  const OrderingScreen({Key? key}) : super(key: key);

  @override
  State<OrderingScreen> createState() => _OrderingScreenState();
}

class _OrderingScreenState extends State<OrderingScreen> {
  late Size _size;
  List<PickupOrderModel> _pickupOrderModelList = [];
  int _statusIndex = 0;

  void getPickupOrder(int userId) {
    Future.delayed(Duration.zero, () async {
      await orderService.getPickupOrder(userId).then((value) => {Provider.of<PickupOrderModelProvider>(context, listen: false).setCartModel(value)}).whenComplete(() {
        setState(() {
          _pickupOrderModelList = Provider.of<PickupOrderModelProvider>(context, listen: false).pickupOrderModelList;
        });
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPickupOrder(Provider.of<UserModelProvider>(context, listen: false).userModel!.id);
  }

  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.of(context).size;
    return Material(
      child: Scaffold(
        appBar: AppBar(
            iconTheme: IconThemeData(color: ColorsConts.primaryColor),
            elevation: 0,
            backgroundColor: const Color.fromRGBO(250, 250, 250, 1),
            foregroundColor: ColorsConts.primaryColor,
            title: Text(I18NTranslations.of(context).text('is_buying'))),
        body: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    return SizedBox(
      width: _size.width,
      height: _size.height,
      child: Column(
        children: [
          _switchStatusBarWidget(),
          Expanded(
              child: SingleChildScrollView(
                  child: Column(
            children: List.generate(_pickupOrderModelList.length, (index) => _buildPickupOrderItem(_pickupOrderModelList[index])),
          )))
        ],
      ),
    );
  }

  Widget _switchStatusBarWidget() {
    return Container(
      padding: const EdgeInsets.all(10),
      width: _size.width,
      decoration: BoxDecoration(color: Colors.white, border: Border.all(color: Colors.grey.withOpacity(.2)), boxShadow: [
        BoxShadow(
          blurRadius: 2,
          spreadRadius: 2,
          color: Colors.grey.withOpacity(.5),
        ),
      ]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _statusItem(0),
          _statusItem(1),
        ],
      ),
    );
  }

  Widget _statusItem(int index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color: _statusIndex == index ? Colors.grey.withOpacity(.1) : Colors.white,
        borderRadius: BorderRadius.circular(1000),
        border: Border.all(color: _statusIndex == index ? Colors.blue : Colors.transparent),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(1000),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              setState(() {
                _statusIndex = index;
              });
            },
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Row(
                  children: [
                    Text(
                      I18NTranslations.of(context).text(index == 1 ? 'pick_up' : 'delivery'),
                      style: TextStyle(color: _statusIndex == index ? Colors.blue : Colors.black),
                    ),
                    const SizedBox(width: 20),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(color: Colors.grey, shape: BoxShape.circle),
                      child: Text(
                        _pickupOrderModelList.length.toString(),
                        style: const TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPickupOrderItem(PickupOrderModel pickupOrderModel) {
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.all(8),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            _displayImageWidget(pickupOrderModel),
            _displayNameWidget(pickupOrderModel),
            _displayPriceWidget(pickupOrderModel),
          ]),
        ),
        Positioned(
          bottom: 0,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            color: OrderStatusHelper.getColor(pickupOrderModel.status),
            child: Text(
              I18NTranslations.of(context).text(OrderStatusHelper.getDesc(pickupOrderModel.status)),
              style: const TextStyle(color: Colors.white),
            ),
          ),
        )
      ],
    );
  }

  Widget _displayPriceWidget(PickupOrderModel pickupOrderModel) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(I18NTranslations.of(context).text('qty') + '\t' + pickupOrderModel.qty.toString()),
        Text(
          r'$' + (pickupOrderModel.product.priceAfterDiscount * pickupOrderModel.qty).toString(),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: ColorsConts.primaryColor),
        ),
      ],
    );
  }

  Widget _displayNameWidget(PickupOrderModel pickupOrderModel) {
    return Column(
      children: [
        Text(pickupOrderModel.product.name),
        Text(
          I18NTranslations.of(context).text('color') + '\t' + pickupOrderModel.product.colors[0].color,
          style: const TextStyle(color: Colors.grey),
        ),
      ],
    );
  }

  Widget _displayImageWidget(PickupOrderModel pickupOrderModel) {
    return SizedBox(
      width: 100,
      height: 100,
      child: DisplayImage(
        imageString: pickupOrderModel.product.images[0].image,
        imageBorderRadius: 5,
        boxFit: BoxFit.cover,
      ),
    );
  }
}
