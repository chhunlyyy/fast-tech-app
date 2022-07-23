import 'package:fast_tech_app/widget/widget_helper.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path/path.dart' as path;

const List<String> FILE_DOC_EXT = ['doc', 'docx', 'odt', 'ods', 'odp'];
const List<String> FILE_EXCEL_EXT = ['xls', 'xlsx', 'csv'];
const List<String> FILE_POWER_POINT_EXT = ['ppt', 'pptx'];
const List<String> FILE_IMAGE_EXT = ['jpg', 'jpeg', 'png', 'gif', 'bmp'];
const List<String> FILE_PDF_EXT = ['pdf'];
const List<String> FILE_AUDIO_EXT = ['wav', 'mp3'];

const List<String> ALLOW_FILE_UPLOAD_EXT = ['pdf', 'doc', 'docx', 'xls', 'xlsx', 'ppt', 'pptx', 'odt', 'ods', 'odp'];

class FileInfo {
  Color color;
  IconData iconData;
  String label;
  FileInfo({required this.color, required this.label, required this.iconData});
}

class FileHelper {
  static String getFileExtension(String filePath) {
    String fileName = path.basename(filePath);
    String fileExtension = path.extension(fileName);
    return fileExtension;
  }

  static bool isContainAnyFileExtensions(String fileName) {
    String fileExtension = path.extension(fileName);
    fileExtension = fileExtension.replaceAll(".", "");
    return FILE_AUDIO_EXT.contains(fileExtension) ||
        FILE_IMAGE_EXT.contains(fileExtension) ||
        FILE_DOC_EXT.contains(fileExtension) ||
        FILE_EXCEL_EXT.contains(fileExtension) ||
        FILE_POWER_POINT_EXT.contains(fileExtension) ||
        FILE_PDF_EXT.contains(fileExtension);
  }

  static bool isFileImage(String fileExtension) {
    return isAllowFileExtension(FILE_IMAGE_EXT, fileExtension);
  }

  static bool isFilePdf(String fileExtension) {
    return isAllowFileExtension(FILE_PDF_EXT, fileExtension.toLowerCase());
  }

  static bool isAllowFileExtension(List<String> listExtension, String fileExtension) {
    fileExtension = fileExtension.replaceAll(".", "");
    return listExtension.contains(fileExtension);
  }

  static FileInfo getFileInfo(BuildContext context, String fileExtension) {
    Color color;
    IconData iconData;
    String label;

    fileExtension = fileExtension.replaceAll(".", "");

    if (FILE_AUDIO_EXT.contains(fileExtension)) {
      iconData = FontAwesomeIcons.volumeUp;
      color = Colors.orange[800]!;
      label = 'សម្លេង';
    } else if (FILE_IMAGE_EXT.contains(fileExtension)) {
      iconData = FontAwesomeIcons.image;
      color = Colors.green;
      label = 'រូបភាព';
    } else if (FILE_DOC_EXT.contains(fileExtension)) {
      iconData = FontAwesomeIcons.fileWord;
      color = Colors.blue;
      label = 'ឯកសារ';
    } else if (FILE_EXCEL_EXT.contains(fileExtension)) {
      iconData = FontAwesomeIcons.fileExcel;
      color = Colors.green;
      label = 'ឯកសារ';
    } else if (FILE_POWER_POINT_EXT.contains(fileExtension)) {
      iconData = FontAwesomeIcons.filePowerpoint;
      color = Colors.orange[800]!;
      label = 'ឯកសារ';
    } else if (FILE_PDF_EXT.contains(fileExtension)) {
      iconData = FontAwesomeIcons.filePdf;
      color = Colors.red;
      label = 'ឯកសារ';
    } else {
      iconData = FontAwesomeIcons.file;
      color = Colors.grey;
      label = 'ឯកសារ';
    }
    return FileInfo(label: label, color: color, iconData: iconData);
  }

  static Widget showAttachementIcon({required BuildContext context, required String fileName, double iconSize = 17, double fontSize = 12}) {
    String extension = path.extension(fileName).toLowerCase();
    FileInfo fileInfo = getFileInfo(context, extension);
    return WidgetHepler.item(context: context, fileName: fileName, label: fileInfo.label, icon: fileInfo.iconData, color: fileInfo.color, iconSize: iconSize, fontSize: fontSize);
  }
}
