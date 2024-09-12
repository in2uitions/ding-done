import 'dart:io';
import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';
import 'package:dingdone/view/agreement/supplier_agreement.dart';
import 'package:dingdone/view/login/login.dart';
import 'package:dingdone/view/map_screen/map_display.dart';
import 'package:dingdone/view/map_screen/map_screen.dart';
import 'package:dingdone/view/widgets/custom/custom_date_picker.dart';
import 'package:dingdone/view/widgets/custom/custom_multiple_selection_checkbox.dart';
import 'package:dingdone/view/widgets/custom/custom_phone_feild.dart';
import 'package:dingdone/view/widgets/custom/custom_text_feild.dart';
import 'package:dingdone/view/widgets/image_component/upload_one_image.dart';
import 'package:dingdone/view_model/categories_view_model/categories_view_model.dart';
import 'package:dingdone/view_model/services_view_model/services_view_model.dart';
import 'package:dingdone/view_model/signup_view_model/signup_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:onboarding/onboarding.dart';
import 'package:provider/provider.dart';

class SignUpSupplierOnBoardingScreen extends StatefulWidget {
  var initialIndex;

  SignUpSupplierOnBoardingScreen({super.key, required this.initialIndex});

  @override
  State<SignUpSupplierOnBoardingScreen> createState() =>
      _SignUpSupplierOnBoardingScreenState();
}

class _SignUpSupplierOnBoardingScreenState
    extends State<SignUpSupplierOnBoardingScreen> {
  late Material materialButton;
  late int index;
  dynamic image = {};
  dynamic imageID = {};
  String? selectedOption;

  @override
  void initState() {
    super.initState();
    materialButton = _skipButton();

    index = widget.initialIndex;
    debugPrint('initial index is ${widget.initialIndex}');
  }

  Material _skipButton({void Function(int)? setIndex}) {
    return Material(
      borderRadius: defaultSkipButtonBorderRadius,
      color: defaultSkipButtonColor,
      child: Consumer<SignUpViewModel>(builder: (context, signupViewModel, _) {
        return Container(
          // width: 127,
          width: context.appValues.appSizePercent.w32,
          // height: 51,
          height: context.appValues.appSizePercent.h065,
          decoration: BoxDecoration(
            color: const Color(0xff57527A),
            borderRadius: BorderRadius.circular(15),
          ),
          child: InkWell(
            borderRadius: defaultSkipButtonBorderRadius,
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();
              if (signupViewModel.validate(index: index) && setIndex != null) {
                index = index + 1;
                setIndex(index);
              }
            },
            child: Center(
              child: Text(
                translate('button.next'),
                style: getPrimaryBoldStyle(
                  fontSize: 21,
                  color: context.resources.color.colorWhite,
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Material get _signupButton {
    return Material(
      borderRadius: defaultProceedButtonBorderRadius,
      color: defaultProceedButtonColor,
      child: Consumer<SignUpViewModel>(builder: (context, signupViewModel, _) {
        return Container(
          // width: 156,
          width: context.appValues.appSizePercent.w40,
          // height: 51,
          height: context.appValues.appSizePercent.h065,
          decoration: BoxDecoration(
            color: const Color(0xffF3D347),
            borderRadius: BorderRadius.circular(15),
          ),
          child: InkWell(
            borderRadius: defaultProceedButtonBorderRadius,
            onTap: () {
              if (signupViewModel.validate(index: index)) {
                Navigator.of(context)
                    .push(_createRoute(SupplierAgreement(index: index)));
              }
            },
            child: Center(
              child: Text(
                translate('button.complete'),
                style: getPrimaryBoldStyle(
                  fontSize: 21,
                  color: context.resources.color.colorWhite,
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    dynamic imageWidget = image['image'] != null
        ? image['type'] == 'file'
            ? FileImage(image['image'])
            : NetworkImage(
                '${context.resources.image.networkImagePath}${image['image']}')
        : const NetworkImage(
            'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png',
          );
    dynamic imageWidgetID = imageID['image'] != null
        ? imageID['type'] == 'file'
            ? FileImage(imageID['image'])
            : NetworkImage(
                '${context.resources.image.networkImagePath}${imageID['image']}')
        : const AssetImage(
            'assets/img/identification.png',
          );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sign up ',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Consumer2<SignUpViewModel, ServicesViewModel>(
          builder: (context, signupViewModel, servicesViewModel, _) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: const Color(0xffFEFEFE),
            leading: Padding(
              padding: EdgeInsets.fromLTRB(
                context.appValues.appPadding.p20,
                context.appValues.appPadding.p20,
                context.appValues.appPadding.p10,
                context.appValues.appPadding.p20,
              ),
              child: InkWell(
                child: SvgPicture.asset('assets/img/back.svg'),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(_createRoute(const LoginScreen()));
                },
              ),
            ),
            title: Text(
              translate('login_screen.swipe'),
              style: getPrimaryBoldStyle(fontSize: 13,color:const Color(0xff180C38),), // Customize text style
            ),
            centerTitle: true,  // Centers the text
          ),

          body: Onboarding(
            pages: [
              PageModel(
                widget: DecoratedBox(
                  decoration: BoxDecoration(
                    color: const Color(0xffFEFEFE),
                    border: Border.all(
                      width: 0.0,
                      color: const Color(0xffFEFEFE),
                    ),
                  ),
                  child: ListView(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
                        child: SizedBox(
                          width: context.appValues.appSizePercent.w100,
                          child: Text(
                            translate('profile.personalInformation'),
                            style: getPrimaryBoldStyle(
                              color: const Color(0xff180C38),
                              fontSize: 28,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                        child: CustomTextField(
                          value:signupViewModel.signUpBody["first_name"]??'',
                          index: 'first_name',
                          viewModel: signupViewModel.setInputValues,
                          hintText: translate('formHints.first_name'),
                          validator: (val) => signupViewModel.signUpErrors[
                              context
                                  .resources.strings.formKeys['first_name']!],
                          errorText: signupViewModel.signUpErrors[context
                              .resources.strings.formKeys['first_name']!],
                          keyboardType: TextInputType.text,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                        child: CustomTextField(
                          value:signupViewModel.signUpBody["last_name"]??'',
                          index: 'last_name',
                          viewModel: signupViewModel.setInputValues,
                          hintText: translate('formHints.last_name'),
                          validator: (val) => signupViewModel.signUpErrors[
                              context.resources.strings.formKeys['last_name']!],
                          errorText: signupViewModel.signUpErrors[
                              context.resources.strings.formKeys['last_name']!],
                          keyboardType: TextInputType.text,
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 5),
                          child: CustomDatePicker(
                            value:signupViewModel.signUpBody["dob"]??'',
                            index: 'dob',
                            viewModel: signupViewModel.setInputValues,
                            hintText: translate('formHints.dob'),
                          )),
                      if (signupViewModel.signUpErrors[context
                          .resources.strings.formKeys['dob']] !=
                          null)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(30, 0, 20, 20),
                          child: Text(
                            signupViewModel.signUpErrors[context
                                .resources.strings.formKeys['dob']]!,
                            style: TextStyle(color: Colors.red[700],fontSize: 12),
                          ),
                        ),

                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                        child: SizedBox(
                          width: context.appValues.appSizePercent.w100,
                          child: Text(
                            translate('signUp.profileType'),
                            style: getPrimaryBoldStyle(
                              color: const Color(0xff180C38),
                              fontSize: 28,
                            ),
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                            child: Row(
                              children: [
                                Radio<String>(
                                  value: 'individual',
                                  groupValue: selectedOption,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedOption = value;
                                    });
                                    signupViewModel.setInputValues(index: 'selectedOption', value: selectedOption);
                                  },
                                ),
                                Text(
                                  translate('signUp.individual'),
                                  style: getPrimaryRegularStyle(
                                    color: const Color(0xff180C38),
                                    fontSize: 18,
                                  ),
                                ),
                                Radio<String>(
                                  value: 'company',
                                  groupValue: selectedOption,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedOption = value;
                                    });
                                  },
                                ),
                                Text(
                                  translate('signUp.company'),
                                  style: getPrimaryRegularStyle(
                                    color: const Color(0xff180C38),
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (selectedOption == 'company')
                            Padding(
                              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                              child: CustomTextField(
                                value:signupViewModel.signUpBody["company_id"]??'',
                                index: 'company',
                                viewModel: signupViewModel.setInputValues,
                                hintText: translate('signUp.companyId'),
                                validator: (val) =>
                                    signupViewModel.signUpErrors[context
                                        .resources
                                        .strings
                                        .formKeys['company_id']!],
                                errorText: signupViewModel.signUpErrors[context
                                    .resources.strings.formKeys['company_id']!],
                                keyboardType: TextInputType.text,
                              ),
                            ),
                          if (selectedOption == 'individual')
                            Container(
                              decoration: BoxDecoration(
                                color: Color(0xff112b78),
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: context.appValues.appPadding.p20,
                                vertical: context.appValues.appPadding.p10,
                              ),
                              child: UploadOneImage(
                                callback: (picked, save) async {
                                  if (picked != null) {
                                    setState(() {
                                      imageID = {
                                        'type': 'file',
                                        'image': File(picked[0].path)
                                      };
                                    });
                                  }
                                  if (save != null) {
                                    debugPrint('save 0 ${save[0]}');
                                    signupViewModel.setInputValues(
                                        index: 'id_image',
                                        value: save[0]["image"]);
                                  }
                                },
                                isImage: true,
                                widget: Text(
                                  translate('signUp.identificationCard'),
                                  style: getPrimaryBoldStyle(
                                    fontSize: 21,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          if (selectedOption == 'individual')
                            SizedBox(height: context.appValues.appSize.s10),
                          if (selectedOption == 'individual')
                            Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              elevation: 5,
                              // backgroundImage: imageWidgetID,
                              // radius: 70,
                              // backgroundColor: Colors.transparent,
                              child: Container(
                                width: 300,
                                height: 150,
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  image: imageWidgetID != null
                                      ? DecorationImage(
                                          image: imageWidgetID,
                                          fit: BoxFit.cover,
                                        )
                                      : null,
                                  color: Colors.grey[300],
                                  // Placeholder color
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                            ),

                        ],
                      ),
                      if (signupViewModel.signUpErrors[context
                          .resources.strings.formKeys['id_image']] !=
                          null && signupViewModel.getSignUpBody['selectedOption']=='individual')
                        Padding(
                          padding: const EdgeInsets.fromLTRB(55, 0, 20, 20),
                          child: Text(
                            signupViewModel.signUpErrors[context
                                .resources.strings.formKeys['id_image']]!,
                            style: TextStyle(color: Colors.red[700],fontSize: 12),
                          ),
                        ),

                      if (signupViewModel.signUpErrors[context
                          .resources.strings.formKeys['company_id']] !=
                          null && signupViewModel.getSignUpBody['selectedOption']=='company')
                        Padding(
                          padding: const EdgeInsets.fromLTRB(55, 0, 20, 20),
                          child: Text(
                            signupViewModel.signUpErrors[context
                                .resources.strings.formKeys['company_id']]!,
                            style: TextStyle(color: Colors.red[700],fontSize: 12),
                          ),
                        ),

                    ],
                  ),
                ),
              ),

              PageModel(
                widget: DecoratedBox(
                  decoration: BoxDecoration(
                    color: const Color(0xffFEFEFE),
                    border: Border.all(
                      width: 0.0,
                      color: const Color(0xffFEFEFE),
                    ),
                  ),
                  child: ListView(
                    children: [
                      Padding(
                          padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
                          child: SizedBox(
                            width: context.appValues.appSizePercent.w100,
                            child: Text(
                              translate('profile.contactInformation'),
                              style: getPrimaryBoldStyle(
                                color: const Color(0xff180C38),
                                fontSize: 28,
                              ),
                            ),
                          )),
                      Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                          child: CustomPhoneFeild(
                            index: 'phone_number',
                            value: signupViewModel.signUpBody['phone_number']??'' ,
                            viewModel: signupViewModel.setInputValues,
                            validator: (val) => signupViewModel.signUpErrors[
                                context.resources.strings
                                    .formKeys['phone_number']!],
                            errorText: signupViewModel.signUpErrors[context
                                .resources.strings.formKeys['phone_number']!],
                            hintText: translate('formHints.phone_number'),
                          )),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                        child: CustomTextField(
                            value: signupViewModel.signUpBody['email']??'' ,
                            index: 'email',
                            viewModel: signupViewModel.setInputValues,
                            hintText: translate('formHints.email'),
                            validator: (val) => signupViewModel.signUpErrors[
                                context.resources.strings.formKeys['email']!],
                            errorText: signupViewModel.signUpErrors[
                                context.resources.strings.formKeys['email']!],
                            keyboardType: TextInputType.emailAddress),
                      ),
                    ],
                  ),
                ),
              ),
              PageModel(
                widget: DecoratedBox(
                  decoration: BoxDecoration(
                    color: const Color(0xffFEFEFE),
                    border: Border.all(
                      width: 0.0,
                      color: const Color(0xffFEFEFE),
                    ),
                  ),
                  child: ListView(
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                          padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
                          child: SizedBox(
                            width: context.appValues.appSizePercent.w100,
                            child: Text(
                              translate('signUp.securityInformation'),
                              style: getPrimaryBoldStyle(
                                color: const Color(0xff180C38),
                                fontSize: 28,
                              ),
                            ),
                          )),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                        child: CustomTextField(
                            value: signupViewModel.signUpBody['password']??'' ,
                            index: 'password',
                            viewModel: signupViewModel.setInputValues,
                            hintText: translate('formHints.password'),
                            validator: (val) => signupViewModel.signUpErrors[
                                context
                                    .resources.strings.formKeys['password']!],
                            errorText: signupViewModel.signUpErrors[context
                                .resources.strings.formKeys['password']!],
                            keyboardType: TextInputType.visiblePassword),
                      ),
                      const SizedBox(height: 8.0),
                      // Adjust the height between the text and bullet points
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20.0,
                          vertical: 0.0,
                        ),
                        child: Text(
                          translate('signUp.requirments'),
                          style: const TextStyle(
                            color: Colors.black, // Set your desired color
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              PageModel(
                widget: DecoratedBox(
                  decoration: BoxDecoration(
                    color: const Color(0xffFEFEFE),
                    border: Border.all(
                      width: 0.0,
                      color: const Color(0xffFEFEFE),
                    ),
                  ),
                  child: ListView(
                    children: [
                      Padding(
                          padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
                          child: SizedBox(
                            width: context.appValues.appSizePercent.w100,
                            child: Text(
                              translate('signUp.addressInformation'),
                              style: getPrimaryBoldStyle(
                                color: const Color(0xff180C38),
                                fontSize: 28,
                              ),
                            ),
                          )),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: context.appValues.appPadding.p20,
                            vertical: context.appValues.appPadding.p10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              translate('formHints.location'),
                              style: getPrimaryRegularStyle(
                                fontSize: 15,
                                color: context.resources.color.secondColorBlue,
                              ),
                            ),
                            InkWell(
                              child: Text(
                                translate('signUp.chooseLocation'),
                                style: getPrimaryRegularStyle(
                                  fontSize: 15,
                                  color: context.resources.color.btnColorBlue,
                                ),
                              ),
                              onTap: () {
                                Navigator.of(context)
                                    .push(_createRoute(MapScreen(
                                  viewModel: signupViewModel,
                                  longitude: 25.3,
                                  latitude: 51.52,
                                )));
                              },
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: context.appValues.appPadding.p20),
                        child: SizedBox(
                            height: 300,
                            child: FutureBuilder(
                                future: Provider.of<SignUpViewModel>(context,
                                        listen: false)
                                    .getData(),
                                builder: (context, AsyncSnapshot data) {
                                  if (data.connectionState ==
                                      ConnectionState.done) {
                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.of(context)
                                            .push(_createRoute(MapScreen(
                                          viewModel: signupViewModel,
                                          longitude: 25.3,
                                          latitude: 51.52,
                                        )));
                                      },
                                      child: MapDisplay(
                                        body: signupViewModel.signUpBody,
                                        longitude: signupViewModel.signUpBody[
                                                        "longitude"] !=
                                                    null &&
                                                signupViewModel.signUpBody[
                                                        "longitude"] !=
                                                    ''
                                            ? double.parse(signupViewModel
                                                .signUpBody["longitude"])
                                            : 25.3,
                                        latitude: signupViewModel.signUpBody[
                                                        "latitude"] !=
                                                    null &&
                                                signupViewModel.signUpBody[
                                                        "latitude"] !=
                                                    ''
                                            ? double.parse(signupViewModel
                                                .signUpBody["latitude"])
                                            : 51.52,
                                      ),
                                    );
                                  } else {
                                    return Container();
                                  }
                                })),
                      ),
                      if (signupViewModel.signUpErrors[context
                              .resources.strings.formKeys['longitude']] !=
                          null)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                          child: Text(
                            signupViewModel.signUpErrors[context
                                .resources.strings.formKeys['longitude']]!,
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      if (signupViewModel.signUpErrors[
                              context.resources.strings.formKeys['latitude']] !=
                          null)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                          child: Text(
                            signupViewModel.signUpErrors[context
                                .resources.strings.formKeys['latitude']]!,
                            style: TextStyle(color: Colors.red),
                          ),
                        ),

                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                        child: CustomTextField(
                            value: signupViewModel
                                    .getSignUpBody['street_number'] ??
                                '',
                            index: 'street_number',
                            viewModel: signupViewModel.setInputValues,
                            hintText: translate('formHints.street'),
                            validator: (val) => signupViewModel.signUpErrors[
                                context.resources.strings
                                    .formKeys['street_number']!],
                            errorText: signupViewModel.signUpErrors[context
                                .resources.strings.formKeys['street_number']!],
                            keyboardType: TextInputType.text),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                        child: CustomTextField(
                            value: signupViewModel
                                    .getSignUpBody['building_number'] ??
                                '',
                            index: 'building_number',
                            viewModel: signupViewModel.setInputValues,
                            hintText: translate('formHints.building'),
                            validator: (val) => signupViewModel.signUpErrors[
                                context.resources.strings
                                    .formKeys['building_number']!],
                            errorText: signupViewModel.signUpErrors[context
                                .resources
                                .strings
                                .formKeys['building_number']!],
                            keyboardType: TextInputType.text),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                        child: CustomTextField(
                            value: signupViewModel.getSignUpBody['floor'] ?? '',
                            index: 'floor',
                            viewModel: signupViewModel.setInputValues,
                            hintText: translate('formHints.floor'),
                            validator: (val) => signupViewModel.signUpErrors[
                                context.resources.strings.formKeys['floor']!],
                            errorText: signupViewModel.signUpErrors[
                                context.resources.strings.formKeys['floor']!],
                            keyboardType: TextInputType.text),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                        child: CustomTextField(
                            value: signupViewModel
                                    .getSignUpBody['apartment_number'] ??
                                '',
                            index: 'apartment_number',
                            viewModel: signupViewModel.setInputValues,
                            hintText: translate('formHints.apartment'),
                            validator: (val) => signupViewModel.signUpErrors[
                                context.resources.strings
                                    .formKeys['apartment_number']!],
                            errorText: signupViewModel.signUpErrors[context
                                .resources
                                .strings
                                .formKeys['apartment_number']!],
                            keyboardType: TextInputType.text),
                      ),
                      // FutureBuilder(
                      //     future: Provider.of<SignUpViewModel>(context,
                      //             listen: false)
                      //         .getData(),
                      //     builder: (context, AsyncSnapshot data) {
                      //
                      //         return
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                        child: CustomTextField(
                            value: signupViewModel.signUpBody["city"] ?? '',
                            index: 'city',
                            viewModel: signupViewModel.setInputValues,
                            hintText: translate('formHints.city'),
                            validator: (val) => signupViewModel.signUpErrors[
                                context.resources.strings.formKeys['city']!],
                            errorText: signupViewModel.signUpErrors[
                                context.resources.strings.formKeys['city']!],
                            keyboardType: TextInputType.text),
                      ),

                      // }),
                      // FutureBuilder(
                      //     future: Provider.of<SignUpViewModel>(context,
                      //             listen: false)
                      //         .getData(),
                      //     builder: (context, AsyncSnapshot data) {

                      // return
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                        child: CustomTextField(
                            value: signupViewModel.signUpBody["zone"] ?? '',
                            index: 'zone',
                            viewModel: signupViewModel.setInputValues,
                            hintText: translate('formHints.zone'),
                            validator: (val) => signupViewModel.signUpErrors[
                                context.resources.strings.formKeys['zone']!],
                            errorText: signupViewModel.signUpErrors[
                                context.resources.strings.formKeys['zone']!],
                            keyboardType: TextInputType.text),
                      ),

                      // }),
                      // Padding(
                      //   padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                      //   child: CustomTextField(
                      //       index: 'state',
                      //       viewModel: signupViewModel.setInputValues,
                      //       hintText: 'State',
                      //       validator: (val) => signupViewModel.signUpErrors[
                      //       context.resources.strings.formKeys['state']!],
                      //       errorText: signupViewModel.signUpErrors[
                      //       context.resources.strings.formKeys['state']!],
                      //       keyboardType: TextInputType.text),
                      // ),
                      // Padding(
                      //   padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                      //   child: CustomTextField(
                      //       index: 'postal_code',
                      //       viewModel: signupViewModel.setInputValues,
                      //       hintText: 'Postal Code',
                      //       validator: (val) => signupViewModel.signUpErrors[
                      //       context.resources.strings
                      //           .formKeys['postal_code']!],
                      //       errorText: signupViewModel.signUpErrors[context
                      //           .resources.strings.formKeys['postal_code']!],
                      //       keyboardType: TextInputType.text),
                      // ),
                    ],
                  ),
                ),
              ),

              PageModel(
                widget: DecoratedBox(
                  decoration: BoxDecoration(
                    color: const Color(0xffFEFEFE),
                    border: Border.all(
                      width: 0.0,
                      color: const Color(0xffFEFEFE),
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
                          child: SizedBox(
                            width: context.appValues.appSizePercent.w100,
                            child: Text(
                              translate('signUp.selectYourSkills'),
                              style: getPrimaryBoldStyle(
                                color: const Color(0xff180C38),
                                fontSize: 28,
                              ),
                            ),
                          ),
                        ),
                        Consumer<CategoriesViewModel>(
                            builder: (context, categoriesViewModel, _) {
                          return Padding(
                            padding: const EdgeInsets.fromLTRB(20, 0, 0, 20),
                            child: CustomMultipleSelectionCheckBoxList(
                              list: categoriesViewModel.categoriesList,
                              // values: [],// Pass your selected values here
                              onChange: (selectedValues) {
                                // Handle selected values
                                setState(() {
                                  selectedValues = selectedValues;
                                });
                              },
                              viewModel: signupViewModel.setInputValues,
                              validator: (val) => signupViewModel.signUpErrors[
                                  context.resources.strings
                                      .formKeys['supplier_services']!],
                              errorText: signupViewModel.signUpErrors[context
                                  .resources
                                  .strings
                                  .formKeys['supplier_services']!],
                              // errorText: signupViewModel.signUpErrors[
                              // context.resources.strings.formKeys['categories']!],
                              // hint: 'Categories',
                              index: 'supplier_services',
                              servicesViewModel: servicesViewModel,
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              ),
              PageModel(
                widget: DecoratedBox(
                  decoration: BoxDecoration(
                    color: const Color(0xffFEFEFE),
                    border: Border.all(
                      width: 0.0,
                      color: const Color(0xffFEFEFE),
                    ),
                  ),
                  child: Column(
                    children: [
                      Padding(
                          padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
                          child: SizedBox(
                            width: context.appValues.appSizePercent.w100,
                            child: Text(
                              translate('signUp.completeProfile'),
                              style: getPrimaryBoldStyle(
                                color: const Color(0xff180C38),
                                fontSize: 28,
                              ),
                            ),
                          )),

                      // AddMedia(),
                      CircleAvatar(
                        backgroundImage: imageWidget,
                        radius: 70,
                        backgroundColor: Colors.transparent,
                      ),
                      SizedBox(height: context.appValues.appSize.s20),
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xff9E9AB7),
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: context.appValues.appPadding.p20,
                          vertical: context.appValues.appPadding.p10,
                        ),
                        child: UploadOneImage(
                          callback: (picked, save) async {
                            if (picked != null) {
                              setState(() {
                                image = {
                                  'type': 'file',
                                  'image': File(picked[0].path)
                                };
                              });
                            }
                            if (save != null) {
                              debugPrint('save 0 ${save[0]}');
                              signupViewModel.setInputValues(
                                  index: 'avatar', value: save[0]["image"]);
                            }
                          },
                          isImage: true,
                          widget: Text(
                            translate('signUp.uploadProfilePhoto'),
                            style: getPrimaryBoldStyle(
                              fontSize: 21,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // PageModel(
              //   widget: DecoratedBox(
              //     decoration: BoxDecoration(
              //       color: Color(0xffFEFEFE),
              //       border: Border.all(
              //         width: 0.0,
              //         color: Color(0xffFEFEFE),
              //       ),
              //     ),
              //     child: Column(
              //       children: [
              //         Padding(
              //           padding: const EdgeInsets.symmetric(
              //             horizontal: 20.0,
              //             vertical: 30.0,
              //           ),
              //           child: CustomTextField(
              //               index: 'registration_number',
              //               viewModel: signupViewModel.setInputValues,
              //               hintText: 'ID',
              //               validator: (val) => signupViewModel.signUpErrors[
              //                   context.resources.strings
              //                       .formKeys['registration_number']!],
              //               errorText: signupViewModel.signUpErrors[context
              //                   .resources
              //                   .strings
              //                   .formKeys['registration_number']!],
              //               keyboardType: TextInputType.text),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
              // PageModel(
              //   widget: DecoratedBox(
              //     decoration: BoxDecoration(
              //       color: Color(0xffFEFEFE),
              //       border: Border.all(
              //         width: 0.0,
              //         color: Color(0xffFEFEFE),
              //       ),
              //     ),
              //     child: Column(
              //       children: [
              //         Padding(
              //           padding: const EdgeInsets.symmetric(
              //             horizontal: 20.0,
              //             vertical: 30.0,
              //           ),
              //           child: CustomTextField(
              //               index: 'contact_details',
              //               viewModel: signupViewModel.setInputValues,
              //               hintText: 'Bank Account Info',
              //               validator: (val) => signupViewModel.signUpErrors[
              //                   context.resources.strings
              //                       .formKeys['contact_details']!],
              //               errorText: signupViewModel.signUpErrors[context
              //                   .resources
              //                   .strings
              //                   .formKeys['contact_details']!],
              //               keyboardType: TextInputType.text),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
            ],
            onPageChange: (int pageIndex) {
              index = pageIndex;
            },
            startPageIndex: widget.initialIndex,
            footerBuilder: (context, dragDistance, pagesLength, setIndex) {
              return DecoratedBox(
                decoration: BoxDecoration(
                  color: const Color(0xffFEFEFE),
                  border: Border.all(
                    width: 0.0,
                    color: const Color(0xffFEFEFE),
                  ),
                ),
                child: ColoredBox(
                  color: const Color(0xffFEFEFE),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(0.0, 10.0, 20.0, 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // CustomIndicator(
                        //   netDragPercent: dragDistance,
                        //   pagesLength: pagesLength,
                        //   indicator: Indicator(
                        //     indicatorDesign: IndicatorDesign.line(
                        //       lineDesign: LineDesign(
                        //         lineType: DesignType.line_uniform,
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        index == pagesLength - 1
                            ? _signupButton
                            : _skipButton(setIndex: setIndex)
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }
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
