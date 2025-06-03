import 'dart:io';

import 'package:dingdone/models/jobs_model.dart';
import 'package:dingdone/repository/jobs/jobs_repository.dart';
import 'package:dingdone/res/app_prefs.dart';
import 'package:dingdone/res/constants.dart';
import 'package:flutter/material.dart';
import 'package:dingdone/data/remote/response/ApiResponse.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../res/app_validation.dart';
import '../../res/strings/english_strings.dart';

class JobsViewModel with ChangeNotifier {
  final JobsRepository _jobsRepository = JobsRepository();
  ApiResponse<JobsModel> _jobsResponse = ApiResponse.loading();
  List<JobsModel>? _jobsList = List.empty();
  List<JobsModel>? _customerjobsList = List.empty();
  List<JobsModel>? _supplierCompletedJobs = List.empty();
  List<JobsModel>? _supplierInProgressJobs = List.empty();
  List<JobsModel>? _supplierBookedJobs = List.empty();
  List<JobsModel>? _supplierOpenJobs = List.empty();
  List<JobsModel>? _customerPay = List.empty();
  ApiResponse<JobsModelMain> _apiJobsResponse = ApiResponse.loading();
  ApiResponse<JobsModelMain> _apiCustomerJobsResponse = ApiResponse.loading();
  ApiResponse<JobsModelMain> _apiSupplierCompletedJobsResponse =
      ApiResponse.loading();
  ApiResponse<JobsModelMain> _apiSupplierInProgressJobsResponse =
      ApiResponse.loading();
  ApiResponse<JobsModelMain> _apiSupplierBookedJobsResponse =
      ApiResponse.loading();
  ApiResponse<JobsModelMain> _apiSupplierOpenJobsResponse =
      ApiResponse.loading();
  ApiResponse<JobsModelMain> _apiCustomerPayResponse = ApiResponse.loading();
  Map<String, dynamic> jobsBody = {};
  Map<String, dynamic> _updatedBody = {};
  Map<String, dynamic> _addressBody = {};
  String? _role = '';
  String? _errorMessage = '';
  bool _jobUpdated = true;
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);
  String _selectedReason = '';
  bool _showCustomTextArea = false;
  bool _addressSaved = false;

  dynamic _file;
  Map<String?, String?> jobsAddressError = {};

  JobsViewModel() {
    debugPrint('hehehehe');
    readJson();
  }

  Future<void> readJson() async {
    await getRole();
    // await getJobs();
    // debugPrint('supplier gettiong jobs ');

    if (Constants.supplierRoleId == _role) {
      debugPrint('supplier gettiong jobs ');
      await getSupplierCompletedJobs();
      await getSupplierInProgressJobs();
      await getSupplierBookedJobs();
      await getSupplierOpenJobs();
    } else {
      debugPrint('customer gettiong jobs ');

      await getCustomerJobs();
    }
  }

  Future<void> getRole() async {
    try {
      _role = await AppPreferences().get(key: userRoleKey, isModel: false);
    } catch (err) {
      return;
    }
  }

  Future<dynamic> getUpdatedJobsBody() async {
    try {
      notifyListeners();
      return jobsBody;
    } catch (err) {
      return;
    }
  }

  Future<bool?> getJobs() async {
    try {
      dynamic response = await _jobsRepository.getAllJobs();
      _apiJobsResponse = ApiResponse.completed(response);
      _jobsList = _apiJobsResponse.data?.jobs;
      notifyListeners();
    } catch (error) {
      debugPrint('Error fetching jobs ${error}');
    }
    notifyListeners();
    return true;
  }

  bool validate() {
    jobsAddressError = {};
    String? streetMessage = '';
    String? buildingMessage = '';
    String? apartmentMessage = '';
    String? cityMessage = '';
    String? zoneMessage = '';
    String? countryMessage = '';
    String? floorMessage = '';
    String? longitudeMessage = '';
    String? latitudeMessage = '';

    streetMessage = AppValidation().isNotEmpty(
        value:
            jobsBody[EnglishStrings().formKeys['street_number']!] ?? '',
        index: 'Street Number');
    buildingMessage = AppValidation().isNotEmpty(
        value:
        jobsBody[EnglishStrings().formKeys['building_number']!] ??
                '',
        index: 'Building Number');
    apartmentMessage = AppValidation().isNotEmpty(
        value:
        jobsBody[EnglishStrings().formKeys['apartment_number']!] ??
                '',
        index: 'Apartment Number');
    cityMessage = AppValidation().isNotEmpty(
        value: jobsBody[EnglishStrings().formKeys['city']!] ?? '',
        index: 'City');
    zoneMessage = AppValidation().isNotEmpty(
        value: jobsBody[EnglishStrings().formKeys['zone']!] ?? '',
        index: 'Zone');
    countryMessage = AppValidation().isNotEmpty(
        value: jobsBody[EnglishStrings().formKeys['country']!] ?? '',
        index: 'Country');
    floorMessage = AppValidation().isNotEmpty(
        value: jobsBody[EnglishStrings().formKeys['floor']!] ?? '',
        index: 'Floor');

    longitudeMessage = AppValidation().isNotEmpty(
        value: jobsBody['longitude'] ?? '', index: 'Longitude');
    latitudeMessage = AppValidation().isNotEmpty(
        value: jobsBody['latitude'] ?? '', index: 'Latitude');

    if (streetMessage == null &&
        buildingMessage == null &&
        apartmentMessage == null &&
        cityMessage == null &&
        zoneMessage == null &&
        countryMessage == null &&
        floorMessage == null &&
        jobsBody['longitude'] != null &&
        jobsBody['latitude'] != null) {
      notifyListeners();
      return true;
    }

    jobsAddressError[EnglishStrings().formKeys['street_number']!] =
        streetMessage;
    jobsAddressError[EnglishStrings().formKeys['building_number']!] =
        buildingMessage;
    jobsAddressError[EnglishStrings().formKeys['apartment_number']!] =
        apartmentMessage;
    jobsAddressError[EnglishStrings().formKeys['city']!] = cityMessage;
    jobsAddressError[EnglishStrings().formKeys['zone']!] = zoneMessage;
    jobsAddressError[EnglishStrings().formKeys['country']!] = countryMessage;
    jobsAddressError[EnglishStrings().formKeys['floor']!] = floorMessage;
    jobsAddressError[EnglishStrings().formKeys['longitude']!] =
        longitudeMessage;
    jobsAddressError[EnglishStrings().formKeys['latitude']!] = latitudeMessage;

    notifyListeners();
    return false;
  }

  Future<bool?> getCustomerJobs() async {
    try {
      debugPrint('customers jooob}');
      dynamic response = await _jobsRepository.getCustomerJobs();
      _apiCustomerJobsResponse = ApiResponse.completed(response);
      _customerjobsList = _apiCustomerJobsResponse.data?.jobs;
      _customerjobsList?.sort((a, b) {
        DateTime startDateA = DateTime.parse(a.start_date!);
        DateTime startDateB = DateTime.parse(b.start_date!);
        return startDateB.compareTo(startDateA); // Sorts in ascending order
      });
      debugPrint('customer jobs list ${_customerjobsList}');
      debugPrint('customer jobs list  media 1 ${_customerjobsList![1].uploaded_media}');
      notifyListeners();
    } catch (error) {
      debugPrint('Error fetching jobs ${error}');
    }
    notifyListeners();
    return true;
  }

  Future<bool?> getSupplierCompletedJobs() async {
    try {
      dynamic response = await _jobsRepository.getSupplierCompletedJobs();
      _apiSupplierCompletedJobsResponse = ApiResponse.completed(response);
      _supplierCompletedJobs = _apiSupplierCompletedJobsResponse.data?.jobs;
      _supplierCompletedJobs?.sort((a, b) {
        DateTime startDateA = DateTime.parse(a.start_date!);
        DateTime startDateB = DateTime.parse(b.start_date!);
        return startDateB.compareTo(startDateA); // Sorts in ascending order
      });
      notifyListeners();
    } catch (error) {
      debugPrint('Error fetching jobs ${error}');
    }
    notifyListeners();
    return true;
  }

  Future<bool?> getSupplierInProgressJobs() async {
    try {
      dynamic response = await _jobsRepository.getSupplierInProgressJobs();
      _apiSupplierInProgressJobsResponse = ApiResponse.completed(response);
      _supplierInProgressJobs = _apiSupplierInProgressJobsResponse.data?.jobs;
      _supplierInProgressJobs?.sort((a, b) {
        DateTime startDateA = DateTime.parse(a.start_date!);
        DateTime startDateB = DateTime.parse(b.start_date!);
        return startDateB.compareTo(startDateA); // Sorts in ascending order
      });
      debugPrint(
          'response in progress jobs ${_supplierInProgressJobs?.first.service}');

      notifyListeners();
    } catch (error) {
      debugPrint('Error fetching jobs ${error}');
    }
    notifyListeners();
    return true;
  }

  Future<bool?> getSupplierBookedJobs() async {
    try {
      dynamic response = await _jobsRepository.getSupplierBookedJobs();
      _apiSupplierBookedJobsResponse = ApiResponse.completed(response);
      _supplierBookedJobs = _apiSupplierBookedJobsResponse.data?.jobs;
      _supplierBookedJobs?.sort((a, b) {
        DateTime startDateA = DateTime.parse(a.start_date!);
        DateTime startDateB = DateTime.parse(b.start_date!);
        return startDateB.compareTo(startDateA); // Sorts in ascending order
      });
      notifyListeners();
    } catch (error) {
      debugPrint('Error fetching booked jobs ${error}');
    }
    notifyListeners();
    return true;
  }

  Future<bool?> getSupplierOpenJobs() async {
    try {
      dynamic response = await _jobsRepository.getSupplierOpenJobs();
      _apiSupplierOpenJobsResponse = ApiResponse.completed(response);
      _supplierOpenJobs = _apiSupplierOpenJobsResponse.data?.jobs;
      debugPrint('getting supplier open jobs $_supplierOpenJobs');

      notifyListeners();
    } catch (error) {
      debugPrint('Error fetching jobs ${error}');
    }
    notifyListeners();
    return true;
  }

  Future<bool?> finishJob(int id) async {
    try {
      dynamic response = await _jobsRepository.finishJob(id);
      if (response["status"] == 'OK') {
        readJson();
        notifyListeners();
        return true;
      } else {
        _errorMessage = response["reason"];
        notifyListeners();
        return false;
      }
    } catch (error) {
      debugPrint('Error fetching jobs ${error}');
    }
    notifyListeners();
    return true;
  }

  Future<bool?> payFees(int id,dynamic customer_id) async {
    try {
      dynamic response = await _jobsRepository.payJob(id,customer_id);
      // _apiCustomerPayResponse = ApiResponse.completed(response);
      // _customerPay = _apiCustomerPayResponse.data?.jobs;
      debugPrint('Response of paying fees ${response["status"]}');
      if (response["status"] == 'OK') {
        readJson();
        notifyListeners();
        return true;
      } else {
        _errorMessage = response["reason"];
        notifyListeners();
        return false;
      }
    } catch (error) {
      debugPrint('Error fetching jobs ${error}');
      return false;
    }
    notifyListeners();

    return true;
  }

  Future<bool?> finishJobAndCollectPayment(int id) async {
    try {
      dynamic response = await _jobsRepository.finishJobAndCollectPayment(id);
      // _apiCustomerPayResponse = ApiResponse.completed(response);
      // _customerPay = _apiCustomerPayResponse.data?.jobs;
      debugPrint('Response of finishing job and paying fees ${response}');
      if (response["status"] == 'OK') {
        readJson();
        notifyListeners();
        return true;
      } else {
        _errorMessage = response["reason"] ?? response["error"];
        notifyListeners();
        return false;
      }
    } catch (error) {
      debugPrint('Error finishing job and paying fees ${error}');
      return false;
    }
    notifyListeners();

    return true;
  }

  Future<bool?> startJob(int id) async {
    try {
      dynamic response = await _jobsRepository.startJob(id);
      readJson();
      notifyListeners();
      if (response["status"] == "OK") {
        return true;
      } else {
        _errorMessage = response["reason"];
        return false;
      }
    } catch (error) {
      debugPrint('Error fetching jobs ${error}');
      return false;
    }
    // notifyListeners();
    // return true;
  }

  Future<bool?> ignoreJob(int id) async {
    try {
      dynamic response = await _jobsRepository.ignoreJob(id);
      // readJson();
      // notifyListeners();
      if (response["status"] == "OK") {
        readJson();
        return true;
      } else {
        _errorMessage = response["reason"];
        return false;
      }
    } catch (error) {
      debugPrint('Error ignoring jobs ${error}');
      return false;
    }
  }

  Future<bool?> acceptJob(dynamic data) async {
    try {
      debugPrint('Estimated time to reach currentPosition: ${data} minutes');
      try {
        Position currentPosition = await Geolocator.getCurrentPosition();
        // debugPrint('Estimated customer address: ${data.customer["address"]} minutes');
        debugPrint('currentPosition: ${currentPosition.toString()}');
        debugPrint(
            'job position: ${data.job_address["latitude"]} ${data.job_address["longitude"]} minutes');

        // Calculate the distance and duration to the customer's location
        double distance = await Geolocator.distanceBetween(
          currentPosition.latitude,
          currentPosition.longitude,
          data.job_address["latitude"],
          data.job_address["longitude"],
        );
        debugPrint('Estimated time to reach distance: ${distance} minutes');

        Duration duration = Duration(
            seconds: (distance / 100)
                .round()); // Adjust this based on your requirements

        // Now you have the estimated duration to reach the customer's location
        debugPrint(
            'Estimated time to reach customer: ${duration.inMinutes} minutes');
        // await _jobsRepository.updateJob(data.id,{"supplier_to_job_distance":distance.toString(),"supplier_to_job_time":duration.inMinutes});

        dynamic response = await _jobsRepository.acceptJob(data.id, {
          "supplier_to_job_distance": distance.toString(),
          "supplier_to_job_time": duration.inMinutes
        });
        readJson();
        notifyListeners();
        if (response["status"] == "OK") {
          return true;
        } else {
          _errorMessage = response["reason"];
          return false;
        }
      } catch (error) {
        debugPrint('Error calculating distance: $error');
      }
    } catch (error) {
      debugPrint('Error fetching jobs ${error}');
    }
    notifyListeners();
    return true;
  }

  Future<bool?> updateJob(int id) async {
    try {
      dynamic res = await _jobsRepository.updateJob(id, _updatedBody);
      readJson();
      notifyListeners();
      _jobUpdated = true;
      if (res["status"] == "OK") {
        return true;
      } else {
        return false;
      }
    } catch (error) {
      debugPrint('Error fetching jobs $error');
      return false;
    }
  }

  Future<bool?> rateJob(int id) async {
    try {
      dynamic res = await _jobsRepository.rateJob(id, _updatedBody);
      readJson();
      notifyListeners();
      _jobUpdated = true;
      if (res["status"] == "OK") {
        return true;
      } else {
        return false;
      }
    } catch (error) {
      debugPrint('Error fetching jobs ${error}');
      return false;
    }

    return true;
  }


  Future<dynamic>? downloadInvoice(int id) async {
    try {
      dynamic res = await _jobsRepository.downloadInvoice(id);
      if (res != null) {
        debugPrint('file downloaded');
        _file = res;
        notifyListeners();
        return _file;
      } else {
        debugPrint('error in file downloading');
        return _file;
      }
    } catch (error) {
      debugPrint('Error downloading invoice  $error');
      // return null;
    }

    return File('');
  }

  Future<bool?> cancelBooking(int id) async {
    debugPrint('cancellation reason bookik ${jobsBody['cancellation_reason']}');
    try {
      dynamic response = await _jobsRepository.cancelBooking(
          id, jobsBody['cancellation_reason']);
      readJson();
      notifyListeners();
      debugPrint('${response['status']}');
      if (response["status"] == "OK") {
        return true;
      } else {
        _errorMessage = response["reason"];
        return false;
      }
    } catch (error) {
      debugPrint('Error fetching jobs $error');
      return false;
    }
  }

  Future<bool?> cancelJobNoPenalty(int id) async {
    debugPrint(
        'cancellation reason no penalty${jobsBody['cancellation_reason']}');
    try {
      dynamic response = await _jobsRepository.cancelJobNoPenalty(
          id, jobsBody['cancellation_reason'].toString());
      readJson();
      notifyListeners();
      if (response["status"] == "OK") {
        return true;
      } else {
        _errorMessage = response["reason"];
        return false;
      }
    } catch (error) {
      debugPrint('Error fetching jobs ${error}');
      return false;
    }
  }

  Future<bool?> cancelJobWithPenalty(int id) async {
    debugPrint(
        'cancellation reason with penalty  ${jobsBody['cancellation_reason']}');
    try {
      dynamic response = await _jobsRepository.cancelJobWithPenalty(
          id, jobsBody['cancellation_reason']);
      readJson();
      notifyListeners();
      if (response["status"] == "OK") {
        return true;
      } else {
        _errorMessage = response["reason"];
        return false;
      }
    } catch (error) {
      debugPrint('Error fetching jobs $error');
      return false;
    }
  }

  Future<bool> requestService() async {
    try {
      int year = selectedDate.year;
      int month = selectedDate.month;
      int day = selectedDate.day;

      debugPrint('tiiiimee iss ${jobsBody['time']}');
      jobsBody['job_type'] = 'work';

      if (jobsBody['time'] == null) {
        // Get the current time directly using TimeOfDay.now()
        TimeOfDay now = TimeOfDay.now();
        selectedTime = now;

        debugPrint('Selected time: $selectedTime'); // Your selected time
      }

      int hour = selectedTime.hour;
      int minute = selectedTime.minute;

      DateTime combinedDateTime = DateTime(year, month, day, hour, minute);
      debugPrint('combinedDateTime $combinedDateTime');

      // Get the current date and time
      DateTime currentDateTime = DateTime.now();

      // Calculate the time two hours from now
      DateTime twoHoursFromNow = currentDateTime.add(Duration(hours: 2));

      // Check if the combinedDateTime is between now and two hours from now
      if (
      // combinedDateTime.isAfter(currentDateTime) &&
      combinedDateTime.isBefore(twoHoursFromNow)) {
        jobsBody['severity_level'] = 'major';
      }else{
        jobsBody['severity_level'] = 'minor';
      }

      setInputValues(index: 'start_date', value: combinedDateTime.toString());

      if (jobsBody['tap_payments_card'] == null) {
        return false;
      } else {
        dynamic response = await _jobsRepository.postNewJobRequest(jobsBody);
        _jobsResponse = ApiResponse<JobsModel>.completed(response);
      }

      return true;
    } catch (error) {
      _jobsResponse = ApiResponse<JobsModel>.error(error.toString());
      return false;
    }
  }


  void setInputValues({required String index, dynamic value}) {
    _addressSaved=false;
    jobsBody[index] = value;
    debugPrint('jobsBody $jobsBody');
    debugPrint('hhhh $index $value');
    if (index == 'date') {
      final inputFormat = DateFormat('dd-MM-yyyy');
      // Parse the input date string
      selectedDate = inputFormat.parse(value);
      // selectedDate = DateTime.parse(value);
    } // Your selected date

    if (index == 'time') {
      // Extract the time part from the TimeOfDay string
      RegExp regExp = RegExp(r'TimeOfDay\((\d+):(\d+)\)');
      Match? match = regExp.firstMatch(value);

      if (match != null) {
        // Parse the hours and minutes
        int hours = int.parse(match.group(1)!);
        int minutes = int.parse(match.group(2)!);
        selectedTime = TimeOfDay(hour: hours, minute: minutes);
        print('Selected time: $selectedTime'); // Your selected time
      } else {
        print('Invalid time format: $value');
      }
    }
    if (index == 'cancellation_reason') {
      _selectedReason = value;
    }

    notifyListeners();
  }

  void clearJobsBody() {
    jobsBody={};


    notifyListeners();
  }
  void setInputValuesWithoutNotify({required String index, dynamic value}) {
    jobsBody[index] = value;
    debugPrint('jobsBody $jobsBody');
    debugPrint('hhhh $index $value');
    if (index == 'date') {
      final inputFormat = DateFormat('dd-MM-yyyy');
      // Parse the input date string
      selectedDate = inputFormat.parse(value);
      // selectedDate = DateTime.parse(value);
    } // Your selected date

    if (index == 'time') {
      // Extract the time part from the TimeOfDay string
      RegExp regExp = RegExp(r'TimeOfDay\((\d+):(\d+)\)');
      Match? match = regExp.firstMatch(value);
      if (match != null) {
        // Parse the hours and minutes
        int hours = int.parse(match.group(1)!);
        int minutes = int.parse(match.group(2)!);
        selectedTime = TimeOfDay(hour: hours, minute: minutes);
        print('Selected time: $selectedTime'); // Your selected time
      } else {
        print('Invalid time format: $value');
      }
    }
    if (index == 'cancellation_reason') {
      _selectedReason = value;
    }
  }

  void setUpdatedJob({required String index, dynamic value}) {
    debugPrint('_updatedBody $_updatedBody $value');
    if ((index == 'tap_payments_card' || index == 'payment_method') &&
        userRole == Constants.supplierRoleId) {
    } else {
      _updatedBody[index] = value;
      debugPrint('_updatedBody $_updatedBody $value');
    }
    _jobUpdated = false;
    debugPrint('hhhh $index $value');
    notifyListeners();
  }

  void setSaved(bool value) {
   _addressSaved=value;
    notifyListeners();
  }

  void setUpdatedJobWithoutNotify({required String index, dynamic value}) {
    if ((index == 'tap_payments_card' || index == 'payment_method') &&
        userRole == Constants.supplierRoleId) {
    } else {
      _updatedBody[index] = value;
    }
    _jobUpdated = false;
    debugPrint('hhhh $index $value');

  }

  // void launchWhatsApp() async {
  //   String phoneNumber =
  //       '+97451112825'; // Replace with the actual WhatsApp number
  //   String message =
  //       'Hello, I would like to inquire about online consultation.'; // Your default message
  //
  //   String whatsappUrl =
  //       'https://wa.me/$phoneNumber?text=${Uri.encodeQueryComponent(message)}';
  //
  //   if (await canLaunch(whatsappUrl)) {
  //     await launch(whatsappUrl);
  //   } else {
  //     // Handle the error
  //     debugPrint('Could not launch WhatsApp.');
  //   }
  // }
  void launchWhatsApp() async {
    String phoneNumber = '97451112825'; // Remove the '+' sign
    String message = 'Hello, I would like to inquire about online consultation.';
    String whatsappUrl = 'whatsapp://send?phone=$phoneNumber&text=${Uri.encodeQueryComponent(message)}';

    if (await canLaunch(whatsappUrl)) {
      await launch(whatsappUrl);
    } else {
      debugPrint('Could not launch WhatsApp.');
    }
  }

  void setShowCustomTextArea(bool show) {
    _showCustomTextArea = show;
    notifyListeners();
  }

  // get isActive => _userModelResponse.data?.status == 'active';
  get jobsList => _jobsList;

  get supplierCompletedJobs => _supplierCompletedJobs;

  get supplierInProgressJobs => _supplierInProgressJobs;

  get supplierBookedJobs => _supplierBookedJobs;

  get supplierOpenJobs => _supplierOpenJobs;

  get getjobsBody => jobsBody;

  get getcustomerJobs => _customerjobsList;

  get userRole => _role;

  get updatedBody => _updatedBody;

  get jobUpdated => _jobUpdated;

  get selectedReason => _selectedReason;

  get errorMessage => _errorMessage;

  get showCustomTextArea => _showCustomTextArea;

  get file => _file;
  get saved => _addressSaved;
}
