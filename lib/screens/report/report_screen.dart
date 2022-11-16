import 'package:fast_tech_app/const/assets_const.dart';
import 'package:fast_tech_app/const/color_conts.dart';
import 'package:fast_tech_app/core/i18n/i18n_translate.dart';
import 'package:fast_tech_app/screens/report/invoice.dart';
import 'package:fast_tech_app/services/order_service/order_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:printing/printing.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({Key? key}) : super(key: key);

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();
  bool isLoading = true;

  List<InvoiceModel> invoiceModels = [];

  void getReport() {
    isLoading = true;
    Future.delayed(Duration.zero, () async {
      try {
        await orderService.getInvoices({'start_date': DateFormat('yyyy-MM-dd').format(_startDate), 'to_date': DateFormat('yyyy-MM-dd').format(_endDate)}).then((value) {
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
    return Material(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: ColorsConts.primaryColor),
          elevation: 0,
          backgroundColor: const Color.fromRGBO(250, 250, 250, 1),
          foregroundColor: ColorsConts.primaryColor,
          title: Text(I18NTranslations.of(context).text('report')),
        ),
        body: _buildBody(),
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
                        Text(I18NTranslations.of(context).text('no_report')),
                      ],
                    )
                  : PdfPreview(
                      maxPageWidth: MediaQuery.of(context).size.width,
                      build: (format) => generateInvoice(format, invoiceModels, DateFormat('dd-MM-yyyy').format(_startDate), DateFormat('dd-MM-yyyy').format(_endDate)),
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
