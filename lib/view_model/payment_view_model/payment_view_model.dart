import 'package:dingdone/data/remote/response/ApiResponse.dart';
import 'package:dingdone/models/payments_model.dart';
import 'package:dingdone/repository/payments/payments_repository.dart';
import 'package:dingdone/res/app_prefs.dart';
import 'package:dingdone/view_model/dispose_view_model/dispose_view_model.dart';
import 'package:dingdone/view_model/jobs_view_model/jobs_view_model.dart';
import 'package:flutter/foundation.dart';
import '../profile_view_model/profile_view_model.dart';

class PaymentViewModel extends DisposableViewModel {
  Map<String, dynamic> paymentBody = {};
  bool _isloading=false;
  late ProfileViewModel _profileViewModel;
  late JobsViewModel _jobsViewModel;
  PaymentsRepository _paymentsRepository = PaymentsRepository();
  ApiResponse<PaymentsModelMain> _paymentsResponse = ApiResponse.loading();

  List<dynamic> _paymentsList = List.empty();
  List<dynamic> _paymentCards = List.empty();

  Map<String?, String?> paymentError = {};

  PaymentViewModel(ProfileViewModel profileViewModel) {
    _profileViewModel = profileViewModel;
    // getPaymentMethodsTap();
    // if(_profileViewModel.profileBody["user"]["role"]==Constants.customerRoleId){
    //   getPaymentMethods();
    //
    // }else{
    //   getCustomerPayments(_profileViewModel.profileBody["user"]["id"]);
    // }
  }

  Future<void> readJson() async {}

  get errorMsg => null;

  void setInputValues({required String index, dynamic value}) {
    paymentBody[index] = value;
    debugPrint('payment body ${paymentBody}');
  }

  Future<List<dynamic>?> getPaymentMethods() async {
    try {
      var response = await _paymentsRepository
          .getPayments(int.parse('${_profileViewModel.getProfileBody["id"]}'));
      _paymentsResponse = await ApiResponse.completed(response);
      _paymentsList = _paymentsResponse.data?.toJson()["payments"];
      // notifyListeners();
      return _paymentsList;
    } catch (e) {
      debugPrint('error in getting payments $e');
      return [];
    }
  }

  String? _serverMessage(dynamic response) {
    if (response is! Map) return null;
    if (response['status'] != 'NOT_OK') return null;
    final message = response['message'] ?? response['error'] ?? response['reason'];
    if (message == null || message.toString().trim().isEmpty) {
      return 'Request failed';
    }
    return message.toString();
  }

  Future<dynamic> getPaymentMethodsTap() async {
    try {
      final response = await _paymentsRepository.getCustomerCards();
      final failure = _serverMessage(response);
      if (failure != null) {
        debugPrint('error in getting payments tap $failure');
        _paymentCards = [];
        notifyListeners();
        return [];
      }
      final cards = response is Map ? response['cards'] : null;
      _paymentCards = cards is List ? cards : [];
      notifyListeners();
      return _paymentCards;
    } catch (e) {
      debugPrint('error in getting payments tap $e');
      return [];
    }
  }

  Future<List<dynamic>?> getCustomerPayments(dynamic customer_id) async {
    try {
      var response = await _paymentsRepository.getPayments(customer_id);
      _paymentsResponse = await ApiResponse.completed(response);
      _paymentsList = _paymentsResponse.data?.toJson()["payments"];
      notifyListeners();
      return _paymentsList;
    } catch (e) {
      debugPrint('error in getting payments $e');
      return [];
    }
  }

  // Future<void> deletePaymentMethod(dynamic id) async {
  //   Map<String, dynamic> body = {};
  //   body["card_id"] = id.toString();
  //   try {
  //     dynamic response = _paymentsRepository.deletePaymentCard(body);
  //
  //     debugPrint('response deleting card $response');
  //   } catch (e) {
  //     debugPrint('error in deleting payment $e');
  //   }
  // }
  Future<void> deletePaymentMethod(dynamic id) async {
    try {
      final response = await _paymentsRepository.deleteTapCard(id.toString());
      final failure = _serverMessage(response);
      if (failure != null) {
        debugPrint('error in deleting payment $failure');
        return;
      }
      await getPaymentMethodsTap();
    } catch (e) {
      debugPrint('error in deleting payment $e');
    }
  }
  setLoading(var value) async {
    _isloading=value;
    notifyListeners();
  }
  Future<String> initiateCardSave() async {
    final customer = await _paymentsRepository.addOrUpdateTapCustomer();
    final customerFailure = _serverMessage(customer);
    if (customerFailure != null) {
      throw Exception(customerFailure);
    }
    final tapId = customer is Map ? customer['tap_id']?.toString() : null;
    if (tapId == null || tapId.isEmpty) {
      throw Exception('Could not start card setup.');
    }
    _profileViewModel.profileBody['tap_id'] = tapId;

    final response = await _paymentsRepository.initiateCardSave();
    final failure = _serverMessage(response);
    if (failure != null) {
      throw Exception(failure);
    }
    final url = response is Map ? response['redirect_url']?.toString() : null;
    if (url == null || url.isEmpty) {
      throw Exception('Card save did not return a page to open.');
    }
    return url;
  }

  Future<String> getUserId() async {
    try {
      String? token =
          await AppPreferences().get(key: userIdKey, isModel: false);
      return token ?? '';
    } catch (err) {
      return '';
    }
  }

  get getPaymentBody => paymentBody;
  get paymentCards => _paymentCards;

  get paymentList => _paymentsList;
  get isLoading => _isloading;

  @override
  void disposeValues() {
    // _homeRepository = ProfileRepository();
  }
}
