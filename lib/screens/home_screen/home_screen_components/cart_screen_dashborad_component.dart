import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:fast_tech_app/const/color_conts.dart';
import 'package:fast_tech_app/core/i18n/i18n_translate.dart';
import 'package:fast_tech_app/core/models/cart_model.dart';
import 'package:fast_tech_app/core/provider/cart_provider.dart';
import 'package:fast_tech_app/services/order_service/order_service.dart';
import 'package:fast_tech_app/widget/dialog_widget.dart';
import 'package:fast_tech_app/widget/show_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class CartScreenDashboardComponent extends StatefulWidget {
  const CartScreenDashboardComponent({Key? key}) : super(key: key);

  @override
  State<CartScreenDashboardComponent> createState() => _CartScreenDashboardComponentState();
}

class _CartScreenDashboardComponentState extends State<CartScreenDashboardComponent> {
  late Size _size;

  late List<CartModel> _cartModelList;

  void _getCart(int userId) {
    Future.delayed(Duration.zero, () async {
      await orderService.getProductInCart(userId).then((value) => {
            Provider.of<CartModelProvider>(context, listen: false).setCartModel(value),
          });
    });
  }

  void _onRemoveCart(int cartId, int userId) {
    DialogWidget.show(
      context,
      I18NTranslations.of(context).text('do_you_want_to_delete_cart'),
      dialogType: DialogType.QUESTION,
      btnOkText: I18NTranslations.of(context).text('ok'),
      btnCancelText: I18NTranslations.of(context).text('cancel'),
      onOkPress: () {
        orderService.removeCart(cartId).then((value) {
          if (value != '200') {
            DialogWidget.show(context, 'error_remove_cart', dialogType: DialogType.ERROR, onOkPress: () {});
          } else {
            _getCart(userId);
          }
        });
      },
      onCancelPress: () {},
    );
  }

  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.of(context).size;
    _cartModelList = Provider.of<CartModelProvider>(context).cartModelList;
    return Expanded(
      child: Stack(
        children: [
          Column(
            children: [
              _cartQtyWidget(),
              _listCartWidget(),
              const SizedBox(height: 250),
            ],
          ),
          Positioned(bottom: 0, child: _chargeWidget()),
        ],
      ),
    );
  }

  Widget _chargeWidget() {
    double total = 0;
    double totalAfterDiscount = 0;
    double discount = 0;
    _cartModelList.forEach(((element) {
      totalAfterDiscount = (element.product.priceAfterDiscount * element.qty) + totalAfterDiscount;
      discount += (element.product.price - element.product.priceAfterDiscount) * element.qty;
    }));
    total = totalAfterDiscount + discount;
    return Container(
      width: _size.width,
      height: 250,
      color: const Color(0xffFAF9FE),
      child: Column(
        children: [
          Container(width: _size.width, height: 1, color: Colors.black),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  child: Column(
                    children: [
                      Text(I18NTranslations.of(context).text('cart_total')),
                      Text(I18NTranslations.of(context).text('discount')),
                    ],
                  ),
                ),
              ),
              Container(width: 1, height: 60, color: Colors.black),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      r'$' + total.toString(),
                      style: TextStyle(
                        color: ColorsConts.primaryColor,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      r'-$' + discount.toString(),
                      style: const TextStyle(color: Colors.red),
                    )
                  ],
                ),
              ),
            ],
          ),
          Container(width: _size.width, height: 1, color: Colors.black),
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {},
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xffFAF9FE)),
                      color: Colors.blue,
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {},
                        child: Center(
                          child: Text(
                            I18NTranslations.of(context).text('charge'),
                            style: const TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        ),
                      ),
                    ),
                    height: 60,
                  ),
                ),
              ),
              Container(width: 1, height: 60, color: Colors.black),
              Expanded(
                child: Center(
                  child: Text(
                    r'$' + totalAfterDiscount.toString(),
                    style: TextStyle(
                      color: ColorsConts.primaryColor,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Container(width: _size.width, height: 1, color: Colors.black),
        ],
      ),
    );
  }

  Widget _cartQtyWidget() {
    String cartQty = _cartModelList.length.toString();

    return Container(
      margin: const EdgeInsets.only(top: 20),
      width: _size.width,
      height: 60,
      color: Colors.white,
      child: Center(child: Text(I18NTranslations.of(context).text('your_cart') + '\t' + '($cartQty)')),
    );
  }

  Widget _listCartWidget() {
    return Expanded(
        child: SingleChildScrollView(
      child: Column(
        children: List.generate(_cartModelList.length, (index) => _buildCartItem(_cartModelList[index])),
      ),
    ));
  }

  Widget _buildCartItem(CartModel cartModel) {
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.all(8),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            _displayImageWidget(cartModel),
            _displayNameWidget(cartModel),
            _displayPriceWidget(cartModel),
            _qtyWidget(cartModel),
          ]),
        ),
        _removeCartWidget(cartModel.id, cartModel.userId),
      ],
    );
  }

  Widget _removeCartWidget(int cartId, int userId) {
    return InkWell(
      onTap: (() => _onRemoveCart(cartId, userId)),
      child: Container(
        width: 30,
        height: 30,
        decoration: const BoxDecoration(color: Color(0xffFAF9FE), shape: BoxShape.circle),
        child: const Icon(
          Icons.close,
          color: Colors.red,
        ),
      ),
    );
  }

  Widget _qtyWidget(CartModel cartModel) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          _buildQtyChangeButton(false, cartModel),
          const SizedBox(width: 20),
          Text(cartModel.qty.toString()),
          const SizedBox(width: 20),
          _buildQtyChangeButton(true, cartModel),
        ],
      ),
    );
  }

  Widget _buildQtyChangeButton(bool isPlus, CartModel cartModel) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(1000),
      child: Material(
        child: InkWell(
          onTap: () {
            if (isPlus) {
              setState(() {
                cartModel.qty++;
              });
            } else {
              if (cartModel.qty > cartModel.product.minQty) {
                setState(() {
                  cartModel.qty--;
                });
              } else {
                DialogWidget.show(context, I18NTranslations.of(context).text('min_qty') + '\t' + cartModel.product.minQty.toString());
              }
            }
          },
          child: Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(color: Colors.blue.withOpacity(.5), shape: BoxShape.circle),
            child: Center(
              child: Icon(
                isPlus ? FontAwesomeIcons.plus : FontAwesomeIcons.minus,
                size: 10,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _displayPriceWidget(CartModel cartModel) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Visibility(
          visible: cartModel.product.discount != 0,
          child: Text(
            r'$' + cartModel.product.priceAfterDiscount.toString(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: ColorsConts.primaryColor),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          r'$' + cartModel.product.price.toString(),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: cartModel.product.discount.toString() != '0'
              ? const TextStyle(decoration: TextDecoration.lineThrough, fontSize: 15)
              : TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: ColorsConts.primaryColor),
        ),
        const SizedBox(width: 10),
        Visibility(
          visible: cartModel.product.discount != 0,
          child: Text(
            I18NTranslations.of(context).text('discount') + '\t' + cartModel.product.discount.toString() + '%',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.red),
          ),
        ),
      ],
    );
  }

  Widget _displayNameWidget(CartModel cartModel) {
    return Column(
      children: [
        Text(cartModel.product.name),
        Text(
          I18NTranslations.of(context).text('color') + '\t' + cartModel.product.colors[0].color,
          style: const TextStyle(color: Colors.grey),
        ),
      ],
    );
  }

  Widget _displayImageWidget(CartModel cartModel) {
    return SizedBox(
      width: 100,
      height: 100,
      child: DisplayImage(
        imageString: cartModel.product.images[0].image,
        imageBorderRadius: 5,
        boxFit: BoxFit.cover,
      ),
    );
  }
}
