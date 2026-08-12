import 'package:hive_flutter/hive_flutter.dart';

class HiveService {
  static const String boxName = "flashcards";

  /// Initialize Hive
  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox(boxName);
  }

  /// Get Box
  static Box get box => Hive.box(boxName);

  /// Add Flashcard
  static Future<void> addFlashcard(Map<String, dynamic> flashcard) async {
    await box.add(flashcard);
  }

  /// Get All Flashcards
  static List<Map<String, dynamic>> getFlashcards() {
    return box.values
        .map((e) => Map<String, dynamic>.from(e))
        .toList();
  }

  /// Update Flashcard
  static Future<void> updateFlashcard(
      int index, Map<String, dynamic> flashcard) async {
    await box.putAt(index, flashcard);
  }

  /// Delete Flashcard
  static Future<void> deleteFlashcard(int index) async {
    await box.deleteAt(index);
  }

  /// Clear All Flashcards
  static Future<void> clearAll() async {
    await box.clear();
  }
}