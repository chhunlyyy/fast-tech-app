import 'package:fast_tech_app/const/color_conts.dart';
import 'package:fast_tech_app/core/i18n/i18n_translate.dart';
import 'package:fast_tech_app/core/models/camera_type_model.dart';
import 'package:fast_tech_app/helper/navigation_helper.dart';
import 'package:fast_tech_app/screens/add_camera_type/add_camera_type.dart';
import 'package:flutter/material.dart';

class GetCameraTypeBottomSheet {
  static void show(BuildContext context, List<CameraTypeModel> cameratypeModles, Function(CameraTypeModel cameraTypeModel) onClick) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.5,
            child: GetCameraTypeBottomSheetBody(
              onClick: onClick,
              models: cameratypeModles,
            ),
          );
        });
  }
}

class GetCameraTypeBottomSheetBody extends StatefulWidget {
  final List<CameraTypeModel> models;
  final Function(CameraTypeModel cameraTypeModel) onClick;
  const GetCameraTypeBottomSheetBody({Key? key, required this.models, required this.onClick}) : super(key: key);

  @override
  State<GetCameraTypeBottomSheetBody> createState() => _GetCameraTypeBottomSheetBodyState();
}

class _GetCameraTypeBottomSheetBodyState extends State<GetCameraTypeBottomSheetBody> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(child: Center(child: Text(I18NTranslations.of(context).text('camera.type'), style: TextStyle(color: ColorsConts.primaryColor)))),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: InkWell(
                  onTap: () {
                    NavigationHelper.push(context, const AddCameraTypeScreen());
                  },
                  child: const Icon(
                    Icons.add,
                    color: Colors.green,
                    size: 30,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Expanded(child: ListView(children: widget.models.map((e) => item(e)).toList())),
        ],
      ),
    );
  }

  Widget item(CameraTypeModel model) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        widget.onClick(model);
      },
      child: Container(
        margin: const EdgeInsets.all(10),
        color: Colors.blue,
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Center(
            child: Text(
          model.type ?? '',
          style: const TextStyle(color: Colors.white),
        )),
      ),
    );
  }
}
