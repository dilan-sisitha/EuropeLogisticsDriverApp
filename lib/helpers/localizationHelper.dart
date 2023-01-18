class LocalizationHelper {
  String localize(String text, [Map<String, String> args = const {}]) {
    if (args.isEmpty) return text;
    String result = text;
    args.forEach((key, value) {
      if (text.contains('{$key}')) {
        result = result.replaceAll('{$key}', value);
      }
    });
    return result.replaceAll(RegExp(r'[\{|\}]'), '');
  }
}
