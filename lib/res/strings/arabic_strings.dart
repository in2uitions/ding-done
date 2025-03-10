import 'package:dingdone/res/strings/strings.dart';

class ArabicStrings extends Strings {
  static const Map<String, String> _formKeys = {
    'email': 'email',
    'password': 'password',
    'first_name': 'first_name',
    'last_name': 'last_name',
    'street_name': 'street_name',
    'floor': 'floor',
    'zone': 'zone',
    'country': 'country',

    'street_number': 'street_number',
    'building_number': 'building_number',
    'apartment_number': 'apartment_number',
    'city': 'city',
    'state': 'state',
    'postal_code': 'postal_code',
    'payment_method': 'payment_method',
    'categories': 'categories',
    'dob': 'dob',
    'registration_number': 'registration_number',
    'location': 'location',
    'phone_number': 'phone_number',
    'contact_details': 'contact_details',
    'supplier_categories': 'supplier_categories',
    'supplier_services': 'supplier_services',
    'company_id': 'company_id',
    // 'company_name': 'Company Name'
  };

  static const Map<String, String> _formHints = {
    'email_address': 'عنوان بريدك الإلكتروني',
    'password': 'كلمة المرور',
    'first_name': 'First Name',
    'last_name': 'Last Name',
    'street_name': 'Street Name',
    'floor': 'Floor',
    'zone': 'Zone',
    'country': 'Country',

    'street_number': 'Street Number',
    'building_number': 'Building Number',
    'apartment_number': 'Apartment Number',
    'city': 'City',
    'state': 'State',
    'postal_code': 'Postal Code',
    'payment_method': 'Payment Method',
    'categories': 'Categories',
    'registration_number': 'Registration Number',
    'contact_details': 'Bank Account Info',
    // 'profession': 'Profession',
    // 'fresh_grad': 'Fresh Grad',
    // 'role': 'Sign up as',
    'dob': 'Date Of Birth',
    'location': 'Location',
    'phone_number': 'Phone Number',
    'supplier_categories': 'Supplier Categories',
    'supplier_services': 'Supplier Services',
    'company_id': 'Company Id',
    // 'company_name': 'Company Name'
  };
  @override
  Map<String, String> get formKeys => _formKeys;

  @override
  Map<String, String> get formHints => _formHints;

  @override
  String get dingDone => 'Ding Done';
}
