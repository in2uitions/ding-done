import 'dart:convert';

import 'package:card_flutter/card_flutter.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class TapVerifyCardScreen extends StatefulWidget {
  const TapVerifyCardScreen({
    super.key,
    required this.publicKey,
    required this.customerId,
    required this.profile,
    required this.onToken,
  });

  final String publicKey;
  final String customerId;
  final Map<String, dynamic> profile;
  final Future<String?> Function(String token) onToken;

  @override
  State<TapVerifyCardScreen> createState() => _TapVerifyCardScreenState();
}

class _TapVerifyCardScreenState extends State<TapVerifyCardScreen> {
  bool _generateToken = false;
  bool _cardReady = false;
  bool _inputValid = false;
  bool _submitting = false;
  String? _errorText;
  Map<String, dynamic> get _user {
    final user = widget.profile['user'];
    return user is Map ? Map<String, dynamic>.from(user) : {};
  }

  Map<String, dynamic> _sdkConfiguration() {
    final first = _user['first_name']?.toString() ?? '';
    final last = _user['last_name']?.toString() ?? '';
    var countryCode = _user['phone_code']?.toString().trim() ?? '';
    if (countryCode.isNotEmpty && !countryCode.startsWith('+')) {
      countryCode = '+$countryCode';
    }
    final phone = _user['phone_number']?.toString() ??
        _user['phone']?.toString() ??
        '';

    return {
      'operator': {'publicKey': widget.publicKey},
      'scope': 'Token',
      'purpose': 'Save Token',
      'merchant': {'id': '49941248'},
      'order': {
        'id': '',
        'amount': 1.0,
        'currency': 'QAR',
        'description': 'Save card',
        'reference': '',
      },
      'customer': {
        'id': widget.customerId,
        'name': [
          {'lang': 'en', 'first': first, 'middle': '', 'last': last},
        ],
        'nameOnCard': '$first $last'.trim(),
        'editable': true,
        'contact': {
          'email': _user['email']?.toString() ?? '',
          'phone': {'countryCode': countryCode, 'number': phone},
        },
      },
      'acceptance': {
        'supportedSchemes': ['VISA', 'MASTERCARD'],
        'supportedFundSource': ['CREDIT', 'DEBIT'],
        'supportedPaymentAuthentications': ['3DS'],
      },
      'fieldVisibility': {
        'card': {'cardHolder': true, 'cvv': true},
      },
      'interface': {
        'locale': 'en',
        'theme': 'light',
        'edges': 'curved',
        'loader': true,
      },
    };
  }

  String? _tokenFrom(String? raw) {
    final text = raw?.trim() ?? '';
    if (text.isEmpty) return null;
    if (text.startsWith('tok_')) return text;
    try {
      final decoded = jsonDecode(text);
      if (decoded is Map) {
        final id = decoded['id']?.toString();
        if (id != null && id.startsWith('tok_')) return id;
        final token = decoded['token'];
        if (token is String && token.startsWith('tok_')) return token;
        if (token is Map && token['id'] != null) {
          return token['id'].toString();
        }
      }
    } catch (_) {}
    return null;
  }

  Future<void> _submitToken(String? raw) async {
    final token = _tokenFrom(raw);
    if (!mounted) return;
    if (token == null) {
      setState(() {
        _submitting = false;
        _generateToken = false;
        _errorText = 'Tap did not return a card token.';
      });
      return;
    }
    try {
      final url = await widget.onToken(token);
      if (!mounted) return;
      Navigator.of(context).pop(url ?? '');
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _submitting = false;
        _generateToken = false;
        _errorText = error
            .toString()
            .replaceFirst('Exception: ', '')
            .replaceFirst('Error During Communication: ', '');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('paymentMethod.addPaymentMethod'.tr()),
      ),
      body: Column(
        children: [
          TapCardViewWidget(
              sdkConfiguration: _sdkConfiguration(),
              generateToken: _generateToken,
              onReady: () {
                if (mounted) setState(() => _cardReady = true);
              },
              onFocus: () {
                if (!mounted) return;
                setState(() => _generateToken = false);
              },
              onHeightChange: (_) {},
              onBinIdentification: (_) {},
              onChangeSaveCard: (_) {},
              onValidInput: (String? valid) {
                if (!mounted) return;
                setState(() {
                  _cardReady = true;
                  _inputValid = valid == 'true';
                });
              },
              onSuccess: (String? success) {
                _submitToken(success);
              },
              onError: (String? error) {
                if (!mounted) return;
                setState(() {
                  _submitting = false;
                  _generateToken = false;
                  _errorText = (error == null || error.trim().isEmpty)
                      ? 'Tap could not read this card.'
                      : error;
                });
              },
            ),
          if (_errorText != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
              child: Text(
                _errorText!,
                textAlign: TextAlign.center,
                style: getPrimaryRegularStyle(fontSize: 14, color: Colors.red),
              ),
            ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            child: SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff4100E3),
                  disabledBackgroundColor: const Color(0xffC5C6CC),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: (!_cardReady || !_inputValid || _submitting)
                    ? null
                    : () {
                        setState(() {
                          _errorText = null;
                          _submitting = true;
                          _generateToken = true;
                        });
                      },
                child: _submitting
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        'paymentMethod.addPaymentMethod'.tr(),
                        style: getPrimaryBoldStyle(
                          fontSize: 14,
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
}
