import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:quizdigitalsat/controllers/question_controller.dart';
import 'package:quizdigitalsat/views/quiz_screen.dart';

class QuizCategoryScreen extends StatefulWidget {
  const QuizCategoryScreen({super.key});

  @override
  State<QuizCategoryScreen> createState() => _QuizCategoryScreenState();
}

class _QuizCategoryScreenState extends State<QuizCategoryScreen> {
  final QuestionController _questionController = Get.put(QuestionController());

  @override
  void initState() {
    super.initState();
    _questionController.loadQuestionCategoryFromSharedPreferences();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SvgPicture.asset("assets/bg.svg"),
          Obx(
            () => GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemCount: _questionController.savedCategories.length,
              itemBuilder: (context, index) {
                return Card(
                  child: GestureDetector(
                    onTap: () {
                      Get.to(
                        QuizScreen(
                          category: _questionController.savedCategories[index],
                        ),
                      );
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.question_answer),
                        Text(_questionController.savedCategories[index]),
                        Text(_questionController.savedSubtitle[index]),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
