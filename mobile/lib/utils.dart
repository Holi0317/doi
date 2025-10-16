/// Check if a given string is a valid web URI (http or https).
///
/// Returns the parsed Uri if valid, otherwise returns null.
Uri? isWebUri(String uri) {
  final parsed = Uri.tryParse(uri);
  if (parsed == null) {
    return null;
  }

  if (parsed.scheme != 'http' && parsed.scheme != 'https') {
    return null;
  }

  return parsed;
}
