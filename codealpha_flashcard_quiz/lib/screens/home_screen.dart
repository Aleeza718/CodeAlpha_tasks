import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';               
import '../services/hive_service.dart';
import '../utils/app_colors.dart';
import 'add_flashcard_screen.dart';
import 'quiz_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> hiveFlashcards = [];
  String selectedCategory = "All";
  String searchText = "";
  
  @override
  void initState() {
    super.initState();
    loadFlashcards();
  }

  void loadFlashcards() {
    setState(() {
      hiveFlashcards = HiveService.getFlashcards();
    });
  }

  List<Map<String, dynamic>> get filteredFlashcards {
  return hiveFlashcards.where((card) {
    final matchesCategory =
        selectedCategory == "All" ||
        card["category"] == selectedCategory;

    final matchesSearch =
    card["question"]
        .toString()
        .toLowerCase()
        .contains(searchText) ||
    card["answer"]
        .toString()
        .toLowerCase()
        .contains(searchText) ||
    card["category"]
        .toString()
        .toLowerCase()
        .contains(searchText);

return matchesCategory && matchesSearch;
    }).toList();
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
  backgroundColor: AppColors.background,
    floatingActionButtonAnimator:
        FloatingActionButtonAnimator.noAnimation,
   floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,

  floatingActionButton: FloatingActionButton.extended(
    backgroundColor: AppColors.primary,
    foregroundColor: Colors.white,
    icon: const Icon(Icons.add),
    label: const Text("New Card"),
   onPressed: () async {
  final result = await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => const AddFlashcardScreen(),
    ),
  );

  loadFlashcards();

  if (result != null) {
    Fluttertoast.showToast(
      msg: result.toString(),
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.black87,
      textColor: Colors.white,
      fontSize: 15,
    );
  }
},
),

      body: SafeArea(
  child: SingleChildScrollView(
    padding: const EdgeInsets.fromLTRB(
      22,
      20,
      22,
      100,
    ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Row(
                children: [

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [

                        Text(
                          "Good Evening 👋",
                          style: TextStyle(
                            color: Colors.white54,
fontSize: 15,
fontWeight: FontWeight.w500,
                          ),
                        ),

                        SizedBox(height: 8),

                        Text(
                          "Welcome Back",
                          style: TextStyle(
                            color: AppColors.textDark,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                      ],
                    ),
                  ),

                  Container(
                    width: 54,
                    height: 54,
                    decoration: BoxDecoration(
                      color: AppColors.card,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: const Icon(
                      Icons.person,
                      color: AppColors.primary,
                    ),
                  ),

                ],
              ),

              const SizedBox(height: 30),

              Container(
                height: 54,
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.border),
                ),
               child: TextField(
                style: const TextStyle(
    color: Colors.white,
  ),
  onChanged: (value) {
    setState(() {
      searchText = value.toLowerCase();
    });
  },
  decoration: const InputDecoration(
    border: InputBorder.none,
    hintText: "Search Flashcards",
    hintStyle: TextStyle(color: AppColors.grey),
    prefixIcon: Icon(
      Icons.search,
      color: AppColors.grey,
    ),
                    suffixIcon: Icon(
                      Icons.tune,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 28),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(28),
                ),
                child: Row(
                  children: [

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          const Text(
                            "Continue Learning",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                          ),

                          const SizedBox(height: 10),

                          Text(
                            "${hiveFlashcards.length} Flashcards",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                         const SizedBox(height: 16),

if (hiveFlashcards.isNotEmpty) ...[
  ClipRRect(
    borderRadius: BorderRadius.circular(20),
    child: const LinearProgressIndicator(
      value: 0,
      minHeight: 8,
      backgroundColor: Colors.white24,
      color: Colors.white,
    ),
  ),

  const SizedBox(height: 10),

  const Text(
    "Ready to Start",
    style: TextStyle(
      color: Colors.white70,
    ),
  ),

] else ...[
  const SizedBox(height: 10),

  const Text(
    "Add your first flashcard to begin learning",
    style: TextStyle(
      color: Colors.white70,
      fontSize: 15,
    ),
  ),
],
                        ],
                      ),
                      ),
 Container(
                      width: 75,
                      height: 75,
                      decoration: const BoxDecoration(
                        color: Colors.white24,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.menu_book_rounded,
                        color: Colors.white,
                        size: 38,
                       ),
 ),
                  ],
                ),
              ),


              const SizedBox(height: 22),

              const Text(
                "Categories",
                style: TextStyle(
                  color: AppColors.textDark,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 15),

             SizedBox(
  height: 125,
  child: ListView(
    scrollDirection: Axis.horizontal,
    children: [
      _categoryCard(Icons.apps, "All"),
      const SizedBox(width: 12),
      _categoryCard(Icons.computer, "Programming"),
      const SizedBox(width: 12),
      _categoryCard(Icons.calculate, "Math"),
      const SizedBox(width: 12),
      _categoryCard(Icons.science, "Science"),
      const SizedBox(width: 12),
      _categoryCard(Icons.language, "English"),
    ],
  ),
),
              const SizedBox(height: 22),

              const Text(
                "My Flashcards",
                style: TextStyle(
                  color: AppColors.textDark,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 15),
              SizedBox(
  width: double.infinity,
  child: ElevatedButton.icon(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
    ),
   onPressed: () {

  final quizCards = filteredFlashcards;

  if (selectedCategory != "All" && quizCards.isEmpty) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: AppColors.card,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        title: const Row(
          children: [
            Icon(
              Icons.info_outline_rounded,
              color: AppColors.primary,
            ),
            SizedBox(width: 8),
            Text(
              "No Flashcards",
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        content: Text(
          "No flashcards available in $selectedCategory category.\n\nAdd a flashcard first.",
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 15,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "OK",
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      );
    },
  );

  return;
} 

Navigator.push(
  context,
  MaterialPageRoute(
    builder: (_) => QuizScreen(
      flashcards: quizCards,
    ),
  ),
);
 },
    icon: const Icon(Icons.quiz),
    label: const Text(
      "Start Quiz",
      style: TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.bold,
      ),
    ),
  ),
),


const SizedBox(height: 15),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filteredFlashcards.length,
                itemBuilder: (context, index) {
                  final card = filteredFlashcards[index];

                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: AppColors.card,
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,

                      leading: CircleAvatar(
                        radius: 24,
                        backgroundColor:
                            AppColors.primary.withOpacity(.15),
                        child: const Icon(
                          Icons.auto_stories,
                          color: AppColors.primary,
                        ),
                      ),

                      title: Text(
                        card["question"],
                        style: const TextStyle(
                          color: AppColors.textDark,
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      ),

                      subtitle: Text(
                        card["answer"],
                        style: const TextStyle(
                          color: AppColors.textLight,
                        ),
                      ),
                                            trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [

                         IconButton(
                             tooltip: "Edit Flashcard",
  icon: const Icon(
    Icons.edit,
     color: AppColors.secondary,
  ),
 onPressed: () async {
  final result = await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => AddFlashcardScreen(
        flashcard: card,
        index: index,
      ),
    ),
  );

  loadFlashcards();

  if (result != null) {
  Fluttertoast.showToast(
    msg: result.toString(),
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    backgroundColor: Colors.black87,
    textColor: Colors.white,
    fontSize: 15,
  );
}
},
),
                         

                          IconButton(
  tooltip: "Delete Flashcard",
  icon: Icon(
    Icons.delete_outline,
    color: AppColors.secondary.withOpacity(.8),
  ),
  onPressed: () async {
  final bool? confirm = await showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: AppColors.card,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        title: const Row(
          children: [
            Icon(
              Icons.delete_outline,
              color: AppColors.primary,
            ),
            SizedBox(width: 8),
            Text(
              "Delete Flashcard",
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        content: const Text(
          "Are you sure you want to delete this flashcard?",
          style: TextStyle(
            color: Colors.white70,
            fontSize: 15,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text(
              "Cancel",
              style: TextStyle(color: Colors.white70),
            ),
          ),
          ElevatedButton(
  style: ElevatedButton.styleFrom(
    backgroundColor: AppColors.primary,
    foregroundColor: Colors.white,
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    padding: const EdgeInsets.symmetric(
      horizontal: 24,
      vertical: 12,
    ),
  ),
  onPressed: () => Navigator.pop(context, true),
  child: const Text(
    "Delete",
    style: TextStyle(
      fontWeight: FontWeight.bold,
    ),
  ),
),
        ],
      );
    },
  );

  if (confirm == true) {
    await HiveService.deleteFlashcard(index);
    loadFlashcards();
  }
},
),
                            

                        ],
                      ),
                    ),
                  );
                },
              ),

            ],
          ),
        ),
      ),
    );
  }

  Widget _categoryCard(IconData icon, String title) {
    final bool isSelected = selectedCategory == title;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCategory = title;
        });
      },
      child: Container(
  width: 110,
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary
              : AppColors.card,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? AppColors.secondary
                : AppColors.border,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(.15),
              blurRadius: 12,
            ),
          ],
        ),
        child: Column(
          children: [

            CircleAvatar(
              radius: 22,
              backgroundColor: isSelected
                  ? Colors.white
                  : AppColors.primary.withOpacity(.15),
              child: Icon(
                icon,
                color: AppColors.primary,
              ),
            ),

            const SizedBox(height: 10),

           Text(
 title,
textAlign: TextAlign.center,
maxLines: 1,
softWrap: false,
  overflow: TextOverflow.fade,
style: const TextStyle(
  color: Colors.white,
  fontWeight: FontWeight.w600,
  fontSize: 13,
),
),

          ],
        ),
      ),
    );
  }
}   