import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:fast_tech_app/const/color_conts.dart';
import 'package:fast_tech_app/core/i18n/i18n_translate.dart';
import 'package:fast_tech_app/core/models/product_model.dart';
import 'package:fast_tech_app/core/provider/cart_provider.dart';
import 'package:fast_tech_app/core/provider/user_role_provider.dart';
import 'package:fast_tech_app/helper/navigation_helper.dart';
import 'package:fast_tech_app/helper/token_helper.dart';
import 'package:fast_tech_app/screens/add_new_product_screen/add_new_product_screen.dart';
import 'package:fast_tech_app/screens/home_screen/home_screen.dart';
import 'package:fast_tech_app/screens/login_screen/login_screen/login.dart';
import 'package:fast_tech_app/services/product_service/product_service.dart';
import 'package:fast_tech_app/widget/add_to_cart_bottom_sheet.dart';
import 'package:fast_tech_app/widget/custome_animated_button.dart';
import 'package:fast_tech_app/widget/dialog_widget.dart';
import 'package:fast_tech_app/widget/show_full_scren_image_widget.dart';
import 'package:fast_tech_app/widget/show_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductDetail extends StatefulWidget {
  final ProductModel productModel;
  const ProductDetail({Key? key, required this.productModel}) : super(key: key);

  @override
  _ProductDetailState createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  late int _imagePageCount = widget.productModel.images.isNotEmpty ? 1 : 0;

  void _onDelete() {
    productService.delete(widget.productModel.idRef.toString()).then((value) {
      if (value == '200') {
        DialogWidget.show(context, I18NTranslations.of(context).text('delete_sucessfully'), dialogType: DialogType.SUCCES);

        Future.delayed(const Duration(seconds: 2)).whenComplete(() {
          NavigationHelper.pushReplacement(context, const HomeScreen(dasboardEnum: DASBOARD_ENUM.homeScreen));
        });
      } else {
        DialogWidget.show(context, I18NTranslations.of(context).text('delete_unsucessfully'), dialogType: DialogType.ERROR);
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: SafeArea(
            child: Stack(
      children: [
        Column(
          children: [
            _appBar(),
            Expanded(
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _imageWidget(),
                      _nameLabel(),
                      const SizedBox(height: 10),
                      _detailWidget(),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: (context.watch<UserRoleProvider>().isAdmin || context.watch<UserRoleProvider>().isSuperAdmin) ? _adminActionButton() : _addToCartWidget(),
        ),
      ],
    )));
  }

  Widget _appBar() {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(top: 10),
      height: 60,
      child: Row(
        children: [
          Container(
            margin: const EdgeInsets.only(left: 10),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: Icon(
                          Icons.arrow_back_ios,
                          size: 25,
                          color: ColorsConts.primaryColor,
                        ),
                      ),
                    ),
                  ),
                )),
            width: 60,
            height: 60,
            decoration: BoxDecoration(color: Colors.grey.withOpacity(.1), shape: BoxShape.circle),
          ),
          Expanded(child: Container()),
          context.watch<UserRoleProvider>().isAdmin || context.watch<UserRoleProvider>().isSuperAdmin ? const SizedBox.shrink() : _cartWidget(),
          const SizedBox(width: 20),
        ],
      ),
    );
  }

  Widget _cartWidget() {
    return Stack(
      children: [
        Container(
            width: 60,
            height: 60,
            decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(1000),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => NavigationHelper.push(context, const HomeScreen(dasboardEnum: DASBOARD_ENUM.cart)),
                  child: Icon(
                    Icons.shopping_cart,
                    size: 30,
                    color: ColorsConts.primaryColor,
                  ),
                ),
              ),
            )),
        Positioned(
          right: 15,
          child: Container(
            width: 20,
            height: 20,
            decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
            child: Text(
              Provider.of<CartModelProvider>(context).cartModelList.length.toString(),
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red, fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }

  Widget _detailWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _priceWidget(),
        widget.productModel.colors.isNotEmpty ? _label(I18NTranslations.of(context).text('color')) : const SizedBox.shrink(),
        widget.productModel.colors.isNotEmpty ? _colorWidget() : const SizedBox.shrink(),
        widget.productModel.colors.isNotEmpty ? _label(I18NTranslations.of(context).text('detail')) : const SizedBox.shrink(),
        widget.productModel.colors.isNotEmpty ? _detail() : const SizedBox.shrink(),
      ],
    );
  }

  Widget _colorWidget() {
    List<Widget> colorItemList = [];
    for (var element in widget.productModel.colors) {
      colorItemList.add(_colorItem(element.color, Color(int.parse(element.colorCode))));
    }

    const double runSpacing = 4;
    const double spacing = 4;

    return SingleChildScrollView(
      child: Wrap(
        runSpacing: runSpacing,
        spacing: spacing,
        alignment: WrapAlignment.center,
        children: List.generate(colorItemList.length, (index) {
          return colorItemList[index];
        }),
      ),
    );
  }

  Widget _detail() {
    return Column(
        children: widget.productModel.details.map((e) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(e.detail + '\t:\t', style: TextStyle(color: ColorsConts.primaryColor)),
            Expanded(child: Text(e.descs)),
          ],
        ),
      );
    }).toList());
  }

  Widget _colorItem(String color, Color? colorCode) {
    return Container(
      width: 100,
      height: 100,
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: colorCode ?? Colors.transparent, border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(5)),
      child: Center(
        child: Text(
          color,
          style: const TextStyle(color: Colors.white),
        ),
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

  Widget _label(String title) {
    return Container(
      padding: const EdgeInsets.only(bottom: 20),
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20, bottom: 5, top: 20),
                child: Text(
                  title,
                  style: const TextStyle(color: Colors.blue),
                ),
              ),
            ],
          ),
          Container(
            height: 1,
            color: Colors.blue,
          )
        ],
      ),
    );
  }

  Widget _nameLabel() {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(color: Colors.grey.withOpacity(.3), offset: const Offset(0, 1), spreadRadius: 2, blurRadius: 2),
      ]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Center(
              child: Text(
                widget.productModel.name,
                style: const TextStyle(color: Colors.black, fontSize: 18),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Visibility(
            visible: widget.productModel.isWarranty == 1,
            child: Container(
              padding: const EdgeInsets.only(left: 10, right: 10),
              decoration: BoxDecoration(
                  color: Colors.red, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.grey.withOpacity(.5), offset: const Offset(0, 1), spreadRadius: 1, blurRadius: 2)]),
              child: Text(
                I18NTranslations.of(context).text('warranty') + '\t' + widget.productModel.warrantyPeriod,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
    );
  }

  Widget _imageWidget() {
    return Stack(
      children: [
        SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 3,
            child: widget.productModel.images.isNotEmpty
                ? CarouselSlider(
                    options: CarouselOptions(
                      onPageChanged: (index, reson) {
                        setState(() {
                          _imagePageCount = index + 1;
                        });
                      },
                      enableInfiniteScroll: false,
                    ),
                    items: widget.productModel.images
                        .map((item) => InkWell(
                              onTap: () => NavigationHelper.push(context, ShowFullScreenImageWidget(image: item.image)),
                              child: Container(
                                margin: const EdgeInsets.all(5),
                                child: Hero(
                                  tag: widget.productModel.images[widget.productModel.images.indexOf(item)],
                                  child: DisplayImage(
                                    imageString: item.image,
                                    imageBorderRadius: 0,
                                    boxFit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            ))
                        .toList(),
                  )
                : Container()),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height / 3,
          child: Align(
            alignment: Alignment.bottomRight,
            child: Container(
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(color: ColorsConts.primaryColor, borderRadius: BorderRadius.circular(20)),
                child: Text(
                  _imagePageCount.toString() + ' / ' + widget.productModel.images.length.toString(),
                  style: const TextStyle(color: Colors.white),
                )),
          ),
        )
      ],
    );
  }

  Widget _adminActionButton() {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
      Container(
        margin: const EdgeInsets.only(bottom: 10),
        child: CustomeAnimatedButton(
          title: I18NTranslations.of(context).text('edit'),
          onTap: () {
            NavigationHelper.push(context, AddNewProductScreen(productModel: widget.productModel));
          },
          isShowShadow: true,
          width: MediaQuery.of(context).size.width / 2 - 20,
          hegith: 50,
          backgroundColor: Colors.blue,
        ),
      ),
      Container(
        margin: const EdgeInsets.only(bottom: 10),
        child: CustomeAnimatedButton(
          title: I18NTranslations.of(context).text('delete'),
          onTap: () {
            DialogWidget.show(context, I18NTranslations.of(context).text('delete_product_question'), dialogType: DialogType.QUESTION, onCancelPress: () {}, onOkPress: _onDelete);
          },
          isShowShadow: true,
          width: MediaQuery.of(context).size.width / 2 - 20,
          hegith: 50,
          backgroundColor: Colors.red,
        ),
      )
    ]);
  }

  Widget _addToCartWidget() {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: CustomeAnimatedButton(
        title: I18NTranslations.of(context).text('to_cart'),
        onTap: () {
          TokenHelper.getInstance().isLogedIn()
              ? AddToCartBottomSheet().show(context, widget.productModel)
              : DialogWidget.show(
                  context,
                  I18NTranslations.of(context).text('plz_login'),
                  onCancelPress: () {},
                  onOkPress: () => NavigationHelper.push(
                    context,
                    const LoginScreen(
                      fromLogout: false,
                      fromAddToCart: true,
                    ),
                  ),
                  dialogType: DialogType.INFO,
                  btnCancelText: I18NTranslations.of(context).text('cancel'),
                  btnOkText: I18NTranslations.of(context).text('login'),
                );
        },
        isShowShadow: true,
        width: MediaQuery.of(context).size.width - 20,
        hegith: 50,
        backgroundColor: ColorsConts.primaryColor,
      ),
    );
  }
}
