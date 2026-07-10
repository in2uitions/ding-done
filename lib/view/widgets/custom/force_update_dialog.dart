import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:url_launcher/url_launcher.dart';

class ForceUpdateDialog extends StatelessWidget {
  const ForceUpdateDialog({
    super.key,
    required this.storeUrl,
  });

  final String storeUrl;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: AlertDialog(
        backgroundColor: Colors.white,
        elevation: 15,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset('assets/img/failure.svg'),
            SizedBox(height: context.appValues.appSize.s30),
            Text(
              'app_update.title'.tr(),
              textAlign: TextAlign.center,
              style: getPrimarySemiBoldStyle(
                fontSize: 18,
                color: context.resources.color.btnColorBlue,
              ),
            ),
            const Gap(12),
            Text(
              'app_update.message'.tr(),
              textAlign: TextAlign.center,
              style: getPrimaryRegularStyle(
                fontSize: 16,
                color: context.resources.color.btnColorBlue,
              ),
            ),
            const Gap(25),
            InkWell(
              onTap: () => _openStore(),
              child: Container(
                height: 44,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xff4100E3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    'button.update'.tr(),
                    style: getPrimarySemiBoldStyle(
                      fontSize: 13,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openStore() async {
    final uri = Uri.parse(storeUrl);
    try {
      // Avoid canLaunchUrl — it often returns false in Android release builds
      // even when the store link can be opened.
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      if (!launched) {
        await launchUrl(uri, mode: LaunchMode.platformDefault);
      }
    } catch (_) {
      await launchUrl(uri, mode: LaunchMode.platformDefault);
    }
  }
}

void showForceUpdateDialog(
  BuildContext context, {
  required String storeUrl,
}) {
  showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (_) => ForceUpdateDialog(storeUrl: storeUrl),
  );
}
