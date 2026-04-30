class ScanResult {
  final String topLabel;
  final double topScore;
  final List<Map<String, dynamic>> allResults;
  final String imageType;

  const ScanResult({
    required this.topLabel,
    required this.topScore,
    required this.allResults,
    required this.imageType,
  });

  factory ScanResult.fromJson(
    List<dynamic> json,
    String imageType,
  ) {
    final sorted = List<Map<String, dynamic>>.from(json)
      ..sort((a, b) =>
          (b['score'] as double).compareTo(a['score'] as double));

    return ScanResult(
      topLabel: sorted.first['label'] as String,
      topScore: (sorted.first['score'] as double),
      allResults: sorted,
      imageType: imageType,
    );
  }
}
