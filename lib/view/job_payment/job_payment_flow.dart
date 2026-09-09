import 'package:dingdone/models/jobs_model.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';
import 'package:dingdone/utils/job_payment_status.dart';
import 'package:dingdone/view/job_payment/job_payment_webview.dart';
import 'package:dingdone/view_model/jobs_view_model/jobs_view_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class JobPaymentFlow {
  static Future<bool> startInitialPayment(
    BuildContext context, {
    required int jobId,
    bool jobJustCreated = false,
  }) {
    return _start(
      context,
      jobId: jobId,
      extra: false,
      jobJustCreated: jobJustCreated,
    );
  }

  static Future<bool> startExtraPayment(
    BuildContext context, {
    required int jobId,
  }) {
    return _start(context, jobId: jobId, extra: true);
  }

  static Future<bool> resumePendingJob(
    BuildContext context, {
    required JobsModel job,
  }) {
    if (JobPaymentStatus.needsExtraPayment(job.payment_status)) {
      return startExtraPayment(context, jobId: job.id!);
    }
    return startInitialPayment(context, jobId: job.id!);
  }

  static Future<bool> _start(
    BuildContext context, {
    required int jobId,
    required bool extra,
    bool jobJustCreated = false,
  }) async {
    final jobsViewModel = Provider.of<JobsViewModel>(context, listen: false);
    final result = extra
        ? await jobsViewModel.initiateExtraPayment(jobId)
        : await jobsViewModel.initiateJobPayment(jobId);

    if (!context.mounted) return false;
    final redirectUrl = result?['redirect_url']?.toString() ??
        (result?['transaction'] is Map
            ? result!['transaction']['url']?.toString()
            : null);
    if (redirectUrl == null || redirectUrl.isEmpty) {
      final apiMessage = jobsViewModel.errorMessage?.toString().trim() ?? '';
      final message = jobJustCreated
          ? (apiMessage.isNotEmpty
              ? '${'payment.jobSavedRetry'.tr()}\n\n$apiMessage'
              : 'payment.jobSavedRetry'.tr())
          : (apiMessage.isNotEmpty
              ? apiMessage
              : 'payment.couldNotStart'.tr());
      final retry = await _showMessage(
        context,
        title: 'button.failure'.tr(),
        message: message,
        showRetry: true,
      );
      if (retry == true && context.mounted) {
        return _start(
          context,
          jobId: jobId,
          extra: extra,
          jobJustCreated: jobJustCreated,
        );
      }
      return false;
    }

    final returned = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => JobPaymentWebView(redirectUrl: redirectUrl),
      ),
    );
    if (!context.mounted) return false;

    await Future<void>.delayed(const Duration(seconds: 2));
    await jobsViewModel.getCustomerJobs();
    await jobsViewModel.getPendingPayments();
    if (!context.mounted) return false;

    final job = jobsViewModel.jobById(jobId);
    final status = job?.payment_status;
    final success = extra
        ? JobPaymentStatus.isPaid(status)
        : JobPaymentStatus.isAuthorized(status);

    if (returned != true && !success) {
      await _showMessage(
        context,
        title: 'payment.incompleteTitle'.tr(),
        message: 'payment.incompleteMessage'.tr(),
      );
      return false;
    }
    if (!success) {
      await _showMessage(
        context,
        title: 'payment.pendingTitle'.tr(),
        message: 'payment.pendingMessage'.tr(),
      );
      return false;
    }
    return true;
  }

  static Future<bool?> _showMessage(
    BuildContext context, {
    required String title,
    required String message,
    bool showRetry = false,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text(
          title,
          style: getPrimarySemiBoldStyle(
            fontSize: 16,
            color: const Color(0xff180B3C),
          ),
        ),
        content: Text(
          message,
          style: getPrimaryRegularStyle(
            fontSize: 14,
            color: const Color(0xff180B3C),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text('button.ok'.tr()),
          ),
          if (showRetry)
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: Text('payment.retry'.tr()),
            ),
        ],
      ),
    );
  }
}
