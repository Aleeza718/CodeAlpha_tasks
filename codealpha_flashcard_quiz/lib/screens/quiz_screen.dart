import 'package:flutter/material.dart';

import '../services/hive_service.dart';
import '../utils/app_colors.dart';

class QuizScreen extends StatefulWidget {

  final List<Map<String, dynamic>> flashcards;

  const QuizScreen({
    super.key,
    required this.flashcards,
  });

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {

  List<Map<String, dynamic>> flashcards = [];

  int currentIndex = 0;
  bool showAnswer = false;

  @override
  void initState() {
    super.initState();

    flashcards = widget.flashcards;

if (flashcards.isEmpty) {
  flashcards = [
    {
      "question": "What is Flutter?",
      "answer": "Flutter is an open-source UI toolkit by Google.",
    },
    {
      "question": "What is Dart?",
      "answer": "Dart is the programming language used by Flutter.",
    },
    {
      "question": "What is Widget?",
      "answer": "Widgets are the building blocks of Flutter UI.",
    },
    {
      "question": "What is API?",
      "answer": "API stands for Application Programming Interface.",
    },
    {
      "question": "What is OOP?",
      "answer": "Object-Oriented Programming.",
    },
    {
      "question": "What is HTML?",
      "answer": "HTML is used to create web pages.",
    },
    {
      "question": "What is CSS?",
      "answer": "CSS is used to style web pages.",
    },
  ];
}
  }
  @override
  Widget build(BuildContext context) {
        return Scaffold(
      backgroundColor: AppColors.background,

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 22,
            vertical: 20,
          ),
          child: Column(
            children: [

              Row(
                children: [

                  InkWell(
                    onTap: () => Navigator.pop(context),
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: AppColors.card,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppColors.border,
                        ),
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),

                  const SizedBox(width: 18),

                  const Expanded(
                    child: Text(
                      "Flash Quiz",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                  ),

                ],
              ),

              const SizedBox(height: 30),

              Text(
                "Card ${currentIndex + 1} of ${flashcards.length}",
                style: const TextStyle(
                  color: AppColors.textLight,
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 18),

              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: LinearProgressIndicator(
                  value: (currentIndex + 1) / flashcards.length,
                  minHeight: 8,
                  backgroundColor: AppColors.border,
                  valueColor: const AlwaysStoppedAnimation(
                    AppColors.secondary,
                  ),
                ),
              ),

              const SizedBox(height: 35),

              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      showAnswer = !showAnswer;
                    });
                  },

                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    width: double.infinity,

                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(34),

                      boxShadow: [
                        BoxShadow(
                          color: AppColors.glow.withOpacity(.35),
                          blurRadius: 25,
                          offset: const Offset(0, 12),
                        ),
                      ],
                    ),

                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(28),

                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 400),

                          child: Text(
                            showAnswer
                                ? flashcards[currentIndex]["answer"].toString()
                                : flashcards[currentIndex]["question"].toString(),
                            key: ValueKey(showAnswer),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
                            const SizedBox(height: 25),

              SizedBox(
                width: double.infinity,
                height: 58,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.secondary,
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      showAnswer = !showAnswer;
                    });
                  },
                  child: Text(
                    showAnswer
                        ? "Hide Answer"
                        : "Show Answer",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 22),

              Row(
                children: [

                  Expanded(
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        backgroundColor: AppColors.card,
                        side: const BorderSide(
                          color: AppColors.border,
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      onPressed: currentIndex == 0
                          ? null
                          : () {
                              setState(() {
                                currentIndex--;
                                showAnswer = false;
                              });
                            },
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                      label: const Text(
                        "Previous",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 16),

                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        elevation: 8,
                        padding: const EdgeInsets.symmetric(
                          vertical: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      onPressed: currentIndex == flashcards.length - 1
                          ? null
                          : () {
                              setState(() {
                                currentIndex++;
                                showAnswer = false;
                              });
                            },
                      icon: const Icon(Icons.arrow_forward),
                      label: const Text("Next"),
                    ),
                  ),

                ],
              ),
                          ],
          ),
        ),
      ),
    );
  }
}