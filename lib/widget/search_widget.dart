import 'package:fast_tech_app/core/i18n/i18n_translate.dart';
import 'package:fast_tech_app/widget/custome_animated_button.dart';
import 'package:flutter/material.dart';

class SearchWidget {
  static Widget searchWidget(
      BuildContext context, Function onsearch, TextEditingController textEditingController, TextEditingController startPriceController, TextEditingController toPriceController) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Container(
                height: 40,
                padding: const EdgeInsets.only(left: 10, right: 10),
                margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.grey.withOpacity(.2),
                  ),
                ),
                child: TextFormField(
                  controller: textEditingController,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(4),
                    border: InputBorder.none,
                    prefixIcon: const Icon(
                      Icons.search,
                      size: 30,
                      color: Colors.black,
                    ),
                    hintText: I18NTranslations.of(context).text('search'),
                  ),
                ),
              ),
            ),
            CustomeAnimatedButton(
              title: I18NTranslations.of(context).text('search'),
              onTap: () {
                onsearch();
              },
              isShowShadow: true,
              width: 100,
              hegith: 40,
              backgroundColor: Colors.blue,
              radius: 10,
            ),
            const SizedBox(width: 5),
          ],
        ),
        Row(
          children: [
            Expanded(child: _buildPriceFilterInput(context, startPriceController, true)),
            Expanded(child: _buildPriceFilterInput(context, toPriceController, false)),
          ],
        )
      ],
    );
  }

  static Widget _buildPriceFilterInput(BuildContext context, TextEditingController controller, bool isStartPrice) {
    return Container(
      height: 40,
      padding: const EdgeInsets.only(left: 10, right: 10),
      margin: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.grey.withOpacity(.2),
        ),
      ),
      child: TextFormField(
        textAlign: TextAlign.center,
        controller: controller,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(4),
          border: InputBorder.none,
          hintText: I18NTranslations.of(context).text(isStartPrice ? 'start.price' : 'to.price'),
        ),
      ),
    );
  }
}
