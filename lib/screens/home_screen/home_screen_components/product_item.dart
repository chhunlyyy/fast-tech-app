import 'package:fast_tech_app/const/color_conts.dart';
import 'package:fast_tech_app/core/i18n/i18n_translate.dart';
import 'package:fast_tech_app/core/models/product_model.dart';
import 'package:fast_tech_app/widget/placholder_image_wdiget.dart';
import 'package:fast_tech_app/widget/show_image_widget.dart';
import 'package:flutter/material.dart';

class ProductItem extends StatelessWidget {
  final ProductModel productModel;
  const ProductItem({Key? key, required this.productModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [
        BoxShadow(offset: const Offset(1, 1), color: Colors.grey.withOpacity(.5), blurRadius: 2),
      ]),
      margin: const EdgeInsets.all(8),
      width: MediaQuery.of(context).size.width / 2 - 50,
      height: 220,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              // NavigationHelper.push(
              //     context,
              //     ProductDetail(
              //       onDispose: onDispose,
              //       productModel: productModel,
              //       mainStore: mainStore,
              //     ));
            },
            child: Column(
              children: [
                Stack(
                  children: [
                    Container(
                        width: MediaQuery.of(context).size.width / 2,
                        height: 160,
                        child: productModel.images.isNotEmpty
                            ? Hero(
                                tag: productModel.images[0],
                                child: DisplayImage(
                                  boxFit: BoxFit.fitHeight,
                                  imageBorderRadius: 20,
                                  imageString: productModel.images[0].image,
                                ),
                              )
                            : const PlaceholderImageWidget(),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                        )),
                    Visibility(
                      visible: productModel.discount != 0,
                      child: SizedBox(
                        height: 170,
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(color: Colors.red, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2)),
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                productModel.discount.toString() + '%',
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  productModel.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  I18NTranslations.of(context).text('min_qty') + '\t' + productModel.minQty.toString(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.grey.withOpacity(.8)),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        r'$' + productModel.price.toString(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: productModel.discount.toString() != '0'
                            ? const TextStyle(decoration: TextDecoration.lineThrough)
                            : TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: ColorsConts.primaryColor),
                      ),
                      Visibility(
                        visible: productModel.discount != 0,
                        child: Text(
                          r'$' + productModel.priceAfterDiscount.toString(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: ColorsConts.primaryColor),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
