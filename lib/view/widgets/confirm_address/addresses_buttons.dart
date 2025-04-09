import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/view/confirm_address/confirm_address.dart';
import 'package:dingdone/view/widgets/confirm_address/buttons/buttons_confirm_addresses.dart';
import 'package:dingdone/view_model/jobs_view_model/jobs_view_model.dart';
import 'package:dingdone/view_model/profile_view_model/profile_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddressesButtonsWidget extends StatefulWidget {
  const AddressesButtonsWidget({super.key});

  @override
  State<AddressesButtonsWidget> createState() => _AddressesButtonsWidgetState();
}

class _AddressesButtonsWidgetState extends State<AddressesButtonsWidget> {
  String? _active;

  void active(String btn) {
    setState(() => _active = btn);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      var profileViewModel =
          Provider.of<ProfileViewModel>(context, listen: false);
      var currentAddress = profileViewModel.getProfileBody['current_address'];
      if (currentAddress != null) {
        for (var i = 0;
            i < profileViewModel.getProfileBody['address'].length;
            i++) {
          var address = profileViewModel.getProfileBody['address'][i];
          if (address['city'] == currentAddress['city'] &&
              address['building_number'] == currentAddress['building_number'] &&
              address['apartment_number'] ==
                  currentAddress['apartment_number'] &&
              address['street_number'] == currentAddress['street_number']) {
            setState(() {
              _active = "$i";
            });
            break;
          }
        }
      }
    });
  }

  void deleteAddress(int index) {
    var profileViewModel =
        Provider.of<ProfileViewModel>(context, listen: false);
    // Reset the active address if the deleted address was the active one
    if (_active == "$index") {
      setState(() {
        _active = null;
      });
    } else if (_active != null && int.parse(_active!) > index) {
      setState(() {
        _active = (int.parse(_active!) - 1).toString();
      });
    }
    profileViewModel.deleteAddress(index);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<ProfileViewModel, JobsViewModel>(
      builder: (context, profileViewModel, jobsViewModel, _) {
        return Column(
          children: [
            ListView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              itemCount: profileViewModel.getProfileBody["address"].length,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                var address = profileViewModel.getProfileBody["address"][index];
                debugPrint('address in address buttons $address');
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Dismissible(
                      key: Key(address['id'].toString()),
                      direction: DismissDirection.endToStart,
                      onDismissed: (direction) {
                        deleteAddress(index);
                      },
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      child: ButtonsConfirmAddresses(
                        action: (tag) {
                          active(tag);
                          profileViewModel.setCurrentAddress(address);
                          jobsViewModel.setInputValues(
                              index: 'street_number',
                              value: address["street_number"]);
                          jobsViewModel.setInputValues(
                              index: 'address_label',
                              value: address["address_label"]);
                          jobsViewModel.setInputValues(
                              index: 'city', value: address["city"]);
                          jobsViewModel.setInputValues(
                              index: 'floor', value: address["floor"]);
                          jobsViewModel.setInputValues(
                              index: 'building_number',
                              value: address["building_number"]);
                          jobsViewModel.setInputValues(
                              index: 'apartment_number',
                              value: address["apartment_number"]);
                          jobsViewModel.setInputValues(
                              index: 'zone', value: address["zone"]);
                          jobsViewModel.setInputValues(
                              index: 'country', value: address["country"]);
                          _handleRefresh();
                        },
                        tag: "$index",
                        active: _active == "$index",
                        text: address['address_label'] ??
                            '${address["street_number"]}, ${address["city"]}, ${address["building_number"]}, ${address["apartment_number"]}, ${address["zone"]}',
                        address: address,
                      ),
                    ),
                    SizedBox(height: context.appValues.appSize.s10),
                  ],
                );
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _handleRefresh() async {
    try {
      // Simulate network fetch or database query
      await Future.delayed(Duration(seconds: 2));
      // Update the list of items and refresh the UI
      Navigator.pop(context);
      Navigator.of(context).push(_createRoute(ConfirmAddress()));
    } catch (error) {
      // Handle the error, e.g., by displaying a snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to refresh: $error'),
        ),
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

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}
