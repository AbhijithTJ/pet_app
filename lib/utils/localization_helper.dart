import 'package:flutter/material.dart';

/// Helper to get localized text from a Firestore document based on the current app locale.
/// It checks for `${field}_${lang}` first, then falls back to `${field}_en`, and finally just `$field`.
String getLocalizedText(Map<String, dynamic> data, String field, BuildContext context) {
  final lang = Localizations.localeOf(context).languageCode;
  
  // Try to get the localized version (e.g. title_ml)
  if (data.containsKey('${field}_$lang') && data['${field}_$lang'] != null && data['${field}_$lang'].toString().isNotEmpty) {
    return data['${field}_$lang'].toString();
  }
  
  // Fallback to English (e.g. title_en)
  if (data.containsKey('${field}_en') && data['${field}_en'] != null && data['${field}_en'].toString().isNotEmpty) {
    return data['${field}_en'].toString();
  }
  
  // Fallback to the legacy field name (e.g. title)
  if (data.containsKey(field) && data[field] != null) {
    return data[field].toString();
  }
  
  return '';
}
