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
import 'package:flutter_translate/flutter_translate.dart';
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
    double height = MediaQuery.of(context).size.height;

    return Consumer<OnBoardingViewModel>(
      builder: (context, onboardingViewModel, _) {
        if (onboardingViewModel.isOnboardingFailed == Status.ERROR) {
          return LoginScreen();
        } else if (onboardingViewModel.isOnboardingFailed == Status.COMPLETED) {
          return Scaffold(
            backgroundColor: (onboardingViewModel.getCurrentIndex <= 0)
                ? context.resources.color.btnColorBlue
                : context.resources.color.colorWhite,
            // backgroundColor: context.resources.color.colorWhite,
            body: Center(
              child: Directionality(
                textDirection: TextDirection.ltr,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: height * 0.7,
                      // height: context.appValues.appSizePercent.h95,
                      child: PageView.builder(
                        controller: zcontroller,
                        itemCount: onboardingViewModel.onBoardingValue.length,
                        onPageChanged: (zPage) {
                          onboardingViewModel.onPageChanged(zPage);
                        },
                        itemBuilder: (context, index) {
                          OnBoarding value =
                              onboardingViewModel.onBoardingValue[
                                  onboardingViewModel.getCurrentIndex];
                          return
                              // (onboardingViewModel.getCurrentIndex <= 0)?
                              WalkthroughPageItem(
                            imagepath:
                                '${context.resources.image.networkImagePath2}/${value.image}',
                            title: value.title ?? '',
                            description: value.description ?? '',
                            // description: '',
                            color: context.resources.color.colorWhite,
                          );
                          //   :
                          // WalkthroughPageItem(
                          //       imagepath:
                          //           '${context.resources.image.networkImagePath2}/${value.image}',
                          //       title: value.title ?? '',
                          //       description: value.description ?? '',
                          //       color: Color(0xff222B45),
                          //     );
                          // onboardingViewModel.getCurrentIndex == 0
                          //     ?
                          //     // return
                          //     WalkthroughPageItem(
                          //         imagepath:
                          //             '${context.resources.image.networkImagePath}${value.image}',
                          //         title: value.title ?? '',
                          //         description: value.subtitle ?? '',
                          //         color: context.resources.color.btnColorBlue,
                          //       )
                          //     : WalkthroughPageItem(
                          //         imagepath:
                          //             '${context.resources.image.networkImagePath}${value.image}',
                          //         title: value.title ?? '',
                          //         description: value.subtitle ?? '',
                          //         color: context.resources.color.colorWhite,
                          //       );
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: context.appValues.appPadding.p10,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SmoothPageIndicator(
                            controller: zcontroller,
                            count: 1,
                            effect: ExpandingDotsEffect(
                              expansionFactor: 2,
                              dotHeight: 4,
                              activeDotColor: const Color(0xffF3D348),
                              dotColor:
                                  context.resources.color.colorBlack[800]!,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // SizedBox(
                    //   height: context.appValues.appSize.s25,
                    // ),
                    Row(
                      children: [
                        SvgPicture.asset(
                          'assets/img/logo-new.svg',
                          height: context.appValues.appSizePercent.h28,
                        ),
                        Container(
                          width: 114,
                          // width: context.appValues.appSizePercent.w25,
                          height: 114,
                          // height: context.appValues.appSizePercent.h12,x
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: (onboardingViewModel.getCurrentIndex <= 0)
                                ? context.resources.color.colorWhite
                                : context.resources.color.btnColorBlue,
                          ),
                          child: InkWell(
                              child: Center(
                                child: Text(
                                  translate('button.letsStart'),
                                  style: getPrimaryBoldStyle(
                                      color: Color(0xff222B45), fontSize: 30),
                                ),
                              ),
                              onTap: () {
                                // if (onboardingViewModel.getCurrentIndex > 0) {
                                Navigator.of(context)
                                    .push(_createRoute(LoginScreen()));
                                // }
                                // zcontroller.nextPage(
                                //   duration: Duration(
                                //       milliseconds:
                                //           context.appValues.durationsConst.d300),
                                //   curve: Curves.easeIn,
                                // );
                              }),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        }
        return Container(
            child: SvgPicture.asset(
          'assets/img/DingDone-LOGO.svg',
        ));
      },
    );
  }
}

Widget getIconsWidget(isNext, iconArrow, BuildContext context) {
  return isNext
      ? Icon(
          iconArrow,
          // color: context.resources.color.colorBlack[700],
          color: Colors.black,
        )
      : Icon(
          iconArrow,
          // color: context.resources.color.colorWhite
          color: Colors.white,
        );
}

Route _createRoute(dynamic classname) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => classname,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}
