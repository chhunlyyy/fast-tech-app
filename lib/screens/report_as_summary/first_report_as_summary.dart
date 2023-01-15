import 'package:fast_tech_app/const/assets_const.dart';
import 'package:fast_tech_app/const/color_conts.dart';
import 'package:fast_tech_app/core/i18n/i18n_translate.dart';
import 'package:fast_tech_app/screens/report_as_summary/first_report.dart';
import 'package:fast_tech_app/screens/report_as_summary/second_report_as_summary.dart';
import 'package:fast_tech_app/screens/report_as_summary/third_report_as_summary.dart';
import 'package:fast_tech_app/services/report_service/report_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:printing/printing.dart';

class SummaryReport extends StatefulWidget {
  const SummaryReport({Key? key}) : super(key: key);

  @override
  State<SummaryReport> createState() => _SummaryReportState();
}

class _SummaryReportState extends State<SummaryReport> {
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();
  bool isLoading = true;

  late Widget _content;
  int report = 1;

  List<FirstReportModel> invoiceModels = [];

  void getReport() {
    isLoading = true;
    Future.delayed(Duration.zero, () async {
      try {
        await reportService.getFirstReport({'start_date': DateFormat('yyyy-MM-dd').format(_startDate), 'to_date': DateFormat('yyyy-MM-dd').format(_endDate)}).then((value) {
          setState(() {
            invoiceModels = value;
            isLoading = false;
          });
        });
      } catch (e) {
        isLoading = false;
      }
    });
  }

  @override
  void initState() {
    getReport();
    super.initState();
  }

  void _showDatePicker(context, bool isStartDate) {
    showCupertinoModalPopup(
        context: context,
        builder: (_) => Container(
              height: 400,
              color: const Color.fromARGB(255, 255, 255, 255),
              child: Column(
                children: [
                  SizedBox(
                    height: 400,
                    child: CupertinoDatePicker(
                        initialDateTime: isStartDate ? _startDate : _endDate,
                        mode: CupertinoDatePickerMode.date,
                        dateOrder: DatePickerDateOrder.dmy,
                        onDateTimeChanged: (val) {
                          setState(() {
                            if (isStartDate) {
                              _startDate = val;
                            } else {
                              _endDate = val;
                            }
                          });
                        }),
                  ),
                ],
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    if (report == 1) {
      _content = _buildBody();
    } else if (report == 2) {
      _content = const SecondReport();
    } else {
      _content = const ThirdReport();
    }
    return Material(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: ColorsConts.primaryColor),
          elevation: 0,
          backgroundColor: const Color.fromRGBO(250, 250, 250, 1),
          foregroundColor: ColorsConts.primaryColor,
          title: Text(I18NTranslations.of(context).text('report.summary')),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: GestureDetector(
                onTap: () {
                  showDialog<Widget>(
                    context: context,
                    builder: (BuildContext context) {
                      return Dialog(
                          elevation: 16,
                          child: Container(
                            child: ListView(
                              shrinkWrap: true,
                              children: <Widget>[
                                const SizedBox(height: 20),
                                Center(
                                    child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            Navigator.pop(context);
                                            report = 1;
                                          });
                                        },
                                        child: Text(
                                          'Show Report By Date Range',
                                          style: TextStyle(color: report == 1 ? Colors.blue : Colors.black),
                                        ))),
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  child: Divider(),
                                ),
                                Center(
                                    child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            Navigator.pop(context);
                                            report = 2;
                                          });
                                        },
                                        child: Text(
                                          'Show Report By Date',
                                          style: TextStyle(color: report == 2 ? Colors.blue : Colors.black),
                                        ))),
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  child: Divider(),
                                ),
                                Center(
                                    child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            Navigator.pop(context);
                                            report = 3;
                                          });
                                        },
                                        child: Text(
                                          'Show Report By Report ID',
                                          style: TextStyle(color: report == 3 ? Colors.blue : Colors.black),
                                        ))),
                                const SizedBox(height: 20),
                              ],
                            ),
                          ));
                    },
                  );
                },
                child: const Icon(Icons.filter_list_alt),
              ),
            ),
          ],
        ),
        body: _content,
      ),
    );
  }

  Widget _buildBody() {
    return Column(children: [
      Row(
        children: [
          Expanded(child: _datePicker(true)),
          Expanded(child: _datePicker(false)),
        ],
      ),
      _button(),
      isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Expanded(
              child: invoiceModels.isEmpty
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Lottie.asset(AssetsConst.ANIM_LOTTIE_EMPTYBOX, height: MediaQuery.of(context).size.height / 4),
                        const Text(''),
                      ],
                    )
                  : PdfPreview(
                      maxPageWidth: MediaQuery.of(context).size.width,
                      build: (format) => generateFirstReport(format, invoiceModels, DateFormat('dd-MM-yyyy').format(_startDate), DateFormat('dd-MM-yyyy').format(_endDate)),
                      actions: const [],
                      onPrinted: ((context) {}),
                      onShared: ((context) {}),
                    ),
            )
    ]);
  }

  Widget _button() {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(5)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              getReport();
            },
            child: const Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                'Generate',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _datePicker(bool isStartDate) {
    var formatter = DateFormat('dd-MMMM-yyyy');
    return InkWell(
        onTap: () {
          _showDatePicker(context, isStartDate);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: Colors.grey.withOpacity(.2), borderRadius: BorderRadius.circular(5)),
          child: Text(
            isStartDate ? formatter.format(_startDate) : formatter.format(_endDate),
            textAlign: TextAlign.center,
          ),
        ));
  }
}
