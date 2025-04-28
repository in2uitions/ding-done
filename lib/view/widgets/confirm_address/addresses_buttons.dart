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

  void _setActive(String btn) {
    setState(() => _active = btn);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final profileVM = Provider.of<ProfileViewModel>(context, listen: false);
      final current = profileVM.getProfileBody['current_address'];
      if (current != null) {
        final list = profileVM.getProfileBody['address'] as List<dynamic>;
        for (var i = 0; i < list.length; i++) {
          final addr = list[i];
          if (addr['city'] == current['city'] &&
              addr['building_number'] == current['building_number'] &&
              addr['apartment_number'] == current['apartment_number'] &&
              addr['street_number'] == current['street_number']) {
            setState(() => _active = '$i');
            break;
          }
        }
      }
    });
  }

  void _deleteAddress(int index) {
    setState(() {
      final profileVM = Provider.of<ProfileViewModel>(context, listen: false);
      if (_active == '$index') {
        _active = null;
      } else if (_active != null && int.parse(_active!) > index) {
        _active = (int.parse(_active!) - 1).toString();
      }
      profileVM.deleteAddress(index);
    });
  }

  Future<bool> _confirmDelete(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Confirm Deletion'),
        content: const Text('Are you sure you want to delete this address?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    return result == true;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<ProfileViewModel, JobsViewModel>(
      builder: (context, profileVM, jobsVM, _) {
        final addresses = profileVM.getProfileBody['address'] as List<dynamic>;
        return Column(
          children: [
            ListView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              itemCount: addresses.length,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final address = addresses[index] as Map<String, dynamic>;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Dismissible(
                      key: Key(address['id'].toString()),
                      direction: DismissDirection.endToStart,
                      confirmDismiss: (_) async {
                        final confirmed = await _confirmDelete(context);
                        if (confirmed) {
                          _deleteAddress(index);
                        }
                        return confirmed;
                      },
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      child: ButtonsConfirmAddresses(
                        action: (tag) {
                          _setActive(tag);
                          profileVM.setCurrentAddress(address);
                          ['street_number', 'address_label', 'city', 'floor', 'building_number', 'apartment_number', 'zone', 'country']
                              .forEach((field) {
                            jobsVM.setInputValues(
                              index: field,
                              value: address[field]?.toString() ?? '',
                            );
                          });
                          Future.microtask(() {
                            Navigator.pop(context);
                            Navigator.of(context).push(
                              PageRouteBuilder(
                                pageBuilder: (ctx, anim1, anim2) => ConfirmAddress(),
                                transitionsBuilder: (c, a, sa, child) =>
                                    SlideTransition(
                                      position: Tween(begin: const Offset(1, 0), end: Offset.zero)
                                          .chain(CurveTween(curve: Curves.ease))
                                          .animate(a),
                                      child: child,
                                    ),
                              ),
                            );
                          });
                        },
                        tag: '$index',
                        active: _active == '$index',
                        text: address['address_label'] ??
                            '${address['street_number']}, ${address['city']}, ${address['building_number']}, ${address['apartment_number']}, ${address['zone']}',
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
}
