import 'package:dio/dio.dart';
import 'package:fast_tech_app/screens/report_as_summary/third_report.dart';
import 'package:fast_tech_app/screens/report_as_summary/first_report.dart';
import 'package:fast_tech_app/screens/report_as_summary/second_report.dart';
import 'package:fast_tech_app/services/http/http_api_service.dart';
import 'package:fast_tech_app/services/http/http_config.dart';

class ReportService {
  Future<List<FirstReportModel>> getFirstReport(Map<String, dynamic> params) async {
    return await httpApiService.get('/firt-report', params, Options(headers: HttpConfig.headers)).then((value) {
      return List<FirstReportModel>.from(value.data.map((x) => FirstReportModel.fromJson(x)));
    });
  }

  Future<List<SecondReportModel>> getSecondReport(Map<String, dynamic> params) async {
    return await httpApiService.get('/second-report', params, Options(headers: HttpConfig.headers)).then((value) {
      return List<SecondReportModel>.from(value.data.map((x) => SecondReportModel.fromJson(x)));
    });
  }

  Future<List<InvoiceModel>> getThirdReport(Map<String, dynamic> params) async {
    return await httpApiService.get('/third-report', params, Options(headers: HttpConfig.headers)).then((value) {
      return List<InvoiceModel>.from(value.data.map((x) => InvoiceModel.fromJson(x)));
    });
  }
}

ReportService reportService = ReportService();
