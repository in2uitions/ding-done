import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

const kPrimaryColor = Color(0xFF6F35A5);
const kPrimaryLightColor = Color(0xFFF1E6FF);

String get apiKey => dotenv.env['COMETCHAT_API_KEY'] ?? '';
String get appId => dotenv.env['COMETCHAT_APP_ID'] ?? '';
String get appAuth => dotenv.env['COMETCHAT_AUTH_KEY'] ?? '';
String get region => dotenv.env['COMETCHAT_REGION'] ?? '';
const jobSeeker = "66bf2dcf-fa19-4285-9ab4-9a7dda108925";
const recruiter = "5cfe84cc-26b3-4880-b770-90df33b2142e";
String get cometChatUrl => "https://$appId.api-$region.cometchat.io/v3/users";

const double defaultPadding = 16.0;
