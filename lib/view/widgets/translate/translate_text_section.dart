import 'package:dingdone/res/fonts/styles_manager.dart';
import 'package:dingdone/utils/translation_helper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class TranslateTextSection extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final int? maxLines;
  final TextOverflow? overflow;

  const TranslateTextSection({
    super.key,
    required this.text,
    this.style,
    this.maxLines,
    this.overflow,
  });

  @override
  State<TranslateTextSection> createState() => _TranslateTextSectionState();
}

class _TranslateTextSectionState extends State<TranslateTextSection> {
  bool _showingTranslation = false;
  bool _isTranslating = false;
  String? _translatedText;

  Future<void> _toggleTranslation() async {
    if (_showingTranslation) {
      setState(() => _showingTranslation = false);
      return;
    }

    if (_translatedText != null) {
      setState(() => _showingTranslation = true);
      return;
    }

    setState(() => _isTranslating = true);
    try {
      final translated = await TranslationHelper.translate(widget.text);
      if (!mounted) return;

      if (translated.trim() == widget.text.trim()) {
        setState(() => _isTranslating = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('button.alreadyInYourLanguage'.tr())),
        );
        return;
      }

      setState(() {
        _translatedText = translated;
        _showingTranslation = true;
        _isTranslating = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _isTranslating = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('button.tryAgainLater'.tr())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final displayText = _showingTranslation
        ? (_translatedText ?? widget.text)
        : widget.text;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          displayText,
          maxLines: widget.maxLines,
          overflow: widget.overflow,
          style: widget.style ??
              getPrimaryRegularStyle(
                fontSize: 14,
                color: const Color(0xff71727A),
              ),
        ),
        if (widget.text.trim().isNotEmpty)
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: _isTranslating ? null : _toggleTranslation,
              icon: _isTranslating
                  ? const SizedBox(
                      width: 14,
                      height: 14,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.translate, size: 14),
              label: Text(
                _showingTranslation
                    ? 'button.showOriginal'.tr()
                    : 'button.translate'.tr(),
                style: getPrimaryRegularStyle(
                  fontSize: 12,
                  color: const Color(0xff4100E3),
                ),
              ),
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
          ),
      ],
    );
  }
}
