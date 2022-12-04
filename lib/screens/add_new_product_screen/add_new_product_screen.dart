import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:fast_tech_app/const/color_conts.dart';
import 'package:fast_tech_app/core/i18n/i18n_translate.dart';
import 'package:fast_tech_app/core/models/camera_type_model.dart';
import 'package:fast_tech_app/core/models/product_insert_model.dart';
import 'package:fast_tech_app/core/models/product_model.dart';
import 'package:fast_tech_app/helper/file_picker_widget.dart';
import 'package:fast_tech_app/helper/navigation_helper.dart';
import 'package:fast_tech_app/screens/add_new_product_screen/get_camera_type_bottom_sheet.dart';
import 'package:fast_tech_app/screens/home_screen/home_screen.dart';
import 'package:fast_tech_app/services/product_service/product_service.dart';
import 'package:fast_tech_app/services/tricker_firebase_service/tricker_firebase_service.dart';
import 'package:fast_tech_app/widget/custome_animated_button.dart';
import 'package:fast_tech_app/widget/dialog_widget.dart';
import 'package:fast_tech_app/widget/show_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:uuid/uuid.dart';
import 'package:fast_tech_app/core/models/product_model.dart' as productModel;

class AddNewProductScreen extends StatefulWidget {
  final ProductModel? productModel;
  const AddNewProductScreen({Key? key, this.productModel}) : super(key: key);

  @override
  State<AddNewProductScreen> createState() => _AddNewProductScreenState();
}

class _AddNewProductScreenState extends State<AddNewProductScreen> {
  var key = GlobalKey();
  bool _isWrranty = false;
  bool _isCamera = true;
  Color defaultColor = Colors.black;
  bool _isLoading = false;
  //
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _discountController = TextEditingController();
  final TextEditingController _priceAfterDiscoutnController = TextEditingController();
  final TextEditingController _warrantyPeriodController = TextEditingController();

  final TextEditingController _minQtyController = TextEditingController();
  //
  int _colorLength = 1;
  List<Color> _color = [Colors.black];
  List<TextEditingController> _colorName = List.generate(1, (index) => TextEditingController(text: 'ខ្មៅ'));
  //
  /*  image */
  List<File> productImages = [];

  List<ImageModel> deletedImage = [];
  /* */
  final List<productModel.ColorModel> _deletedColor = [];

  final List<productModel.DetailModel> _deletedDetail = [];

  /*  detail post data */
  int _detailLength = 1;
  List<TextEditingController> _detailNameControllerList = List.generate(1, (index) => TextEditingController());
  List<TextEditingController> _detailDescControllerList = List.generate(1, (index) => TextEditingController());
  /* */

  final TextEditingController _cameraTypeController = TextEditingController();

  List<CameraTypeModel> cameratypeModel = [];

  late CameraTypeModel _seletedCameraType;

  /*
   * add proudct function 
   */

  void _loadCameratype() {
    Future.delayed(Duration.zero, () async {
      await productService.getCameraTypeModels().then((value) {
        setState(() {
          cameratypeModel = value;
        });
      });
    });
  }

  void _onUpdate() async {
    if (_checkValidation(true)) {
      ProductInsertModel productInsertModel = ProductInsertModel(
          widget.productModel!.idRef,
          _nameController.text,
          double.parse(_priceController.text),
          double.parse(_discountController.text),
          _isWrranty ? 1 : 0,
          int.parse(_minQtyController.text),
          double.parse(_priceAfterDiscoutnController.text),
          _isWrranty ? _warrantyPeriodController.text : 'no warranty',
          _isCamera ? 1 : 0,
          _cameraTypeController.text.isEmpty ? null : _seletedCameraType.id);
      setState(() {
        _isLoading = true;
      });

      String productStatus = await productService.insertProduct(1, productInsertModel);
      String colorStatus = await _updateColor();
      String detailStatus = await _updateDetail();
      String imageStatus = await _updateImage();

      Future.delayed(const Duration(seconds: 2)).whenComplete(() {
        setState(() {
          _isLoading = false;
        });
        if (productStatus == '200' && colorStatus == "200" && detailStatus == '200' && imageStatus == '200') {
          DialogWidget.show(context, I18NTranslations.of(context).text('update-successfully'), dialogType: DialogType.SUCCES);

          Future.delayed(const Duration(seconds: 2)).whenComplete(() async {
            await productService.getProductById(widget.productModel!.id).then((value) {
              NavigationHelper.push(
                  context,
                  const HomeScreen(
                    dasboardEnum: DASBOARD_ENUM.homeScreen,
                  ));
            });
          });
        } else {
          DialogWidget.show(context, I18NTranslations.of(context).text('update-unsuccessfully'), dialogType: DialogType.ERROR);
        }
      });
    }
  }

  /* */

  Future<String> _updateImage() async {
    String status = '';
    if (deletedImage.isEmpty && productImages.isEmpty) {
      status = '200';
    }
    if (deletedImage.isNotEmpty) {
      for (var element in deletedImage) {
        await productService.deleteImage(element.id.toString()).then((value) {
          status = value;
        });
      }
    }
    if (productImages.isNotEmpty) {
      await productService.insertImage(productImages, widget.productModel!.idRef).then((value) {
        status = value;
      });
    }

    return status;
  }

  Future<String> _updateDetail() async {
    String status = '';
    // delete deleted detail
    if (_deletedDetail.isNotEmpty) {
      for (var detail in _deletedDetail) {
        await productService.deleteDetail(detail.id.toString()).then((value) {
          status = value;
        });
      }
    }
    // update detail

    if (widget.productModel!.details.isNotEmpty) {
      for (int i = 0; i < widget.productModel!.details.length; i++) {
        await productService
            .insertDetail(
          widget.productModel!.details[i].id.toString(),
          widget.productModel!.details[i].productIdRef,
          _detailNameControllerList[i].text,
          _detailDescControllerList[i].text,
          1,
        )
            .then((value) {
          status = value;
        });
      }
    }
    // add new color

    if (_detailLength > widget.productModel!.details.length) {
      int length = _detailLength - widget.productModel!.details.length;
      for (int i = 0; i < length; i++) {
        int index = (widget.productModel!.details.length - 1) + 1;
        await productService
            .insertDetail(
          null,
          widget.productModel!.details[i].productIdRef,
          _detailNameControllerList[index].text,
          _detailDescControllerList[index].text,
          0,
        )
            .then((value) {
          status = value;
        });
      }
    }

    return status;
  }

  Future<String> _updateColor() async {
    String status = '';
    // delete deleted color
    if (_deletedColor.isNotEmpty) {
      for (var color in _deletedColor) {
        await productService.deleteColor(color.id.toString()).then((value) {
          status = value;
        });
      }
    }
    // update color

    if (widget.productModel!.colors.isNotEmpty) {
      for (int i = 0; i < widget.productModel!.colors.length; i++) {
        await productService
            .insertColor(
          widget.productModel!.colors[i].id,
          widget.productModel!.colors[i].productIdRef,
          _colorName[i].text,
          '0x' + _color[i].value.toRadixString(16),
          1,
        )
            .then((value) {
          status = value;
        });
      }
    }
    // add new color

    if (_colorLength > widget.productModel!.colors.length) {
      int length = _colorLength - widget.productModel!.colors.length;
      for (int i = 0; i < length; i++) {
        int index = (widget.productModel!.colors.length - 1) + 1;
        await productService
            .insertColor(
          null,
          widget.productModel!.colors[i].productIdRef,
          _colorName[index].text,
          '0x' + _color[index].value.toRadixString(16),
          0,
        )
            .then((value) {
          status = value;
        });
      }
    }

    return status;
  }
  /* */

  void _addProduct() async {
    String idRef = const Uuid().v1();

    if (_checkValidation(false)) {
      ProductInsertModel productInsertModel = ProductInsertModel(
          idRef,
          _nameController.text,
          double.parse(_priceController.text),
          double.parse(_discountController.text),
          _isWrranty ? 1 : 0,
          int.parse(_minQtyController.text),
          double.parse(_priceAfterDiscoutnController.text),
          _isWrranty ? _warrantyPeriodController.text : 'no warranty',
          _isCamera ? 1 : 0,
          _cameraTypeController.text.isEmpty ? null : _seletedCameraType.id);

      await productService.insertProduct(0, productInsertModel).then((value) async {
        String colorStatus = await _addColor(idRef);
        String detailStatus = await _addDetail(idRef);
        String imageStatus = await _addImage(idRef);
        setState(() {
          _isLoading = true;
        });

        Future.delayed(const Duration(seconds: 2)).whenComplete(() {
          setState(() {
            _isLoading = false;
          });
          if (value == '200' && colorStatus == "200" && detailStatus == '200' && imageStatus == '200') {
            DialogWidget.show(
              context,
              I18NTranslations.of(context).text('insert_product_success'),
              dialogType: DialogType.SUCCES,
              onCancelPress: () => NavigationHelper.push(context, const HomeScreen(dasboardEnum: DASBOARD_ENUM.homeScreen)),
              onOkPress: () => NavigationHelper.pushReplacement(context, const AddNewProductScreen()),
              btnOkText: I18NTranslations.of(context).text('add_more'),
              btnCancelText: I18NTranslations.of(context).text('go_to_home_screen'),
            );
          } else {
            DialogWidget.show(context, I18NTranslations.of(context).text('insert_product_unsuccess'), dialogType: DialogType.ERROR);
          }
        });
      });
    } else {
      DialogWidget.show(context, I18NTranslations.of(context).text('plz_insert_all_info'), dialogType: DialogType.WARNING);
    }
  }

  Future<String> _addColor(String idRef) async {
    String status = '';

    for (int i = 0; i < _colorLength; i++) {
      await productService.insertColor(null, idRef, _colorName[i].text, '0x' + _color[i].value.toRadixString(16), 0).then((value) {
        status = value;
      });
    }

    return status;
  }

  Future<String> _addDetail(String idRef) async {
    String status = '';

    for (int i = 0; i < _detailLength; i++) {
      await productService.insertDetail(null, idRef, _detailNameControllerList[i].text, _detailDescControllerList[i].text, 0).then((value) {
        status = value;
      });
    }

    return status;
  }

  Future<String> _addImage(String idRef) async {
    String status = '';

    await productService.insertImage(productImages, idRef).then((value) {
      status = value;
    });

    return status;
  }

  /* */

  bool _checkValidation(bool isEdit) {
    bool result = false;
    late bool imagevalidate;
    bool warrantyValidate = true;
    bool cameratypeValidate = true;

    if (_isCamera) {
      cameratypeValidate = _cameraTypeController.text.isNotEmpty;
    }
    if (!isEdit) {
      imagevalidate = productImages.isNotEmpty;
    } else {
      imagevalidate = productImages.isNotEmpty || widget.productModel!.images.isNotEmpty;
    }
    if (_isWrranty && _warrantyPeriodController.text.isEmpty) {
      warrantyValidate = false;
    }

    if (_nameController.text.isNotEmpty && warrantyValidate && _priceController.text.isNotEmpty && _priceAfterDiscoutnController.text.isNotEmpty && imagevalidate && cameratypeValidate) {
      result = true;
    }
    return result;
  }

  void _onPriceCalulate() {
    String result = '';
    if (_priceController.text != '' && _discountController.text != '') {
      double discountPrice = double.parse(_priceController.text) * (double.parse(_discountController.text) / 100);

      result = (double.parse(_priceController.text) - discountPrice).toString();
    }
    _priceAfterDiscoutnController.text = result;
  }

  //
  void _onEditInit() {
    if (widget.productModel != null) {
      ProductModel model = widget.productModel!;
      //
      _nameController.text = model.name;
      _isWrranty = model.isWarranty == 1;
      _warrantyPeriodController.text = _isWrranty ? model.warrantyPeriod : '';

      _priceController.text = model.price.toString();
      _discountController.text = model.discount.toString();
      _priceAfterDiscoutnController.text = model.priceAfterDiscount.toString();
      _minQtyController.text = model.minQty.toString();

      //
      if (model.colors.isNotEmpty) {
        _colorName = List.generate(model.colors.length, (index) => TextEditingController());
        _color = List.generate(model.colors.length, (index) => Colors.black);
        _colorLength = model.colors.length;
        for (var color in model.colors) {
          _colorName[model.colors.indexOf(color)].text = color.color;
          _color[model.colors.indexOf(color)] = Color(int.parse(color.colorCode));
        }
      }

      if (model.details.isNotEmpty) {
        _detailNameControllerList = List.generate(model.details.length, (index) => TextEditingController());
        _detailDescControllerList = List.generate(model.details.length, (index) => TextEditingController());
        _detailLength = model.details.length;
        for (var detail in model.details) {
          _detailNameControllerList[model.details.indexOf(detail)].text = detail.detail;
          _detailDescControllerList[model.details.indexOf(detail)].text = detail.descs;
        }
      }
    }

    setState(() {});
  }

//

//
  Future<void> _pickColor(int index) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext contexts) {
        return AlertDialog(
          title: const Text(''),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: defaultColor,
              onColorChanged: ((pickedColor) {
                defaultColor = pickedColor;
              }),
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('ok'),
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop();
                setState(() {
                  _color[index] = defaultColor;
                });
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    _loadCameratype();
    _onEditInit();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    if (widget.productModel != null) {
      widget.productModel!.colors.addAll(_deletedColor);
      widget.productModel!.details.addAll(_deletedDetail);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        key: key,
        appBar: AppBar(
            iconTheme: IconThemeData(color: ColorsConts.primaryColor),
            elevation: 0,
            backgroundColor: const Color.fromRGBO(250, 250, 250, 1),
            foregroundColor: ColorsConts.primaryColor,
            title: Text(I18NTranslations.of(context).text('insert_product'))),
        body: Stack(
          children: [
            _buildBody(),
            _isLoading || cameratypeModel.isEmpty ? _loadingWidget() : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }

  Widget _loadingWidget() {
    return Container(
      color: Colors.black.withOpacity(.4),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Center(
        child: CircularProgressIndicator(
          color: ColorsConts.primaryColor,
        ),
      ),
    );
  }

  Widget _buildBody() {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                _mainInfoWidget(),
                _colorWidget(),
                _detailWidget(),
                _imageWidget(),
                _saveButton(),
                const SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _saveButton() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: CustomeAnimatedButton(
        width: MediaQuery.of(context).size.width,
        hegith: 50,
        title: I18NTranslations.of(context).text('save'),
        onTap: () {
          widget.productModel != null ? _onUpdate() : _addProduct();
          trickerFirebaseService.trickerAddNewProduct();
        },
        isShowShadow: true,
        backgroundColor: Colors.blue,
        radius: 5,
      ),
    );
  }

  Widget _imageWidget() {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(color: Colors.grey.withOpacity(.5), offset: const Offset(0, 1), spreadRadius: 1, blurRadius: 2),
      ]),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('រូបភាព'),
            FilePickerWidget(
              isPickFromFileExplorer: false,
              count: 10,
              attachments: productImages,
              isMultiSelect: false,
              onChoosingFiles: (files) {
                setState(() {
                  productImages = files;
                });
              },
            ),
            const SizedBox(height: 20),
            widget.productModel != null ? _showImageWidget() : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }

  Widget _showImageWidget() {
    List<Widget> colorItemList = [];
    for (var element in widget.productModel!.images) {
      colorItemList.add(_showImageItem(element.image, widget.productModel!.images.indexOf(element)));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(I18NTranslations.of(context).text('has') + '\t' + widget.productModel!.images.length.toString() + "\t" + I18NTranslations.of(context).text('picture(s)')),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(colorItemList.length, (index) {
              return colorItemList[index];
            }),
          ),
        ),
      ],
    );
  }

  Widget _showImageItem(String path, int index) {
    return Stack(
      children: [
        Container(
            margin: const EdgeInsets.all(10),
            width: 90,
            height: 90,
            child: DisplayImage(
              imageString: path,
              boxFit: BoxFit.fill,
              imageBorderRadius: 20,
            )),
        GestureDetector(
          onTap: () {
            setState(() {
              deletedImage.add(widget.productModel!.images[index]);
              widget.productModel!.images.removeAt(index);
            });
          },
          child: const Icon(
            Icons.close,
            color: Colors.red,
          ),
        )
      ],
    );
  }

  Widget _detailWidget() {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(color: Colors.grey.withOpacity(.5), offset: const Offset(0, 1), spreadRadius: 1, blurRadius: 2),
      ]),
      child: Column(
        children: [
          Column(
            children: List.generate(_detailLength, (index) => _detialItem(_detailNameControllerList[index], _detailDescControllerList[index], index)),
          ),
          TextButton(
              onPressed: () {
                setState(() {
                  _detailLength++;
                  _detailNameControllerList.add(TextEditingController());
                  _detailDescControllerList.add(TextEditingController());
                });
              },
              child: Text(I18NTranslations.of(context).text('add_more_detail')))
        ],
      ),
    );
  }

  Widget _detialItem(TextEditingController nameController, TextEditingController descController, int index) {
    return Column(
      children: [
        _devicederLine(index),
        Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: _buildTextInput('detail_for', nameController),
                  ),
                  Expanded(
                    child: _buildTextInput('description', descController),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30),
              child: TextButton(
                  onPressed: () {
                    if (_detailLength > 1) {
                      setState(() {
                        _detailLength--;
                        _detailNameControllerList.removeAt(index);
                        _detailDescControllerList.removeAt(index);
                      });
                    }

                    if (widget.productModel != null) {
                      _deletedDetail.add(widget.productModel!.details[index]);
                      widget.productModel!.details.removeAt(index);
                    }
                  },
                  child: const Text('-')),
            )
          ],
        ),
      ],
    );
  }

  Widget _colorWidget() {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(color: Colors.grey.withOpacity(.5), offset: const Offset(0, 1), spreadRadius: 1, blurRadius: 2),
      ]),
      child: Column(
        children: [
          Column(
            children: List.generate(_colorLength, (index) => colorItem(index)),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _colorLength++;
                _color.add(Colors.black);
                _colorName.add(TextEditingController(text: 'ខ្មៅ'));
              });
            },
            child: Text(
              I18NTranslations.of(context).text('add_color'),
            ),
          )
        ],
      ),
    );
  }

  Widget colorItem(int index) {
    return Column(
      children: [
        _devicederLine(index),
        Row(
          children: [
            Container(
              height: 60,
              alignment: Alignment.center,
              decoration: BoxDecoration(border: Border.all(color: Colors.grey.withOpacity(.2)), color: _color[index], borderRadius: BorderRadius.circular(5)),
              width: 60,
              margin: const EdgeInsets.all(10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                      onTap: () {
                        _pickColor(index);
                      },
                      child: Container()),
                ),
              ),
            ),
            Expanded(child: _buildTextInput('color', _colorName[index])),
            Padding(
              padding: const EdgeInsets.only(top: 30),
              child: TextButton(
                  onPressed: () {
                    if (_colorLength > 1) {
                      setState(() {
                        _colorLength--;
                        _color.removeAt(index);
                        _colorName.removeAt(index);
                      });
                    }

                    if (widget.productModel != null) {
                      _deletedColor.add(widget.productModel!.colors[index]);

                      widget.productModel!.colors.removeAt(index);
                    }
                  },
                  child: const Text('-')),
            )
          ],
        ),
      ],
    );
  }

  Widget _mainInfoWidget() {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(color: Colors.grey.withOpacity(.5), offset: const Offset(0, 1), spreadRadius: 1, blurRadius: 2),
      ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          _buildTextInput('product_name', _nameController),
          _buildTextInput('price', _priceController, textInputType: TextInputType.number, onChange: ((e) => _onPriceCalulate())),
          _buildTextInput('discount', _discountController, isShowPercentage: true, textInputType: TextInputType.number, onChange: ((e) => _onPriceCalulate())),
          _buildTextInput('price_after_discount', _priceAfterDiscoutnController, textInputType: TextInputType.number, enabled: false),
          _buildTextInput('min_qty', _minQtyController, textInputType: TextInputType.number),
          Row(
            children: [Expanded(child: _warrantyCheckBox()), Expanded(child: _isCameraCheckBox())],
          ),
          _isCamera
              ? InkWell(
                  onTap: () => GetCameraTypeBottomSheet.show(context, cameratypeModel, ((cameratypeModel) {
                        setState(() {
                          _seletedCameraType = cameratypeModel;
                          _cameraTypeController.text = cameratypeModel.type ?? '';
                        });
                      })),
                  child: _buildTextInput('camera.type', _cameraTypeController, enabled: false))
              : const SizedBox.shrink(),
          _isWrranty ? _buildTextInput('warranty_duration', _warrantyPeriodController) : const SizedBox.shrink(),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _devicederLine(int index) {
    return index > 0
        ? Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            width: MediaQuery.of(context).size.width,
            height: 1,
            color: ColorsConts.primaryColor,
          )
        : const SizedBox.shrink();
  }

  Widget _warrantyCheckBox() {
    return SizedBox(
      width: 205,
      child: CheckboxListTile(
        activeColor: ColorsConts.primaryColor,
        checkColor: Colors.white,
        value: _isWrranty,
        onChanged: (val) {
          setState(() {
            _isWrranty = val!;
            if (!_isWrranty) {
              _warrantyPeriodController.text = '';
            }
          });
        },
        title: Text(I18NTranslations.of(context).text('has_warranty')),
      ),
    );
  }

  Widget _isCameraCheckBox() {
    return SizedBox(
      width: 205,
      child: CheckboxListTile(
        activeColor: ColorsConts.primaryColor,
        checkColor: Colors.white,
        value: _isCamera,
        onChanged: (val) {
          setState(() {
            _isCamera = val!;
          });
        },
        title: Text(I18NTranslations.of(context).text('is_camera')),
      ),
    );
  }

  Widget _buildTextInput(String label, TextEditingController textEditingController,
      {bool isShowPercentage = false, bool enabled = true, TextInputType textInputType = TextInputType.text, Function(String)? onChange, double? width}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(color: Colors.grey.withOpacity(.2), borderRadius: BorderRadius.circular(5)),
          width: width ?? MediaQuery.of(context).size.width,
          margin: const EdgeInsets.all(10),
          child: TextFormField(
            enabled: enabled,
            keyboardType: textInputType,
            onChanged: onChange,
            maxLines: null,
            controller: textEditingController,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white.withOpacity(.5),
              labelText: I18NTranslations.of(context).text(label) + ' ${isShowPercentage ? '%' : ''}',
              labelStyle: const TextStyle(color: Colors.grey),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: Color(0xffD98C00),
                ),
              ),
              contentPadding: const EdgeInsets.only(left: 10, top: 15, bottom: 15, right: 10),
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }
}
