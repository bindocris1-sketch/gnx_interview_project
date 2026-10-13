class AppConfig {
  AppConfig._();

  /// Provided at build time: --dart-define=PIXABAY_API_KEY=xxxx
  static const String apiKey = String.fromEnvironment('PIXABAY_API_KEY');
  static const String host = 'pixabay.com';
  static const String path = '/api/';
  static const int perPage = 30;

  static const List<String> categories = [
    'backgrounds', 'fashion', 'nature', 'science', 'education', 'feelings',
    'health', 'people', 'religion', 'places', 'animals', 'industry',
    'computer', 'food', 'sports', 'transportation', 'travel', 'buildings',
    'business', 'music',
  ];
}
