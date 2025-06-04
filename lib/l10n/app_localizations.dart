import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'appTitle': 'Hangman',
      'play': 'Play',
      'dailyChallenge': 'Daily Challenge',
      'customWord': 'Custom Word',
      'settings': 'SETTINGS',
      'language': 'Language',
      'categories': 'Categories',
      'random': 'Random',
      'music': 'Music',
      'movies': 'Movies',
      'sports': 'Sports',
      'food': 'Food',
      'countries': 'Countries',
      'technology': 'Technology',
      'animals': 'Animals',
      'gameOver': 'Game Over',
      'youWon': 'You Won!',
      'youLost': 'You Lost!',
      'nextWord': 'Next Word',
      'exit': 'Exit',
      'streak': 'Streak',
      'lives': 'Lives',
      'enterCustomWord': 'Enter Custom Word',
      'start': 'Start',
      'back': 'Back',
    },
    'hi': {
      'appTitle': 'हैंगमैन',
      'play': 'खेलें',
      'dailyChallenge': 'दैनिक चुनौती',
      'customWord': 'कस्टम शब्द',
      'settings': 'सेटिंग्स',
      'language': 'भाषा',
      'categories': 'श्रेणियाँ',
      'random': 'रैंडम',
      'music': 'संगीत',
      'movies': 'फिल्में',
      'sports': 'खेल',
      'food': 'खाना',
      'countries': 'देश',
      'technology': 'तकनीक',
      'animals': 'जानवर',
      'gameOver': 'खेल समाप्त',
      'youWon': 'आप जीत गए!',
      'youLost': 'आप हार गए!',
      'nextWord': 'अगला शब्द',
      'exit': 'बाहर निकलें',
      'streak': 'स्ट्रीक',
      'lives': 'जीवन',
      'enterCustomWord': 'कस्टम शब्द दर्ज करें',
      'start': 'शुरू करें',
      'back': 'वापस',
    },
    'zh': {
      'appTitle': '刽子手',
      'play': '开始游戏',
      'dailyChallenge': '每日挑战',
      'customWord': '自定义单词',
      'settings': '设置',
      'language': '语言',
      'categories': '类别',
      'random': '随机',
      'music': '音乐',
      'movies': '电影',
      'sports': '体育',
      'food': '食物',
      'countries': '国家',
      'technology': '科技',
      'animals': '动物',
      'gameOver': '游戏结束',
      'youWon': '你赢了！',
      'youLost': '你输了！',
      'nextWord': '下一个词',
      'exit': '退出',
      'streak': '连胜',
      'lives': '生命',
      'enterCustomWord': '输入自定义单词',
      'start': '开始',
      'back': '返回',
    },
  };

  String get appTitle => _localizedValues[_languageCode]!['appTitle']!;
  String get play => _localizedValues[_languageCode]!['play']!;
  String get dailyChallenge => _localizedValues[_languageCode]!['dailyChallenge']!;
  String get customWord => _localizedValues[_languageCode]!['customWord']!;
  String get settings => _localizedValues[_languageCode]!['settings']!;
  String get language => _localizedValues[_languageCode]!['language']!;
  String get categories => _localizedValues[_languageCode]!['categories']!;
  String get random => _localizedValues[_languageCode]!['random']!;
  String get music => _localizedValues[_languageCode]!['music']!;
  String get movies => _localizedValues[_languageCode]!['movies']!;
  String get sports => _localizedValues[_languageCode]!['sports']!;
  String get food => _localizedValues[_languageCode]!['food']!;
  String get countries => _localizedValues[_languageCode]!['countries']!;
  String get technology => _localizedValues[_languageCode]!['technology']!;
  String get animals => _localizedValues[_languageCode]!['animals']!;
  String get gameOver => _localizedValues[_languageCode]!['gameOver']!;
  String get youWon => _localizedValues[_languageCode]!['youWon']!;
  String get youLost => _localizedValues[_languageCode]!['youLost']!;
  String get nextWord => _localizedValues[_languageCode]!['nextWord']!;
  String get exit => _localizedValues[_languageCode]!['exit']!;
  String get streak => _localizedValues[_languageCode]!['streak']!;
  String get lives => _localizedValues[_languageCode]!['lives']!;
  String get enterCustomWord => _localizedValues[_languageCode]!['enterCustomWord']!;
  String get start => _localizedValues[_languageCode]!['start']!;
  String get back => _localizedValues[_languageCode]!['back']!;

  String get _languageCode {
    switch (locale.languageCode) {
      case 'hi':
        return 'hi';
      case 'zh':
        return 'zh';
      default:
        return 'en';
    }
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'hi', 'zh'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) {
    return Future.value(AppLocalizations(locale));
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
} 