void applySubmissionFieldErrors(
  dynamic details,
  void Function(String field, String message) setFieldError,
) {
  if (details is Map) {
    details.forEach((key, value) {
      setFieldError(key.toString(), value.toString());
    });
    return;
  }

  if (details is List) {
    for (final err in details) {
      if (err is Map &&
          err.containsKey('field') &&
          err.containsKey('message')) {
        setFieldError(
          err['field'].toString(),
          err['message'].toString(),
        );
      }
    }
  }
}
