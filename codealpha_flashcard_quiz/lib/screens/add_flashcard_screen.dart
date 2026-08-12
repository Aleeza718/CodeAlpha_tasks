import 'package:flutter/material.dart';

import '../services/hive_service.dart';
import '../utils/app_colors.dart';

class AddFlashcardScreen extends StatefulWidget {
  final Map<String, dynamic>? flashcard;
  final int? index;

  const AddFlashcardScreen({
    super.key,
    this.flashcard,
    this.index,
  });

  @override
  State<AddFlashcardScreen> createState() => _AddFlashcardScreenState();
}

class _AddFlashcardScreenState extends State<AddFlashcardScreen> {
  final TextEditingController questionController = TextEditingController();
  final TextEditingController answerController = TextEditingController();

  String selectedCategory = "Programming";

  final List<String> categories = [
    "Programming",
    "Math",
    "Science",
    "English",
  ];

  @override
  void initState() {
    super.initState();

    if (widget.flashcard != null) {
      questionController.text = widget.flashcard!["question"];
      answerController.text = widget.flashcard!["answer"];
      selectedCategory = widget.flashcard!["category"];
    }
  }

  @override
  void dispose() {
    questionController.dispose();
    answerController.dispose();
    super.dispose();
  }

  Future<void> saveFlashcard() async {
    if (questionController.text.trim().isEmpty ||
        answerController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          content: const Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.white),
              SizedBox(width: 10),
              Text(
                "Please fill all fields",
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      );
      return;
    }

    if (widget.flashcard == null) {
      await HiveService.addFlashcard({
        "question": questionController.text.trim(),
        "answer": answerController.text.trim(),
        "category": selectedCategory,
      });

      Navigator.pop(context, "Flashcard Added Successfully");
      return;
    } else {
      await HiveService.updateFlashcard(
        widget.index!,
        {
          "question": questionController.text.trim(),
          "answer": answerController.text.trim(),
          "category": selectedCategory,
        },
      );

      Navigator.pop(context, "Flashcard Updated Successfully");
      return;
    }
  }

  InputDecoration inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(
        color: AppColors.textLight,
      ),
      filled: true,
      fillColor: AppColors.card,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(
          color: AppColors.border,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(
          color: AppColors.secondary,
          width: 2,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          widget.flashcard == null
              ? "Add Flashcard"
              : "Edit Flashcard",
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.secondary.withOpacity(.35),
                    blurRadius: 25,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.flashcard == null
                              ? "Create New"
                              : "Update",
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 15,
                          ),
                        ),

                        const SizedBox(height: 8),

                        Text(
                          widget.flashcard == null
                              ? "Flashcard"
                              : "Flashcard",
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                          ),
                        ),

                        const SizedBox(height: 10),

                        const Text(
                          "Save your own notes and revise anytime.",
                          style: TextStyle(
                            color: Colors.white70,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Container(
                    width: 75,
                    height: 75,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.note_add_rounded,
                      color: Colors.white,
                      size: 38,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),
                        TextField(
              controller: questionController,
              style: const TextStyle(color: Colors.white),
              decoration: inputDecoration("Question"),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: answerController,
              maxLines: 4,
              style: const TextStyle(color: Colors.white),
              decoration: inputDecoration("Answer"),
            ),

            const SizedBox(height: 20),

            DropdownButtonFormField<String>(
              value: selectedCategory,
              dropdownColor: AppColors.card,
              style: const TextStyle(color: Colors.white),
              decoration: inputDecoration("Category"),
              items: categories.map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedCategory = value!;
                });
              },
            ),

            const SizedBox(height: 35),

            SizedBox(
              width: double.infinity,
              height: 58,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                onPressed: saveFlashcard,
                child: Text(
                  widget.flashcard == null
                      ? "Save Flashcard"
                      : "Update Flashcard",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}