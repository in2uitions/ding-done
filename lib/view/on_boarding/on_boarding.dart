import 'dart:io';

import 'package:dingdone/view/login/login.dart';
import 'package:dingdone/view_model/login_view_model/login_view_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:audioplayers/audioplayers.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final LoginViewModel _loginViewModel = LoginViewModel();
  final AudioPlayer _audioPlayer = AudioPlayer();
  static bool _didPlaySound = false;

  @override
  void initState() {
    super.initState();
    _loginViewModel.splashLogin();
    playSound();
  }

  Future<void> playSound() async {
    if (!Platform.isIOS || _didPlaySound) return;
    _didPlaySound = true;
    try {
      await _audioPlayer.play(AssetSource('DingDone Hybrid.wav'));
    } catch (error) {
      debugPrint('Onboarding sound failed: $error');
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/img/onboarding_bg.png',
            fit: BoxFit.cover,
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  'assets/img/DingDoneLogo.svg',
                  height: 160,
                ),
                const SizedBox(height: 50),
                Text(
                  'onBoarding.theSmarterWay'.tr(),
                  style: const TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4100E3),
                  ),
                ),
                Text(
                  'onBoarding.toGetThingsDone'.tr(),
                  style: const TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 25,
                    fontWeight: FontWeight.w300,
                    color: Color(0xFF4100E3),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 40,
            left: 20,
            right: 20,
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4100E3),
                  padding: const EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 10,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                  );
                },
                child: Text(
                  'onBoarding.getStarted'.tr(),
                  style: const TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
