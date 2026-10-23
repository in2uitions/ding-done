import 'package:flutter_dotenv/flutter_dotenv.dart';

class Constants {
  static const String customerRoleId = "008f8da4-ae7c-42f2-a498-68d490fe4593";
  static const String supplierRoleId = "3a537282-12ad-4ddb-b9a9-718833a2beea";

  static String get googleApiKey => dotenv.env['GOOGLE_API_KEY'] ?? '';
}
