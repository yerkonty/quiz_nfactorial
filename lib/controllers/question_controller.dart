import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:quizdigitalsat/models/question_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuestionController extends GetxController {
  final List<Question> _questions = [];
  List<Question> get questions => _questions;

  //Admin Dashboard
  final String _categoryKey = "category_title";
  final String _subtitleKey = "subtitle";
  TextEditingController categoryTitleController = TextEditingController();
  TextEditingController categorySubtitleController = TextEditingController();
  RxList<String> savedCategories = <String>[].obs;
  RxList<String> savedSubtitle = <String>[].obs;
  void savedQuestionCategotyToSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    savedCategories.add(categoryTitleController.text);
    savedSubtitle.add(categorySubtitleController.text);
    await prefs.setStringList(_categoryKey, savedCategories);
    await prefs.setStringList(_subtitleKey, savedSubtitle);

    categoryTitleController.clear();
    categorySubtitleController.clear();
    Get.snackbar("Saved", "Category has been saved successfully");
  }
}
