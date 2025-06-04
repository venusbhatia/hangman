import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/game_enums.dart';

class GameProvider with ChangeNotifier {
  final SharedPreferences prefs;
  
  // Game state
  String _word = '';
  List<String> _guessedLetters = [];
  int _lives = 6;
  int _streak = 0;
  int _coins = 0;
  GameMode _currentMode = GameMode.singlePlayer;
  GameCategory _currentCategory = GameCategory.random;
  int _maxStreak = 0;
  String _language = 'English';
  Set<String> _unlockedCategories = {
    'Random',
    'Music',
    'Movies',
    'Sports',
    'Food',
    'Countries',
    'Technology',
    'Animals'
  };
  String? _customWord;

  final Map<String, Map<GameCategory, List<String>>> _languageWords = {
    'English': {
      GameCategory.random: [
        'FLUTTER', 'DART', 'PROGRAMMING', 'MOBILE', 'DEVELOPMENT',
        'APPLICATION', 'CODING', 'SOFTWARE', 'COMPUTER', 'TECHNOLOGY'
      ],
      GameCategory.countries: [
        'FRANCE', 'SPAIN', 'ITALY', 'GERMANY', 'BRAZIL',
        'JAPAN', 'CHINA', 'INDIA', 'CANADA', 'MEXICO'
      ],
      GameCategory.music: [
        'GUITAR', 'PIANO', 'DRUMS', 'VIOLIN', 'SAXOPHONE',
        'TRUMPET', 'FLUTE', 'ORCHESTRA', 'CONCERT', 'MELODY'
      ],
      GameCategory.movies: [
        'AVATAR', 'TITANIC', 'INCEPTION', 'GLADIATOR', 'MATRIX',
        'JAWS', 'FROZEN', 'GODFATHER', 'STARWARS', 'JURASSIC'
      ],
      GameCategory.sports: [
        'FOOTBALL', 'BASKETBALL', 'TENNIS', 'SOCCER', 'BASEBALL',
        'VOLLEYBALL', 'CRICKET', 'HOCKEY', 'RUGBY', 'GOLF'
      ],
      GameCategory.food: [
        'PIZZA', 'BURGER', 'SUSHI', 'PASTA', 'TACOS',
        'SALAD', 'SANDWICH', 'NOODLES', 'CHICKEN', 'STEAK'
      ],
      GameCategory.technology: [
        'COMPUTER', 'SMARTPHONE', 'INTERNET', 'ROBOT', 'ARTIFICIAL',
        'VIRTUAL', 'DIGITAL', 'NETWORK', 'WIRELESS', 'BLOCKCHAIN'
      ],
      GameCategory.animals: [
        'ELEPHANT', 'GIRAFFE', 'PENGUIN', 'DOLPHIN', 'KANGAROO',
        'BUTTERFLY', 'OCTOPUS', 'CHEETAH', 'PANDA', 'KOALA'
      ],
    },
    'हिंदी': {
      GameCategory.random: [
        'कमल', 'आम', 'किताब', 'पानी', 'दिल्ली',
        'भारत', 'कलम', 'मोबाइल', 'कंप्यूटर', 'टेबल'
      ],
      GameCategory.countries: [
        'भारत', 'चीन', 'नेपाल', 'जापान', 'रूस',
        'अमेरिका', 'कनाडा', 'फ्रांस', 'जर्मनी', 'इटली'
      ],
      GameCategory.music: [
        'तबला', 'सितार', 'बांसुरी', 'हारमोनियम', 'ढोलक',
        'संतूर', 'वीणा', 'सरोद', 'तानपुरा', 'मृदंग'
      ],
      GameCategory.movies: [
        'शोले', 'मुगलेआजम', 'मदर', 'रजा', 'दंगल',
        'लगान', 'बाहुबली', 'पीके', 'थ्रीइडियट्स', 'कभीखुशी'
      ],
      GameCategory.sports: [
        'क्रिकेट', 'हॉकी', 'कबड्डी', 'बैडमिंटन', 'कुश्ती',
        'शतरंज', 'फुटबॉल', 'टेनिस', 'गोल्फ', 'मुक्केबाजी'
      ],
      GameCategory.food: [
        'दालचावल', 'पनीर', 'रोटी', 'समोसा', 'पकोड़ा',
        'बिरयानी', 'पावभाजी', 'छोलेभटूरे', 'इडली', 'डोसा'
      ],
      GameCategory.technology: [
        'कंप्यूटर', 'मोबाइल', 'इंटरनेट', 'रोबोट', 'कृत्रिम',
        'आभासी', 'डिजिटल', 'नेटवर्क', 'वायरलेस', 'ब्लॉकचेन'
      ],
      GameCategory.animals: [
        'हाथी', 'जिराफ', 'पेंगुइन', 'डॉल्फिन', 'कंगारू',
        'तितली', 'ऑक्टोपस', 'चीता', 'पांडा', 'कोआला'
      ],
    },
    '中文': {
      GameCategory.random: [
        '电脑', '手机', '书本', '水', '天空',
        '地球', '太阳', '月亮', '星星', '云彩'
      ],
      GameCategory.countries: [
        '中国', '日本', '韩国', '美国', '英国',
        '法国', '德国', '意大利', '西班牙', '俄罗斯'
      ],
      GameCategory.music: [
        '钢琴', '小提琴', '吉他', '笛子', '古筝',
        '二胡', '琵琶', '箫', '鼓', '三弦'
      ],
      GameCategory.movies: [
        '英雄', '长城', '功夫', '红海行动', '战狼',
        '流浪地球', '哪吒', '姜子牙', '西游记', '红高粱'
      ],
      GameCategory.sports: [
        '乒乓球', '羽毛球', '足球', '篮球', '排球',
        '网球', '游泳', '跑步', '举重', '武术'
      ],
      GameCategory.food: [
        '包子', '饺子', '面条', '米饭', '火锅',
        '烤鸭', '春卷', '炒饭', '馒头', '豆腐'
      ],
      GameCategory.technology: [
        '电脑', '智能手机', '互联网', '机器人', '人工智能',
        '虚拟现实', '数字化', '网络', '无线', '区块链'
      ],
      GameCategory.animals: [
        '大象', '长颈鹿', '企鹅', '海豚', '袋鼠',
        '蝴蝶', '章鱼', '猎豹', '熊猫', '考拉'
      ],
    },
  };
  
  // Getters
  String get word => _word;
  List<String> get guessedLetters => _guessedLetters;
  int get lives => _lives;
  int get streak => _streak;
  int get coins => _coins;
  GameMode get currentMode => _currentMode;
  GameCategory get currentCategory => _currentCategory;
  int get maxStreak => _maxStreak;
  String get language => _language;
  Set<String> get unlockedCategories => _unlockedCategories;
  
  // Computed properties
  bool get isGameOver => _lives <= 0;
  bool get isGameWon => _word.isNotEmpty && _word.split('').every((letter) => _guessedLetters.contains(letter.toLowerCase()));
  
  String get maskedWord {
    if (_word.isEmpty) return '';
    return _word.split('').map((letter) {
      return _guessedLetters.contains(letter.toLowerCase()) ? letter : '_';
    }).join(' ');
  }
  
  GameProvider(this.prefs) {
    _loadGameState();
    initGame();
  }

  void _loadGameState() {
    _coins = prefs.getInt('coins') ?? 0;
    _streak = prefs.getInt('streak') ?? 0;
    _maxStreak = prefs.getInt('maxStreak') ?? 0;
    _language = prefs.getString('language') ?? 'English';
    _unlockedCategories = Set<String>.from(
      jsonDecode(prefs.getString('unlockedCategories') ?? '["Random"]')
    );
    notifyListeners();
  }

  void _saveGameState() {
    prefs.setInt('coins', _coins);
    prefs.setInt('streak', _streak);
    prefs.setInt('maxStreak', _maxStreak);
    prefs.setString('language', _language);
    prefs.setString('unlockedCategories', jsonEncode(_unlockedCategories.toList()));
  }

  Future<void> initGame({GameMode? mode, GameCategory? category}) async {
    if (_currentMode != GameMode.custom) {
      _currentMode = mode ?? _currentMode;
      _currentCategory = category ?? _currentCategory;
      _selectWord();
    }
    _lives = 6;
    _guessedLetters = [];
    notifyListeners();
  }
  
  void _selectWord() {
    if (_currentMode == GameMode.custom) {
      return;
    }
    final languageWordList = _languageWords[_language] ?? _languageWords['English']!;
    final words = languageWordList[_currentCategory] ?? languageWordList[GameCategory.random]!;
    _word = words[Random().nextInt(words.length)];
  }
  
  void makeGuess(String letter) {
    if (_guessedLetters.contains(letter.toLowerCase()) || isGameOver || isGameWon) return;
    
    _guessedLetters.add(letter.toLowerCase());
    if (!_word.toLowerCase().contains(letter.toLowerCase())) {
      _lives = (_lives - 1).clamp(0, 6);
    }
    
    if (isGameWon) {
      _handleWin();
    } else if (isGameOver) {
      _handleLoss();
    }
    
    notifyListeners();
  }
  
  void _handleWin() {
    _streak++;
    if (_streak > _maxStreak) {
      _maxStreak = _streak;
    }
    _coins += _streak * 10;
    _saveGameState();
  }
  
  void _handleLoss() {
    _streak = 0;
    _saveGameState();
  }

  void keepStreak() {
    _lives = 6;
    _saveGameState();
    notifyListeners();
  }

  void resetGame() {
    if (_currentMode != GameMode.custom) {
      _selectWord();
    }
    _lives = 6;
    _guessedLetters = [];
    notifyListeners();
  }

  void setLanguage(String language) {
    if (_languageWords.containsKey(language)) {
      _language = language;
      _saveGameState();
      if (_currentMode != GameMode.custom) {
        _selectWord();  // Select a new word in the new language
      }
      notifyListeners();
    }
  }

  void addCoins(int amount) {
    _coins += amount;
    _saveGameState();
    notifyListeners();
  }

  void removeLife() {
    if (_lives > 0) {
      _lives = (_lives - 1).clamp(0, 6);
      _saveGameState();
      notifyListeners();
    }
  }

  void addLife() {
    _lives = (_lives + 1).clamp(0, 6);
    _saveGameState();
    notifyListeners();
  }

  void incrementStreak() {
    _streak++;
    if (_streak > _maxStreak) {
      _maxStreak = _streak;
    }
    _saveGameState();
    notifyListeners();
  }

  void resetStreak() {
    _streak = 0;
    _saveGameState();
    notifyListeners();
  }

  void unlockCategory(String category) {
    _unlockedCategories.add(category);
    _saveGameState();
    notifyListeners();
  }

  bool isCategoryUnlocked(String category) {
    return _unlockedCategories.contains(category);
  }

  void setCustomWord(String word) {
    _customWord = word;
    _currentMode = GameMode.custom;
    _word = word;
    _lives = 6;
    _guessedLetters = [];
    notifyListeners();
  }
} 