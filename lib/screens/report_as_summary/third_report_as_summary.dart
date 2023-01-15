import 'package:fast_tech_app/const/assets_const.dart';
import 'package:fast_tech_app/screens/report_as_summary/third_report.dart';
import 'package:fast_tech_app/services/report_service/report_service.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:printing/printing.dart';

class ThirdReport extends StatefulWidget {
  const ThirdReport({Key? key}) : super(key: key);

  @override
  State<ThirdReport> createState() => _ThirdReportState();
}

class _ThirdReportState extends State<ThirdReport> {
  bool isLoading = true;

  final TextEditingController _controller = TextEditingController();

  List<InvoiceModel> invoiceModels = [];

  void getReport() {
    isLoading = true;
    Future.delayed(Duration.zero, () async {
      try {
        if (_controller.text.isNotEmpty) {
          await reportService.getThirdReport({'invoice_id_ref': _controller.text}).then((value) {
            setState(() {
              invoiceModels = value;
              isLoading = false;
            });
          });
        } else {
          setState(() {
            isLoading = false;
          });
        }
      } catch (e) {
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  @override
  void initState() {
    getReport();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Scaffold(
          // appBar: AppBar(
          //   iconTheme: IconThemeData(color: ColorsConts.primaryColor),
          //   elevation: 0,
          //   backgroundColor: const Color.fromRGBO(250, 250, 250, 1),
          //   foregroundColor: ColorsConts.primaryColor,
          //   title: const Text('Report By Invoice ID'),
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
          //                                     Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
          //                                       return const SecondReport();
          //                                     }));
          //                                   },
          //                                   child: const Text('Show Report By Date'))),
          //                           const Padding(
          //                             padding: EdgeInsets.symmetric(vertical: 10),
          //                             child: Divider(),
          //                           ),
          //                           Center(
          //                               child: InkWell(
          //                                   onTap: () {
          //                                     Navigator.pop(context);
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
                      ],
                    )
                  : PdfPreview(
                      maxPageWidth: MediaQuery.of(context).size.width,
                      build: (format) => generateThirdInvoice(format, invoiceModels, _controller.text),
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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: _controller,
        keyboardType: TextInputType.text,
        decoration: const InputDecoration(
          hintText: 'Please Input Invoice ID',
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 1, color: Colors.grey), //<-- SEE HERE
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 1, color: Colors.blue), //<-- SEE HERE
          ),
        ),
      ),
    );
  }
}
