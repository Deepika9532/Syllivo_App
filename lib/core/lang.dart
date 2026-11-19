class LangInfo {
  final String code;
  final String name;
  final String nativeName;
  final String flag;
  final String ttsLocale;
  final String sttLocale;

  const LangInfo(this.code, this.name, this.nativeName, this.flag,
      this.ttsLocale, this.sttLocale);
}

const languages = <String, LangInfo>{
  'de': LangInfo('de', 'German', 'Deutsch', '🇩🇪', 'de-DE', 'de_DE'),
  'ko': LangInfo('ko', 'Korean', '한국어', '🇰🇷', 'ko-KR', 'ko_KR'),
};
