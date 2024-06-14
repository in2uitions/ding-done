import 'package:flutter/material.dart';
import 'package:dingdone/data/remote/response/ApiResponse.dart';
import 'package:dingdone/data/remote/response/Status.dart';
import 'package:dingdone/models/on_boarding_model.dart';
import 'package:dingdone/repository/on_boarding/on_boarding_repo.dart';
import 'package:dingdone/res/app_prefs.dart';

class OnBoardingViewModel with ChangeNotifier {
  final OnBoardingRepository _onBoradingRepo = OnBoardingRepository();
  int _currentIndex = 0;
  ApiResponse<OnBoardingMain> onBoardingPages = ApiResponse.loading();
  List<OnBoarding> onBoardingValue = List.empty();

  OnBoardingViewModel() {
    fetchOnBoardings();
  }

  void _setOnBoardingMain(ApiResponse<OnBoardingMain> response) {
    onBoardingPages = response;
    onBoardingValue = response.data?.onBoarding ?? [];
    if (response.status == Status.ERROR) {
      AppPreferences().remove(key: userTokenKey);
    }
    notifyListeners();
  }

  void onPageChanged(int index) {
    if (index < 2) {
      _currentIndex = index;
      notifyListeners();
    }
  }

  bool get isOnBoardingEmpty => onBoardingValue.isEmpty;
  int get getCurrentIndex => _currentIndex;

  bool get isOnBordingValueNotNull => onBoardingValue.isNotEmpty;

  Future<List<OnBoarding>?> fetchOnBoardings() async {
    _setOnBoardingMain(ApiResponse.loading());
    try {
      OnBoardingMain? response = await _onBoradingRepo.getOnBoardingList();
      _setOnBoardingMain(ApiResponse.completed(response));
      return response?.onBoarding;
    } catch (error) {
      _setOnBoardingMain(ApiResponse.error(error.toString()));
      return [];
    }
  }

  get isOnboardingFailed => onBoardingPages.status;
}

class SliderObjectView {
  late OnBoarding onBoardingObject;
  int numbOfSlides;
  int currentIndex;

  SliderObjectView(
      {required this.onBoardingObject,
      required this.numbOfSlides,
      required this.currentIndex});
}
