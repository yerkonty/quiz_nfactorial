import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:quizdigitalsat/models/question_model.dart';
import 'package:quizdigitalsat/views/score_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuestionController extends GetxController {
  //User Interface Codes
  late PageController _pageController;
  PageController get pageController => _pageController;
  bool _isAnswered = false;
  bool get isAnswered => _isAnswered;

  int _correctAns = 0;
  int get correctAns => _correctAns;

  int _selectedAns = 0;
  int get selectedAnd => _selectedAns;

  int _numOfCorrectAns = 0;
  int get numOfCorrectAns => _numOfCorrectAns;

  final RxInt _questionNumber = 1.obs;
  RxInt get questionNumber => _questionNumber;

  //Admin Screen
  List<Question> _questions = [];
  List<Question> get questions => _questions;

  final TextEditingController questionControllerText = TextEditingController();
  final List<TextEditingController> optionControllers = List.generate(
    4,
    (index) => TextEditingController(),
  );
  final TextEditingController correctAnswerController = TextEditingController();
  final TextEditingController quizCategory = TextEditingController();

  Future<void> saveQuestionToSharedPreferences(Question question) async {
    final prefs = await SharedPreferences.getInstance();
    final questions = prefs.getStringList("questions") ?? [];

    // Конвертируем вопрос в JSON и добавляем в список
    questions.add(jsonEncode(question.toJson()));

    // Сохраняем обновленный список обратно в SharedPreferences
    await prefs.setStringList("questions", questions);
  }

  //Admin Dashboard
  final String _categoryKey = "category_title";
  final String _subtitleKey = "subtitle";

  TextEditingController categoryTitleController = TextEditingController();
  TextEditingController categorySubtitleController = TextEditingController();

  RxList<String> savedCategories = <String>[].obs;
  RxList<String> savedSubtitle = <String>[].obs;

  void savedQuestionCategoryToSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    savedCategories.add(categoryTitleController.text);
    savedSubtitle.add(categorySubtitleController.text);
    await prefs.setStringList(_categoryKey, savedCategories);
    await prefs.setStringList(_subtitleKey, savedSubtitle);

    categorySubtitleController.clear();
    categoryTitleController.clear();

    Get.snackbar("Saved", "Category has been saved successfully");
  }

  void loadQuestionCategoryFromSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final categories = prefs.getStringList(_categoryKey) ?? [];
    final subtitles = prefs.getStringList(_subtitleKey) ?? [];
    savedCategories.assignAll(categories);
    savedSubtitle.assignAll(subtitles);
    update();
  }

  void loadQuestionsFromSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final questionJson = prefs.getStringList("questions") ?? [];

    _questions =
        questionJson
            .map((jsonString) => Question.fromJson(jsonDecode(jsonString)))
            .toList();
    update();
  }

  List<Question> getQuestionsByCategory(String category) {
    return _questions
        .where((question) => question.category == category)
        .toList();
  }

  void checkAns(Question question, int selectedIndex) {
    _isAnswered = true;
    _correctAns = question.answer;
    _selectedAns = selectedIndex;

    if (_correctAns == _selectedAns) _numOfCorrectAns++;

    nextQuestion();
  }

  void nextQuestion() async {
    if (_questionNumber.value != _questions.length) {
      _isAnswered = false;

      _pageController.nextPage(
        duration: const Duration(milliseconds: 250),
        curve: Curves.ease,
      );
    } else {
      Get.to(const ScorePage());
    }
  }

  @override
  void onInit() {
    loadQuestionsFromSharedPreferences();
    loadQuestionCategoryFromSharedPreferences();
    _pageController = PageController();
    super.onInit();
  }
}
