import 'package:fast_tech_app/const/assets_const.dart';
import 'package:fast_tech_app/screens/report_as_summary/second_report.dart';
import 'package:fast_tech_app/services/report_service/report_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:printing/printing.dart';

class SecondReport extends StatefulWidget {
  const SecondReport({Key? key}) : super(key: key);

  @override
  State<SecondReport> createState() => _SecondReportState();
}

class _SecondReportState extends State<SecondReport> {
  DateTime _startDate = DateTime.now();

  bool isLoading = true;

  List<SecondReportModel> invoiceModels = [];

  void getReport() {
    isLoading = true;
    Future.delayed(Duration.zero, () async {
      try {
        await reportService.getSecondReport({'date': DateFormat('yyyy-MM-dd').format(_startDate)}).then((value) {
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

  void _showDatePicker(context) {
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
                        initialDateTime: _startDate,
                        mode: CupertinoDatePickerMode.date,
                        dateOrder: DatePickerDateOrder.dmy,
                        onDateTimeChanged: (val) {
                          setState(() {
                            _startDate = val;
                          });
                        }),
                  ),
                ],
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        // appBar: AppBar(
        //   iconTheme: IconThemeData(color: ColorsConts.primaryColor),
        //   elevation: 0,
        //   backgroundColor: const Color.fromRGBO(250, 250, 250, 1),
        //   foregroundColor: ColorsConts.primaryColor,
        //   title: const Text('Report By Date'),
        //   actions: [
        //     Padding(
        //       padding: const EdgeInsets.symmetric(horizontal: 10),
        //       child: GestureDetector(
        //         onTap: () {
        //           showDialog(
        //             context: context,
        //             builder: (context) {
        //               return Dialog(
        //                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        //                   elevation: 16,
        //                   child: Builder(builder: ((context) {
        //                     return Container(
        //                       child: ListView(
        //                         shrinkWrap: true,
        //                         children: <Widget>[
        //                           const SizedBox(height: 20),
        //                           Center(
        //                               child: InkWell(
        //                                   onTap: () {
        //                                     Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
        //                                       return const SummaryReport();
        //                                     }));
        //                                   },
        //                                   child: const Text('Show Report By Date Range'))),
        //                           const Padding(
        //                             padding: EdgeInsets.symmetric(vertical: 10),
        //                             child: Divider(),
        //                           ),
        //                           Center(
        //                               child: InkWell(
        //                                   onTap: () {
        //                                     Navigator.pop(context);
        //                                   },
        //                                   child: const Text('Show Report By Date'))),
        //                           const Padding(
        //                             padding: EdgeInsets.symmetric(vertical: 10),
        //                             child: Divider(),
        //                           ),
        //                           Center(
        //                               child: InkWell(
        //                                   onTap: () {
        //                                     Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
        //                                       return const ThirdReport();
        //                                     }));
        //                                   },
        //                                   child: const Text('Show Report By Report ID'))),
        //                           const SizedBox(height: 20),
        //                         ],
        //                       ),
        //                     );
        //                   })));
        //             },
        //           );
        //         },
        //         child: const Icon(Icons.filter_list_alt),
        //       ),
        //     ),
        //   ],
        // ),
        body: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    return Column(children: [
      Row(
        children: [
          Expanded(child: _datePicker()),
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
                        const Text('no_report'),
                      ],
                    )
                  : PdfPreview(
                      maxPageWidth: MediaQuery.of(context).size.width,
                      build: (format) => generateSecondReport(format, invoiceModels, DateFormat('dd-MM-yyyy').format(_startDate)),
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

  Widget _datePicker() {
    var formatter = DateFormat('dd-MMMM-yyyy');
    return InkWell(
        onTap: () {
          _showDatePicker(context);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: Colors.grey.withOpacity(.2), borderRadius: BorderRadius.circular(5)),
          child: Text(
            formatter.format(_startDate),
            textAlign: TextAlign.center,
          ),
        ));
  }
}
