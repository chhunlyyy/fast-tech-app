import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:fast_tech_app/const/color_conts.dart';
import 'package:fast_tech_app/core/i18n/i18n_translate.dart';
import 'package:fast_tech_app/core/models/product_model.dart';
import 'package:fast_tech_app/core/models/user_model.dart';
import 'package:fast_tech_app/core/provider/cart_provider.dart';
import 'package:fast_tech_app/core/provider/user_model_provider.dart';
import 'package:fast_tech_app/helper/navigation_helper.dart';
import 'package:fast_tech_app/screens/home_screen/home_screen.dart';
import 'package:fast_tech_app/services/order_service/order_service.dart';
import 'package:fast_tech_app/widget/custome_animated_button.dart';
import 'package:fast_tech_app/widget/dialog_widget.dart';
import 'package:fast_tech_app/widget/order_bottom_sheet.dart';
import 'package:fast_tech_app/widget/show_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class AddToCartBottomSheet {
  void show(BuildContext context, ProductModel productModel) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.8,
            child: AddToCartBottomSheetBody(
              productModel: productModel,
            ),
          );
        });
  }
}

class AddToCartBottomSheetBody extends StatefulWidget {
  final ProductModel productModel;

  const AddToCartBottomSheetBody({Key? key, required this.productModel}) : super(key: key);

  @override
  State<AddToCartBottomSheetBody> createState() => _AddToCartBottomSheetBodyState();
}

class _AddToCartBottomSheetBodyState extends State<AddToCartBottomSheetBody> {
  ColorModel? _seletedColor;
  late int _qty;

  late UserModel _userModel;

  void _getCart() {
    Future.delayed(Duration.zero, () async {
      await orderService.getProductInCart(_userModel.id).then((value) => {
            Provider.of<CartModelProvider>(context, listen: false).setCartModel(value),
          });
    });
  }

  void _onAddToCart() {
    if (_seletedColor == null) {
      DialogWidget.show(context, I18NTranslations.of(context).text('plz_choose_color'), dialogType: DialogType.WARNING, onOkPress: () {});
    } else {
      Future.delayed(Duration.zero, () async {
        await orderService.addToCart(widget.productModel.id, _userModel.id, _qty, _seletedColor!.id).then((value) {
          _getCart();

          DialogWidget.show(
            context,
            value == '200' ? I18NTranslations.of(context).text('add_to_cart_success') : I18NTranslations.of(context).text('add_to_cart_failt'),
            dialogType: value == '200' ? DialogType.SUCCES : DialogType.ERROR,
            btnCancelText: I18NTranslations.of(context).text('continou_buying'),
            btnOkText: I18NTranslations.of(context).text('go_to_cart'),
            onCancelPress: () {
              Future.delayed(const Duration(milliseconds: 400)).whenComplete(() => Navigator.pop(context));
            },
            onOkPress: () => NavigationHelper.push(
                context,
                const HomeScreen(
                  dasboardEnum: DASBOARD_ENUM.cart,
                )),
          );
        });
      });
    }
  }

  void _onQtyChange(bool isPlus) {
    if (isPlus) {
      setState(() {
        _qty++;
      });
    } else {
      if (_qty > widget.productModel.minQty) {
        setState(() {
          _qty--;
        });
      } else {
        DialogWidget.show(context, I18NTranslations.of(context).text('min_qty') + '\t' + widget.productModel.minQty.toString());
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _qty = widget.productModel.minQty;
  }

  @override
  Widget build(BuildContext context) {
    _userModel = Provider.of<UserModelProvider>(context).userModel!;
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              _imageWidget(),
              _priceWidget(),
            ]),
            _line(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(I18NTranslations.of(context).text('choose_color')),
            ),
            _colorWidget(),
            const SizedBox(height: 10),
            _line(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(I18NTranslations.of(context).text('choose_qty')),
            ),
            _qtyWidget(),
            _actionButtonWidget(),
          ],
        ),
      ),
    );
  }

  Widget _actionButtonWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [_buildActionButton(false), _buildActionButton(true)],
      ),
    );
  }

  Widget _buildActionButton(bool isBuy) {
    return CustomeAnimatedButton(
      title: I18NTranslations.of(context).text(isBuy ? 'buy_now' : 'to_cart'),
      onTap: () {
        if (isBuy) {
          if (_seletedColor == null) {
            DialogWidget.show(context, I18NTranslations.of(context).text('plz_choose_color'), dialogType: DialogType.WARNING, onOkPress: () {});
          } else {
            Map<String, dynamic> params = {
              'user_id': Provider.of<UserModelProvider>(context, listen: false).userModel!.id,
              'product_id': widget.productModel.id,
              'color_id': _seletedColor!.id,
              'qty': _qty,
              'delivery_type': 1,
              'status': 0,
              'is_buy_from_cart': 1,
              'address_id_ref': const Uuid().v4(),
            };
            Navigator.pop(context);
            Future.delayed(const Duration(milliseconds: 200)).whenComplete(() {
              if (mounted) {
                OrderBottomSheet().show(context, [], params);
              }
            });
          }
        } else {
          _onAddToCart();
        }
      },
      isShowShadow: true,
      width: MediaQuery.of(context).size.width / 2.1,
      hegith: 50,
      backgroundColor: isBuy ? Colors.blue : Colors.green,
    );
  }

  Widget _qtyWidget() {
    int totalPrice = _qty * widget.productModel.priceAfterDiscount;

    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          _buildQtyChangeButton(false),
          const SizedBox(width: 10),
          Text(_qty.toString()),
          const SizedBox(width: 10),
          _buildQtyChangeButton(true),
          const SizedBox(width: 30),
          Text(
            I18NTranslations.of(context).text('total_price'),
            style: const TextStyle(color: Colors.black, fontSize: 20),
          ),
          Text(
            '\t' + totalPrice.toString() + r'$',
            style: TextStyle(color: ColorsConts.primaryColor, fontSize: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildQtyChangeButton(bool isPlus) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(1000),
      child: Material(
        child: InkWell(
          onTap: () => _onQtyChange(isPlus),
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(color: Colors.grey.withOpacity(.5), shape: BoxShape.circle),
            child: Center(
              child: Icon(
                isPlus ? FontAwesomeIcons.plus : FontAwesomeIcons.minus,
                size: 18,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _colorWidget() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(5)),
      child: DropdownButton<ColorModel>(
        underline: const SizedBox.shrink(),
        hint: Text(I18NTranslations.of(context).text('choose_color')),
        value: _seletedColor,
        style: const TextStyle(color: Colors.white),
        isExpanded: true,
        items: widget.productModel.colors.map((ColorModel colorModel) {
          return DropdownMenuItem<ColorModel>(value: colorModel, child: Container(margin: const EdgeInsets.all(5), color: Color(int.parse(colorModel.colorCode))));
        }).toList(),
        onChanged: (newValue) {
          setState(() {
            _seletedColor = newValue;
          });
        },
      ),
    );
  }

  Widget _line() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 1,
      color: Colors.grey.withOpacity(.5),
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    );
  }

  Widget _imageWidget() {
    return Container(
      padding: const EdgeInsets.all(5),
      margin: const EdgeInsets.all(10),
      width: 130,
      height: 130,
      decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(5)),
      child: DisplayImage(
        imageString: widget.productModel.images[0].image,
        boxFit: BoxFit.fill,
        imageBorderRadius: 5,
      ),
    );
  }

  Widget _priceWidget() {
    return Container(
      margin: const EdgeInsets.all(10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Visibility(
                visible: widget.productModel.discount != 0,
                child: Text(
                  r'$' + widget.productModel.priceAfterDiscount.toString(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold, color: ColorsConts.primaryColor),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                r'$' + widget.productModel.price.toString(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: widget.productModel.discount.toString() != '0'
                    ? const TextStyle(decoration: TextDecoration.lineThrough, fontSize: 20)
                    : TextStyle(fontSize: 35, fontWeight: FontWeight.bold, color: ColorsConts.primaryColor),
              ),
              const SizedBox(width: 10),
              Visibility(
                visible: widget.productModel.discount != 0,
                child: Text(
                  I18NTranslations.of(context).text('discount') + '\t' + widget.productModel.discount.toString() + '%',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
          Text(
            I18NTranslations.of(context).text('min_qty') + '\t' + widget.productModel.minQty.toString(),
            style: const TextStyle(color: Colors.grey),
          )
        ],
      ),
    );
  }
}
