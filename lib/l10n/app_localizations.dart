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
      'playGame': 'Play Game',
      'chooseFromCategories': 'Choose from 8 categories',
      'dailyChallenge': 'Daily Challenge',
      'customWord': 'Custom Word',
      'yourProgress': 'Your Progress',
      'bestStreak': 'Best Streak',
      'totalScore': 'Total Score',
      'gamesWon': 'Games Won',
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
      'score': 'Score',
      'enterCustomWord': 'Enter Custom Word',
      'start': 'Start',
      'back': 'Back',
      'exitGame': 'Exit Game?',
      'exitGameContent': 'Are you sure you want to quit this game?',
      'cancel': 'CANCEL',
      'quit': 'QUIT',
      'wellDone': 'WELL DONE!',
      'ohYouLost': 'OHH... YOU LOST',
      'theWordWas': 'The word was:',
      'nextRound': 'NEXT ROUND',
      'keepStreak': 'KEEP STREAK',
      'statistics': 'Statistics',
      'connect': 'Connect',
      'currentStreak': 'Current Streak',
    },
    'hi': {
      'appTitle': 'हैंगमैन',
      'play': 'खेलें',
      'playGame': 'गेम खेलें',
      'chooseFromCategories': '8 श्रेणियों में से चुनें',
      'dailyChallenge': 'दैनिक चुनौती',
      'customWord': 'कस्टम शब्द',
      'yourProgress': 'आपकी प्रगति',
      'bestStreak': 'सर्वश्रेष्ठ स्ट्रीक',
      'totalScore': 'कुल स्कोर',
      'gamesWon': 'जीते गए खेल',
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
      'score': 'स्कोर',
      'enterCustomWord': 'कस्टम शब्द दर्ज करें',
      'start': 'शुरू करें',
      'back': 'वापस',
      'exitGame': 'खेल से बाहर निकलें?',
      'exitGameContent': 'क्या आप वाकई इस खेल को छोड़ना चाहते हैं?',
      'cancel': 'रद्द करें',
      'quit': 'छोड़ें',
      'wellDone': 'शाबाश!',
      'ohYouLost': 'अरे... आप हार गए',
      'theWordWas': 'शब्द था:',
      'nextRound': 'अगला राउंड',
      'keepStreak': 'स्ट्रीक बनाए रखें',
      'statistics': 'स्टेटिस्टिक्स',
      'connect': 'कनेक्ट',
      'currentStreak': 'वर्तमान स्ट्रीक',
    },
    'zh': {
      'appTitle': '刽子手',
      'play': '开始游戏',
      'playGame': '开始游戏',
      'chooseFromCategories': '从8个类别中选择',
      'dailyChallenge': '每日挑战',
      'customWord': '自定义单词',
      'yourProgress': '您的进度',
      'bestStreak': '最佳连胜',
      'totalScore': '总分',
      'gamesWon': '获胜场次',
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
      'score': '得分',
      'enterCustomWord': '输入自定义单词',
      'start': '开始',
      'back': '返回',
      'exitGame': '退出游戏？',
      'exitGameContent': '您确定要退出这个游戏吗？',
      'cancel': '取消',
      'quit': '退出',
      'wellDone': '干得好！',
      'ohYouLost': '哦...你输了',
      'theWordWas': '答案是：',
      'nextRound': '下一轮',
      'keepStreak': '保持连胜',
      'statistics': '统计',
      'connect': '连接',
      'currentStreak': '当前连胜',
    },
  };

  String get appTitle => _localizedValues[_languageCode]!['appTitle']!;
  String get play => _localizedValues[_languageCode]!['play']!;
  String get playGame => _localizedValues[_languageCode]!['playGame']!;
  String get chooseFromCategories => _localizedValues[_languageCode]!['chooseFromCategories']!;
  String get dailyChallenge => _localizedValues[_languageCode]!['dailyChallenge']!;
  String get customWord => _localizedValues[_languageCode]!['customWord']!;
  String get yourProgress => _localizedValues[_languageCode]!['yourProgress']!;
  String get bestStreak => _localizedValues[_languageCode]!['bestStreak']!;
  String get totalScore => _localizedValues[_languageCode]!['totalScore']!;
  String get gamesWon => _localizedValues[_languageCode]!['gamesWon']!;
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
  String get score => _localizedValues[_languageCode]!['score']!;
  String get enterCustomWord => _localizedValues[_languageCode]!['enterCustomWord']!;
  String get start => _localizedValues[_languageCode]!['start']!;
  String get back => _localizedValues[_languageCode]!['back']!;
  String get exitGame => _localizedValues[_languageCode]!['exitGame']!;
  String get exitGameContent => _localizedValues[_languageCode]!['exitGameContent']!;
  String get cancel => _localizedValues[_languageCode]!['cancel']!;
  String get quit => _localizedValues[_languageCode]!['quit']!;
  String get wellDone => _localizedValues[_languageCode]!['wellDone']!;
  String get ohYouLost => _localizedValues[_languageCode]!['ohYouLost']!;
  String get theWordWas => _localizedValues[_languageCode]!['theWordWas']!;
  String get nextRound => _localizedValues[_languageCode]!['nextRound']!;
  String get keepStreak => _localizedValues[_languageCode]!['keepStreak']!;
  String get statistics => _localizedValues[_languageCode]!['statistics']!;
  String get connect => _localizedValues[_languageCode]!['connect']!;
  String get currentStreak => _localizedValues[_languageCode]!['currentStreak']!;

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