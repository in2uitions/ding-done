import 'package:dingdone/models/jobs_model.dart';
import 'package:dingdone/res/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:dingdone/data/remote/network/api_end_points.dart';
import 'package:dingdone/data/remote/network/base_api_service.dart';
import 'package:dingdone/data/remote/network/network_api_service.dart';
import 'package:dingdone/res/app_prefs.dart';

class JobsRepository {
  final BaseApiService _apiCustomerJobs =
      NetworkApiService(url: ApiEndPoints().getCustomerJobs);
  final BaseApiService _apiSupplierCompletedJobs =
      NetworkApiService(url: ApiEndPoints().supplierCompletedJobs);
  final BaseApiService _apiSupplierInProgressJobs =
      NetworkApiService(url: ApiEndPoints().supplierInProgressJobs);
  final BaseApiService _apiSupplierBookedJobs =
      NetworkApiService(url: ApiEndPoints().supplierBookedJobs);
  final BaseApiService _apiSupplierOpenJobs =
      NetworkApiService(url: ApiEndPoints().supplierOpenJobs);
  final BaseApiService _apiFinishJob =
      NetworkApiService(url: ApiEndPoints().supplierFinishJob);
  final BaseApiService _apiPayJob =
      NetworkApiService(url: ApiEndPoints().payJob);
  final BaseApiService _apiFinishJobAndCollectPayment =
      NetworkApiService(url: ApiEndPoints().finishJobAndCollectPayment);
  final BaseApiService _apiStartJob =
      NetworkApiService(url: ApiEndPoints().supplierStartJob);
  final BaseApiService _apiIgnoreJob =
      NetworkApiService(url: ApiEndPoints().supplierIgnoreJob);
  final BaseApiService _apiAcceptJob =
      NetworkApiService(url: ApiEndPoints().supplierAcceptJob);
  final BaseApiService _apiUpdateJob =
      NetworkApiService(url: ApiEndPoints().updateJob);
  final BaseApiService _apiUpdateJobCustomer =
      NetworkApiService(url: ApiEndPoints().updateJobCustomer);
  final BaseApiService _apiRateJob =
      NetworkApiService(url: ApiEndPoints().rateJob);
  final BaseApiService _apiCancelBooking =
      NetworkApiService(url: ApiEndPoints().supplierCancelBooking);
  final BaseApiService _apicancelJobNoPenalty =
      NetworkApiService(url: ApiEndPoints().customerCancelJobNoPenalty);
  final BaseApiService _apicancelJobWithPenalty =
      NetworkApiService(url: ApiEndPoints().customerCancelJobWithPenalty);
  final BaseApiService _apiInvoice =
      NetworkApiService(url: ApiEndPoints().invoices);
  final BaseApiService _apiAddJob =
      NetworkApiService(url: ApiEndPoints().addJob);
  final BaseApiService _apiInitiateJobPayment =
      NetworkApiService(url: ApiEndPoints().initiateJobPayment);
  final BaseApiService _apiInitiateExtraPayment =
      NetworkApiService(url: ApiEndPoints().initiateExtraPayment);
  final BaseApiService _apiPendingPayments =
      NetworkApiService(url: ApiEndPoints().pendingPayments);
  // final BaseApiService _apiCustomerInvoice =
  //     NetworkApiService(url: ApiEndPoints().customerInvoice);
  // final BaseApiService _apiSupplierInvoice =
  //     NetworkApiService(url: ApiEndPoints().supplierInvoice);

  Future<JobsModelMain?> getCustomerJobs() async {
    try {
      String? id = await getUserId();
      dynamic response =
          await _apiCustomerJobs.postResponse(data: {'user_id': id});
      final jsonData = JobsModelMain.fromJson(response);
      return jsonData;
    } catch (error) {
      debugPrint('error in getting completed jobs $error');
      rethrow;
    }
  }

  Future<JobsModelMain?> getSupplierCompletedJobs() async {
    try {
      String? id = await getUserId();

      String role = await getRole();
      dynamic response =
          await _apiSupplierCompletedJobs.getResponse(params: '?user=$id');

      final jsonData = JobsModelMain.fromJson(response);
      return jsonData;
    } catch (error) {
      debugPrint('error in getting completed jobs $error');
      rethrow;
    }
  }

  Future<JobsModelMain?> getSupplierInProgressJobs() async {
    try {
      String? id = await getUserId();
      dynamic response =
          await _apiSupplierInProgressJobs.getResponse(params: '?user=$id');

      final jsonData = JobsModelMain.fromJson(response);
      debugPrint('$jsonData');
      return jsonData;
    } catch (error) {
      debugPrint('error in getting in progress jobs $error');
      rethrow;
    }
  }

  Future<JobsModelMain?> getSupplierBookedJobs() async {
    try {
      String? id = await getUserId();
      String role = await getRole();
      dynamic response =
          await _apiSupplierBookedJobs.getResponse(params: '?user=$id');

      final jsonData = JobsModelMain.fromJson(response);
      return jsonData;
    } catch (error) {
      debugPrint('error in getting booked jobs $error');
      rethrow;
    }
  }

  Future<JobsModelMain?> getSupplierOpenJobs() async {
    try {
      String? id = await getUserId();
      dynamic response =
          await _apiSupplierOpenJobs.getResponse(params: '?user=$id');
      final jsonData = JobsModelMain.fromJson(response);
      return jsonData;
    } catch (error) {
      debugPrint('error in getting open jobs $error');
      rethrow;
    }
  }

  Future<dynamic> finishJob(int job_id) async {
    try {
      String? id = await getUserId();
      dynamic response = await _apiFinishJob
          .postResponse(data: {"supplier_id": id, "job_id": job_id});
      return response;
    } catch (error) {
      debugPrint('error in getting finished jobs $error');
      rethrow;
    }
  }

  Future<dynamic> payJob(int job_id, dynamic customer_id) async {
    try {
      // String? id = await getUserId();
      dynamic response = await _apiPayJob
          .postResponse(data: {"customer_id": customer_id, "job_id": job_id});
      // final jsonData = JobsModelMain.fromJson(response["data"]);
      return response;
    } catch (error) {
      debugPrint('error in getting payed jobs $error');
      rethrow;
    }
  }

  Future<dynamic> finishJobAndCollectPayment(int job_id) async {
    try {
      // String? id = await getUserId();
      dynamic response = await _apiFinishJobAndCollectPayment
          .postResponse(data: {"job_id": job_id});
      // final jsonData = JobsModelMain.fromJson(response["data"]);
      return response;
    } catch (error) {
      debugPrint('error in getting payed jobs $error');
      rethrow;
    }
  }

  Future<dynamic> startJob(int job_id) async {
    try {
      String? id = await getUserId();

      dynamic response = await _apiStartJob
          .postResponse(data: {"supplier_id": id, "job_id": job_id});
      return response;
    } catch (error) {
      debugPrint('error in getting start jobs $error');
      rethrow;
    }
  }

  Future<dynamic> ignoreJob(int job_id) async {
    try {
      String? id = await getUserId();

      dynamic response = await _apiIgnoreJob
          .postResponse(data: {"supplier_id": id, "job_id": job_id});
      return response;
    } catch (error) {
      debugPrint('error in ignoring jobs $error');
      rethrow;
    }
  }

  Future<dynamic> acceptJob(int job_id, dynamic body) async {
    try {
      String? id = await getUserId();
      dynamic response = await _apiAcceptJob.postResponse(data: {
        "supplier_id": id,
        "job_id": job_id,
        "supplier_to_job_distance": body["supplier_to_job_distance"],
        "supplier_to_job_time": body["supplier_to_job_time"]
      });
      debugPrint('response book or accept jobs $response');
      return response;
    } catch (error) {
      debugPrint('error in getting book jobs $error');
      rethrow;
    }
  }

  Future<dynamic> updateJob(int job_id, dynamic body) async {
    try {
      String? id = await getUserId();
      String role = await getRole();
      body["job_id"] = job_id;
      dynamic response;
      if (Constants.supplierRoleId == role) {
        body["supplier_id"] = id;
        response = await _apiUpdateJob.postResponse(data: body);
      } else {
        body["customer_id"] = id;
        response = await _apiUpdateJobCustomer.postResponse(data: body);
      }

      return response;
    } catch (error) {
      debugPrint('error in getting book jobs $error');
      rethrow;
    }
  }

  Future<dynamic> rateJob(int job_id, dynamic body) async {
    try {
      String? id = await getUserId();
      String role = await getRole();
      body["job_id"] = job_id;
      dynamic response;

      body["customer_id"] = id;
      response = await _apiRateJob.postResponse(data: body);

      return response;
    } catch (error) {
      debugPrint('error in getting book jobs $error');
      rethrow;
    }
  }

  Future<dynamic> downloadInvoice(int job_id) async {
    try {
      String? id = await getUserId();
      String? role = await getRole();
      dynamic response;

      if (role == Constants.customerRoleId) {
        response = await _apiInvoice.getResponseFile(
            params: "?job_id=$job_id&format=customer");
      } else {
        response = await _apiInvoice.getResponseFile(
            params: "?job_id=$job_id&format=supplier");
      }
      debugPrint('response of the downloaded invoice $response');
      return response;
    } catch (error) {
      debugPrint('error in downloading invoice $error');
      rethrow;
    }
  }

  Future<dynamic> cancelBooking(int job_id, String reason) async {
    try {
      String? id = await getUserId();
      dynamic response = await _apiCancelBooking.postResponse(data: {
        "supplier_id": id,
        "job_id": job_id,
        "reason": reason,
        "cancellation_reason": reason,
      });
      return response;
    } catch (error) {
      debugPrint('error in cancel booking $error');
      rethrow;
    }
  }

  Future<dynamic> cancelJobNoPenalty(int job_id, String reason) async {
    try {
      String? id = await getUserId();
      dynamic response = await _apicancelJobNoPenalty.postResponse(data: {
        "customer_id": id,
        "job_id": job_id,
        "reason": reason,
        "cancellation_reason": reason,
      });
      return response;
    } catch (error) {
      debugPrint('error in cancel booking $error');
      rethrow;
    }
  }

  Future<dynamic> cancelJobWithPenalty(
      int job_id, String reason, String action) async {
    try {
      String? id = await getUserId();
      dynamic response = await _apicancelJobWithPenalty.postResponse(data: {
        "customer_id": id,
        "job_id": job_id,
        "reason": reason,
        "cancellation_reason": reason,
        "action": action,
      });

      debugPrint('response cancel booking  $response');
      return response;
    } catch (error) {
      debugPrint('error in cancel booking $error');
      rethrow;
    }
  }

  Future<dynamic> postNewJobRequest(dynamic body) async {
    try {
      String currentUser = await getUserId();
      final source = Map<String, dynamic>.from(body as Map);

      // Only send fields the addJob endpoint expects.
      final requestBody = <String, dynamic>{
        'customer': currentUser,
        'service': source['service'],
        'job_address': source['job_address'] is Map
            ? source['job_address']['id']
            : source['job_address'],
        'start_date': source['start_date'],
        'job_type': source['job_type'] ?? 'work',
        'severity_level': source['severity_level'],
        'payment_method': source['payment_method'] ?? 'Card',
        'tap_payments_card': source['tap_payments_card'],
        'latitude': source['latitude'],
        'longitude': source['longitude'],
      };

      final units = source['number_of_units'];
      if (units != null) {
        requestBody['number_of_units'] =
            int.tryParse(units.toString()) ?? units;
      }
      if (source['job_description'] != null &&
          source['job_description'].toString().trim().isNotEmpty) {
        requestBody['job_description'] = source['job_description'];
      }
      if (source['media'] != null) {
        requestBody['media'] = source['media'];
      }

      debugPrint('jobs body issss $requestBody');
      dynamic response = await _apiAddJob.postResponse(data: requestBody);
      debugPrint('response adding new job ${response}');
      return response;
    } catch (error) {
      debugPrint('error in post jobs repo ${error}');
      rethrow;
    }
  }

  Future<dynamic> initiateJobPayment(int jobId) async {
    try {
      return await _apiInitiateJobPayment.postResponse(data: {
        'job_id': jobId.toString(),
      });
    } catch (error) {
      debugPrint('error initiating job payment $error');
      rethrow;
    }
  }

  Future<dynamic> initiateExtraPayment(int jobId) async {
    try {
      return await _apiInitiateExtraPayment.postResponse(data: {
        'job_id': jobId.toString(),
      });
    } catch (error) {
      debugPrint('error initiating extra payment $error');
      rethrow;
    }
  }

  Future<dynamic> getPendingPayments() async {
    try {
      return await _apiPendingPayments.getResponse();
    } catch (error) {
      debugPrint('error getting pending payments $error');
      rethrow;
    }
  }

  Future<String> getUserId() async {
    try {
      final token = await AppPreferences().get(key: userIdKey, isModel: false);
      return token ?? '';
    } catch (err) {
      return '';
    }
  }

  Future<String> getRole() async {
    try {
      final role = await AppPreferences().get(key: userRoleKey, isModel: false);
      return role ?? '';
    } catch (err) {
      return '';
    }
  }
}
