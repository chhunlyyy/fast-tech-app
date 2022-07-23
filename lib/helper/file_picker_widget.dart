import 'dart:io';
import 'package:fast_tech_app/const/color_conts.dart';
import 'package:fast_tech_app/helper/file_helper.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker2/multi_image_picker2.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as path;

enum EFileChooserOption { CAMERA, GALLERY, FILE }

class FilePickerWidget extends StatefulWidget {
  final List<File> attachments;
  final int? count;
  final BoxFit imageFit;
  final Widget? uploadBtn;
  final bool isPickFromFileExplorer;
  final bool isMultiSelect;
  final void Function(List<File> files) onChoosingFiles;

  const FilePickerWidget({
    Key? key,
    this.count = 9,
    required this.attachments,
    this.uploadBtn,
    this.isPickFromFileExplorer = false,
    this.isMultiSelect = false,
    this.imageFit = BoxFit.cover,
    required this.onChoosingFiles,
  }) : super(key: key);

  @override
  _FilePickerWidget createState() => _FilePickerWidget();
}

class _FilePickerWidget extends State<FilePickerWidget> {
  List<File> attachments = [];
  List<String> fileNames = [];
  File? attachment;
  double space = StyleColor.FilePickerWidgetItemGutter;
  Directory? tempDir;

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      tempDir = await getTemporaryDirectory();
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      direction: Axis.horizontal,
      spacing: space,
      runSpacing: space,
      children: buildImages(context),
    );
  }

  List<Widget> buildImages(BuildContext context) {
    List<Widget> widgets = [];
    attachments = widget.attachments;
    for (int i = 0; i < attachments.length; i++) {
      widgets.add(_buildImageItem(context, i));
    }
    if (widget.count == null || attachments.length < widget.count!) {
      widgets.add(_buildAddImageButton(context));
    }
    return widgets;
  }

  Widget _buildImageItem(BuildContext context, int index) {
    return Stack(
      clipBehavior: Clip.hardEdge,
      children: <Widget>[
        _showItem(context, index),
        Positioned(
          right: 0,
          top: 0,
          child: Material(
            elevation: 2,
            borderRadius: BorderRadius.circular(StyleColor.borderRadiusMax),
            child: InkWell(
              borderRadius: BorderRadius.circular(StyleColor.borderRadiusMax),
              child: const Icon(Icons.cancel, color: Colors.red, size: 25),
              onTap: () {
                setState(() {
                  attachments.removeAt(index);
                });
              },
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.only(left: 2, right: 2),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(),
              borderRadius: const BorderRadius.all(Radius.circular(5)),
            ),
            child: Text(
              getRollupSize(attachments[index].lengthSync()),
              style: const TextStyle(fontSize: 8),
            ),
          ),
        ),
      ],
    );
  }

  Widget _showItem(BuildContext context, int index) {
    String extension = path.extension(attachments[index].path).toLowerCase();
    Widget child;
    if (FileHelper.isFileImage(extension)) {
      child = InkWell(
        onTap: () {
          // pushWidgetWithFade(context, ImageDetailWidget(imageFiles: attachments, defaultFile: attachments[index], imageUrls: [], imageType: EImageType.IMAGE_FILE));
        },
        child: ClipRRect(
          child: Image.file(
            attachments[index],
            cacheHeight: 100,
            cacheWidth: 100,
            fit: widget.imageFit,
            width: StyleColor.FilePickerWidgetItemSize,
            height: StyleColor.FilePickerWidgetItemSize,
          ),
          borderRadius: BorderRadius.circular(StyleColor.FilePickerWidgetItemBorderRadius),
        ),
      );
    } else {
      FileInfo fileInfo = FileHelper.getFileInfo(context, extension);
      child = _fileIcon(path.basename(attachments[index].path), fileInfo.iconData, fileInfo.color);
    }
    return child;
  }

  Widget _fileIcon(String fileName, IconData icon, Color color) {
    return Container(
      width: StyleColor.FilePickerWidgetItemSize,
      height: StyleColor.FilePickerWidgetItemSize,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey[300]!,
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      padding: const EdgeInsets.all(3),
      child: Column(
        children: <Widget>[
          Icon(
            icon,
            color: color,
            size: 45,
          ),
          const SizedBox(height: 4),
          Expanded(
            child: Text(
              fileName,
              style: const TextStyle(fontSize: 9),
              textAlign: TextAlign.center,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildAddImageButton(BuildContext context) {
    Widget btn = Container(
      width: StyleColor.FilePickerWidgetItemSize,
      height: StyleColor.FilePickerWidgetItemSize,
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Colors.grey,
          ),
          borderRadius: BorderRadius.circular(StyleColor.FilePickerWidgetItemBorderRadius)),
      child: const Icon(FontAwesomeIcons.plusCircle, color: Colors.blue, size: 25),
    );

    return InkWell(
      child: widget.uploadBtn ?? btn,
      onTap: () async {
        EFileChooserOption? eFileChooserOption = await _showFileChooserDialog(context);
        switch (eFileChooserOption) {
          case EFileChooserOption.CAMERA:
            return _chooseImage(context: context, source: ImageSource.camera);
          case EFileChooserOption.GALLERY:
            return !widget.isMultiSelect ? _chooseImage(context: context, source: ImageSource.gallery) : _chooseMultiImage(context);
          case EFileChooserOption.FILE:
            return _openFileExplorer(context, FileType.custom);
          default:
            return;
        }
      },
    );
  }

  Future<EFileChooserOption?> _showFileChooserDialog(BuildContext context) async {
    return await showDialog<EFileChooserOption>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return SimpleDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(8.0),
            ),
          ),
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      Navigator.pop(context, EFileChooserOption.CAMERA);
                    },
                    child: SvgPicture.asset(
                      'assets/svg/camera.svg',
                      width: MediaQuery.of(context).size.width / 7,
                    ),
                  ),
                  widget.isPickFromFileExplorer == true
                      ? const SizedBox(
                          width: 18,
                        )
                      : const SizedBox(width: 38),
                  InkWell(
                    onTap: () {
                      // Navigator.pop(context);
                      Navigator.pop(context, EFileChooserOption.GALLERY);
                    },
                    // child: KoukiconsGalleryX(
                    //   height: 55,
                    // ),
                    child: SvgPicture.asset(
                      'assets/svg/gallery.svg',
                      width: MediaQuery.of(context).size.width / 7,
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  widget.isPickFromFileExplorer == true
                      ? InkWell(
                          onTap: () {
                            Navigator.pop(context, EFileChooserOption.FILE);
                          },
                          // child: KoukiconsOpenedFolder(
                          //   height: 70,
                          // )
                          child: SvgPicture.asset(
                            'assets/svg/file.svg',
                            width: MediaQuery.of(context).size.width / 7,
                          ),
                        )
                      : const SizedBox.shrink()
                ],
              ),
            ),
          ],
          backgroundColor: ColorsConts.primaryColor,
        );
      },
    );
  }

  Future<void> _chooseMultiImage(BuildContext context) async {
    int i = 0;
    List<Asset> assetImages = [];

    try {
      assetImages = await MultiImagePicker.pickImages(
        maxImages: 300,
        enableCamera: true,
        cupertinoOptions: const CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: const MaterialOptions(
          actionBarColor: "#abcdef",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      debugPrint("<---MulitiImagePicker Error: ${e.toString()} --->");
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    if (assetImages.isNotEmpty) {
      if (assetImages.length > widget.count!) {
      } else {
        List<Future<File>> tasks = [];
        while (i < assetImages.length) {
          tasks.add(getImageFileFromAsset(assetImages[i]));
          i++;
        }
        await Future.wait(tasks).then((List<File> files) {
          setState(() {
            if (files.isNotEmpty) {
              for (var file in files) {
                // File? isExistFile = isFileExist(file);
                // if (isExistFile != null) {
                attachments.add(file);
                // }
              }
            }
            widget.onChoosingFiles(attachments);
          });
        });
      }
    }
  }

  File? isFileExist(File newFile) {
    File? existFile = attachments.firstWhere((oldFile) {
      String fileName = basename(newFile.path);
      String oldfileName = basename(oldFile.path);
      return fileName == oldfileName;
    });

    return existFile;
  }

  Future<File> getImageFileFromAsset(Asset asset) async {
    final byteData = await asset.getByteData();
    final tempFile = File("${(await getTemporaryDirectory()).path}/${asset.name}");
    return await tempFile.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes)).then((file) {
      return file;
    });
  }

  Future _chooseImage({required BuildContext context, required ImageSource source}) async {
    try {
      XFile? xFile = await ImagePicker().pickImage(source: source, imageQuality: 80);
      if (xFile != null) {
        setState(() {
          attachment = File(xFile.path);
          attachments.add(attachment!);
          widget.onChoosingFiles(attachments);
        });
      }
    } catch (error) {
      print('ChooseImage error: $error');
    }
  }

  Future _openFileExplorer(BuildContext context, FileType type) async {
    try {
      FilePickerResult? filePickerResult = await FilePicker.platform.pickFiles(type: type, allowedExtensions: ALLOW_FILE_UPLOAD_EXT);
      if (filePickerResult != null) {
        setState(() {
          File filePicker = File(filePickerResult.files.single.path!);
          attachments.add(filePicker);
          String _fileName = basename(filePicker.path);
          fileNames.add(_fileName);
        });
        widget.onChoosingFiles(attachments);
      }
    } on PlatformException catch (e) {
      print("Unsupported operation" + e.toString());
    }
  }

  static const RollupSize_Units = ["GB", "MB", "KB", "B"];

  static String getRollupSize(int size) {
    int idx = 3;
    int r1 = 0;
    String result = "";
    while (idx >= 0) {
      int s1 = size % 1024;
      size = size >> 10;
      if (size == 0 || idx == 0) {
        r1 = (r1 * 100) ~/ 1024;
        if (r1 > 0) {
          if (r1 >= 10) {
            result = "$s1.$r1${RollupSize_Units[idx]}";
          } else {
            result = "$s1.0$r1${RollupSize_Units[idx]}";
          }
        } else {
          result = s1.toString() + RollupSize_Units[idx];
        }
        break;
      }
      r1 = s1;
      idx--;
    }
    return result;
  }
}

class StyleColor {
  static const black = Colors.black;
  static const white = Colors.white;
  static const gray1 = Color(0xfff7f8fa);
  static const gray2 = Color(0xfff2f3f5);
  static const gray3 = Color(0xffebedf0);
  static const gray4 = Color(0xffdcdee0);
  static const gray5 = Color(0xffc8c9cc);
  static const gray6 = Color(0xff969799);
  static const gray7 = Color(0xff646566);
  static const gray8 = Color(0xff323233);
  static const red = Color(0xffee0a24);
  static const blue = Color(0xff1989fa);
  static const yellow = Color(0xffffd21e);
  static const orange = Color(0xffff976a);
  static const orangeDark = Color(0xffed6a0c);
  static const orangeLight = Color(0xfffffbe8);
  static const green = Color(0xff07c160);
  static const transparent = Colors.transparent;

  // padding
  static const paddingBase = 4.0;
  static const paddingXs = paddingBase * 2;
  static const paddingSm = paddingBase * 3;
  static const paddingMd = paddingBase * 4;
  static const paddingLg = paddingBase * 6;
  static const paddingXl = paddingBase * 8;

  // Border
  static const borderColor = gray3;
  static const borderWidthBase = 1.0;
  static const borderWidthHair = 0.5;
  static const borderRadiusSm = 2.0;
  static const borderRadiusMd = 4.0;
  static const borderRadiusLg = 8.0;
  static const borderRadiusMax = 999.0;

  // FilePickerWidget
  static const FilePickerWidgetPadding = EdgeInsets.symmetric(horizontal: paddingSm);
  static const FilePickerWidgetCloseButtonColor = gray6;
  static const FilePickerWidgetCloseButtonFontSize = 16.0;
  static const FilePickerWidgetItemSize = 90.0;
  static const FilePickerWidgetItemGutter = 10.0;
  static const FilePickerWidgetItemBorderRadius = 4.0;
  static const FilePickerWidgetUploadBorderColor = borderColor;
  static const FilePickerWidgetUploadBackground = white;
  static const FilePickerWidgetUploadSize = 18.0;
  static const FilePickerWidgetUploadColor = gray6;
}
