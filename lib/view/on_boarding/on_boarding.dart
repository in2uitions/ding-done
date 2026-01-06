import 'package:dingdone/res/fonts/styles_manager.dart';
import 'package:dingdone/view/login/login.dart';
import 'package:dingdone/view_model/jobs_view_model/jobs_view_model.dart';
import 'package:dingdone/view_model/login_view_model/login_view_model.dart';
import 'package:dingdone/view_model/on_boarding_view_model/on_boarding_view_model.dart';
import 'package:flutter/material.dart';
import 'package:dingdone/data/remote/response/Status.dart';
import 'package:dingdone/models/on_boarding_model.dart';
import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/view/widgets/on_boarding/walk_through_page_item.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:provider/provider.dart';
import 'package:audioplayers/audioplayers.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  PageController zcontroller = PageController(initialPage: 0);
  final LoginViewModel _loginViewModel = LoginViewModel();
  AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _loginViewModel.splashLogin();
    playSound();
  }

  Future<void> playSound() async {
    String soundPath =
        "DingDone Hybrid.wav"; // Update with the actual path to your .wav file

    await _audioPlayer.play(AssetSource(soundPath));
  }

    @override
    Widget build(BuildContext context) {
      return Consumer<OnBoardingViewModel>(
        builder: (context, onboardingViewModel, _) {
          if (onboardingViewModel.isOnboardingFailed == Status.ERROR) {
            return LoginScreen();
          } else if (onboardingViewModel.isOnboardingFailed == Status.COMPLETED) {
            return Scaffold(
              body: Stack(
                fit: StackFit.expand,
                children: [
                  // Background image
                  Image.asset(
                    'assets/img/onboarding_bg.png',
                    fit: BoxFit.cover,
                  ),

                  // Center content
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // App logo
                        SvgPicture.asset(
                          'assets/img/DingDoneLogo.svg',
                          height: 160,
                        ),
                        const SizedBox(height: 50),

                        // "The smarter way"
                        Text(
                          "The smarter way",
                          style: const TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF4100E3),
                          ),
                        ),

                        // const SizedBox(height: 2),

                        // "to get things done"
                        Text(
                          "to get things done",
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

                  // Bottom button
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
                        child: const Text(
                          "Get Started",
                          style: TextStyle(
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
          return Container(
              child: SvgPicture.asset(
                'assets/img/DingDoneLogo.svg',
              ));
        },
      );

    }
  }