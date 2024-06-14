import 'package:flutter/cupertino.dart';
import 'package:dingdone/view_model/dispose_view_model/dispose_view_model.dart';

class AppProviders extends ChangeNotifier {
  static List<DisposableViewModel> getDisposableProviders(
      BuildContext context) {
    return [
      // Provider.of<ProfileViewModel>(context, listen: false),
      // Provider.of<HomeViewModel>(context, listen: false),
      // Provider.of<JobsViewModel>(context, listen: false),
      // Provider.of<ChatViewModel>(context, listen: false),
    ];
  }

  static void disposeAllDisposableProviders(BuildContext context) {
    getDisposableProviders(context).forEach((disposableProvider) {
      disposableProvider.disposeValues();
    });
  }
}
