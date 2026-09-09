import 'package:dingdone/models/jobs_model.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';
import 'package:dingdone/utils/job_payment_status.dart';
import 'package:dingdone/view/job_payment/job_payment_flow.dart';
import 'package:dingdone/view_model/jobs_view_model/jobs_view_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

class PendingJobPaymentsScreen extends StatefulWidget {
  const PendingJobPaymentsScreen({super.key, this.autoResume = false});

  final bool autoResume;

  @override
  State<PendingJobPaymentsScreen> createState() =>
      _PendingJobPaymentsScreenState();
}

class _PendingJobPaymentsScreenState extends State<PendingJobPaymentsScreen> {
  bool _loading = true;
  int? _payingJobId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final jobsViewModel = Provider.of<JobsViewModel>(context, listen: false);
    await jobsViewModel.getPendingPayments();
    await jobsViewModel.getCustomerJobs();
    if (!mounted) return;
    setState(() => _loading = false);

    if (widget.autoResume && jobsViewModel.pendingPayments.length == 1) {
      await JobPaymentFlow.resumePendingJob(
        context,
        job: jobsViewModel.pendingPayments.first,
      );
      if (!mounted) return;
      await jobsViewModel.getPendingPayments();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xff4100E3),
        foregroundColor: Colors.white,
        title: Text(
          'payment.pendingPayments'.tr(),
          style: getPrimarySemiBoldStyle(fontSize: 16, color: Colors.white),
        ),
      ),
      body: Consumer<JobsViewModel>(
        builder: (context, jobsViewModel, _) {
          if (_loading) {
            return const Center(child: CircularProgressIndicator());
          }
          final jobs = List<JobsModel>.from(jobsViewModel.pendingPayments);
          if (jobs.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'payment.noPending'.tr(),
                  textAlign: TextAlign.center,
                  style: getPrimaryRegularStyle(
                    fontSize: 14,
                    color: const Color(0xff180B3C),
                  ),
                ),
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: jobs.length,
            separatorBuilder: (_, __) => const Gap(12),
            itemBuilder: (context, index) {
              final job = jobs[index];
              final extra =
                  JobPaymentStatus.needsExtraPayment(job.payment_status);
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xffEAEAFF).withOpacity(0.4),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      extra
                          ? 'payment.extraDue'.tr()
                          : 'payment.authorizeDue'.tr(),
                      style: getPrimarySemiBoldStyle(
                        fontSize: 14,
                        color: const Color(0xff180B3C),
                      ),
                    ),
                    const Gap(6),
                    Text(
                      '${'jobs.totalPrice'.tr()}: ${job.total_amount ?? job.tap_charge_amount ?? ''} ${job.currency ?? job.allocated_amount_currency ?? ''}',
                      style: getPrimaryRegularStyle(
                        fontSize: 12,
                        color: const Color(0xff71727A),
                      ),
                    ),
                    const Gap(12),
                    SizedBox(
                      width: double.infinity,
                      height: 44,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff4100E3),
                          disabledBackgroundColor: const Color(0xff4100E3),
                          disabledForegroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: _payingJobId != null
                            ? null
                            : () async {
                                setState(() => _payingJobId = job.id);
                                try {
                                  await JobPaymentFlow.resumePendingJob(
                                    context,
                                    job: job,
                                  );
                                  if (!mounted) return;
                                  await _load();
                                } finally {
                                  if (mounted) {
                                    setState(() => _payingJobId = null);
                                  }
                                }
                              },
                        child: _payingJobId == job.id
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                extra
                                    ? 'payment.approveExtra'.tr()
                                    : 'payment.payAuthorize'.tr(),
                                style: getPrimarySemiBoldStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
