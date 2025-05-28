import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:intl/intl.dart';

class ActualStartTimeWidget extends StatefulWidget {
  final String? actual_start_date;
  final String? actual_end_date;

  ActualStartTimeWidget({
    super.key,
    required this.actual_start_date,
    required this.actual_end_date,
  });

  @override
  State<ActualStartTimeWidget> createState() => _ActualStartTimeWidgetState();
}

class _ActualStartTimeWidgetState extends State<ActualStartTimeWidget> {
  String _formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return '';

    // If dateString already ends with 'Z', don't add it again.
    String toParse = dateString.endsWith('Z') ? dateString : dateString + 'Z';

    try {
      DateTime parsedDate = DateTime.parse(toParse).toUtc().toLocal();
      return DateFormat('d MMMM yyyy, HH:mm').format(parsedDate);
    } catch (e) {
      debugPrint('Date parsing error: $e');
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: context.appValues.appPadding.p20,
            vertical: context.appValues.appPadding.p10,
          ),
          child: SizedBox(
            width: context.appValues.appSizePercent.w90,
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                context.appValues.appPadding.p0,
                context.appValues.appPadding.p0,
                context.appValues.appPadding.p0,
                context.appValues.appPadding.p0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: context.appValues.appPadding.p10,
                    ),
                    child: Text(
                      translate('updateJob.actualStartTime'),
                      style: getPrimaryRegularStyle(
                        fontSize: 14,
                        color: const Color(0xff180B3C),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      _formatDate(widget.actual_start_date),
                      style: getPrimaryRegularStyle(
                        fontSize: 14,
                        color: const Color(0xff71727A),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
