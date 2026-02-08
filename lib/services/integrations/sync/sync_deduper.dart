class SyncDeduper<T> {
  SyncDeduper({
    required this.identityFor,
  });

  final String Function(T record) identityFor;

  List<T> dedupe(Iterable<T> records) {
    final seen = <String>{};
    final results = <T>[];
    for (final record in records) {
      final key = identityFor(record);
      if (seen.add(key)) {
        results.add(record);
      }
    }
    return results;
  }
}
