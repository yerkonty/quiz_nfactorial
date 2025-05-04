import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quizdigitalsat/controllers/question_controller.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final QuestionController _questionController = Get.put(QuestionController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Admin Dashboard")),
      body: ListView.builder(
        itemCount: 100,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              leading: Icon(Icons.question_answer),
              title: const Text("Title"),
              subtitle: const Text("Subtitle"),
              trailing: IconButton(
                onPressed: () {},
                icon: const Icon(Icons.delete),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showDialogBox,
        child: const Icon(Icons.add),
      ),
    );
  }

  _showDialogBox() {
    Get.defaultDialog(
      contentPadding: EdgeInsets.symmetric(horizontal: 25, vertical: 25),
      title: "Add Quiz",
      content: Column(
        children: [
          TextFormField(
            decoration: InputDecoration(hintText: "Enter the Category name"),
          ),
          TextFormField(
            decoration: InputDecoration(
              hintText: "Enter the Category subtitle",
            ),
          ),
        ],
      ),
      textConfirm: "Create",
      textCancel: "Cancel",
      onConfirm: () {
        _questionController.savedQuestionCategotyToSharedPreferences();
        Get.back();
      },
    );
  }
}
