class JobPaymentStatus {
  static const unpaid = 'unpaid';
  static const authorizationPending = 'authorization_pending';
  static const authorized = 'authorized';
  static const extraPending = 'extra_pending';
  static const paid = 'paid';
  static const cancelled = 'cancelled';

  static String? normalize(dynamic value) {
    final status = value?.toString().trim().toLowerCase();
    if (status == null || status.isEmpty) return null;
    return status;
  }

  static bool isCancelled(dynamic value) => normalize(value) == cancelled;

  static bool needsInitialPayment(dynamic value) {
    final status = normalize(value);
    return status == unpaid || status == authorizationPending;
  }

  static bool needsExtraPayment(dynamic value) =>
      normalize(value) == extraPending;

  static bool needsAnyPayment(dynamic value) =>
      needsInitialPayment(value) || needsExtraPayment(value);

  static bool isAuthorized(dynamic value) {
    final status = normalize(value);
    return status == authorized || status == paid;
  }

  static bool isPaid(dynamic value) => normalize(value) == paid;
}
