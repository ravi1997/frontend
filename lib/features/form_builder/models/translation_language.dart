/// Represents a supported language for translation.
class TranslationLanguage {
  /// ISO 639-1 language code
  final String code;

  /// Display name in English
  final String name;

  /// Display name in native language
  final String? nativeName;

  /// Whether this language is enabled for translation
  final bool isEnabled;

  const TranslationLanguage({
    required this.code,
    required this.name,
    this.nativeName,
    this.isEnabled = true,
  });

  /// Converts to JSON.
  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'name': name,
      'nativeName': nativeName,
      'isEnabled': isEnabled,
    };
  }

  /// Creates from JSON.
  factory TranslationLanguage.fromJson(Map<String, dynamic> json) {
    return TranslationLanguage(
      code: json['code'] as String,
      name: json['name'] as String,
      nativeName: json['nativeName'] as String?,
      isEnabled: json['isEnabled'] as bool? ?? true,
    );
  }

  /// List of commonly used languages.
  static const List<TranslationLanguage> all = [
    TranslationLanguage(code: 'en', name: 'English', nativeName: 'English'),
    TranslationLanguage(code: 'es', name: 'Spanish', nativeName: 'Español'),
    TranslationLanguage(code: 'fr', name: 'French', nativeName: 'Français'),
    TranslationLanguage(code: 'de', name: 'German', nativeName: 'Deutsch'),
    TranslationLanguage(code: 'it', name: 'Italian', nativeName: 'Italiano'),
    TranslationLanguage(
      code: 'pt',
      name: 'Portuguese',
      nativeName: 'Português',
    ),
    TranslationLanguage(code: 'zh', name: 'Chinese', nativeName: '中文'),
    TranslationLanguage(code: 'ja', name: 'Japanese', nativeName: '日本語'),
    TranslationLanguage(code: 'ko', name: 'Korean', nativeName: '한국어'),
    TranslationLanguage(
      code: 'ar',
      name: 'Arabic',
      nativeName: 'العربية',
      isEnabled: false,
    ),
    TranslationLanguage(
      code: 'hi',
      name: 'Hindi',
      nativeName: 'हिन्दी',
      isEnabled: false,
    ),
    TranslationLanguage(
      code: 'ru',
      name: 'Russian',
      nativeName: 'Русский',
      isEnabled: false,
    ),
  ];
}
