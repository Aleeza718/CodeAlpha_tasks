import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/quotes.dart';
import '../models/quote.dart';
import '../widgets/quote_card.dart';
import 'favorites_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {

  final Random random = Random();

  late Quote currentQuote;
  late AnimationController _controller;

  final List<Quote> favoriteQuotes = [];

  @override
  void initState() {
    super.initState();

    currentQuote = quotes[random.nextInt(quotes.length)];

    loadFavorites();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();

    final favoriteTexts =
        favoriteQuotes.map((q) => q.text).toList();

    await prefs.setStringList("favorites", favoriteTexts);
  }

  Future<void> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();

    final savedFavorites =
        prefs.getStringList("favorites") ?? [];

    favoriteQuotes.clear();

    for (final quote in quotes) {
      if (savedFavorites.contains(quote.text)) {
        quote.isFavorite = true;
        favoriteQuotes.add(quote);
      } else {
        quote.isFavorite = false;
      }
    }

    setState(() {});
  }

  void newQuote() {
    Quote newRandomQuote;

    do {
      newRandomQuote =
          quotes[random.nextInt(quotes.length)];
    } while (newRandomQuote.text == currentQuote.text);

    setState(() {
      currentQuote = newRandomQuote;
    });
  }

  void copyQuote() {
    Clipboard.setData(
      ClipboardData(
        text:
            "${currentQuote.text}\n\n— ${currentQuote.author}",
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        backgroundColor: const Color(0xff5B21B6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        content: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 10),
            Text("Quote copied successfully!"),
          ],
        ),
      ),
    );
  }
 void toggleFavorite() {
    setState(() {
      currentQuote.isFavorite = !currentQuote.isFavorite;

      if (currentQuote.isFavorite) {
        if (!favoriteQuotes.contains(currentQuote)) {
          favoriteQuotes.add(currentQuote);
        }
      } else {
        favoriteQuotes.remove(currentQuote);
      }
    });

    saveFavorites();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 1),
        backgroundColor: const Color(0xff5B21B6),
        content: Text(
          currentQuote.isFavorite
              ? "❤️ Added to Favorites"
              : "💔 Removed from Favorites",
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Quote Generator",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.favorite,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => FavoritesScreen(
                        favoriteQuotes: favoriteQuotes,
                      ),
                    ),
                  );
                },
              ),
              if (favoriteQuotes.isNotEmpty)
                Positioned(
                  right: 6,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      favoriteQuotes.length.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment(-1 + _controller.value, -1),
                end: Alignment(1, 1 - _controller.value),
                colors: const [
                  Color(0xff5B21B6),
                  Color(0xff2563EB),
                  Color(0xff7C3AED),
                  Color(0xff9333EA),
                ],
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  top: -120,
                  left: -80,
                  child: Container(
                    width: 280,
                    height: 280,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(.08),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Positioned(
                  bottom: -140,
                  right: -90,
                  child: Container(
                    width: 340,
                    height: 340,
                    decoration: BoxDecoration(
                      color: Colors.pink.withOpacity(.15),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                SafeArea(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 600),
                            transitionBuilder: (child, animation) {
                              return FadeTransition(
                                opacity: animation,
                                child: ScaleTransition(
                                  scale: Tween<double>(
                                    begin: .92,
                                    end: 1,
                                  ).animate(animation),
                                  child: child,
                                ),
                              );
                            },
                            child: QuoteCard(
                              key: ValueKey(currentQuote.text),
                              quote: currentQuote.text,
                              author: currentQuote.author,
                              isFavorite: currentQuote.isFavorite,
                              onFavoriteTap: toggleFavorite,
                            ),
                          ),
                          const SizedBox(height: 28),
                          Wrap(
                            alignment: WrapAlignment.center,
                            spacing: 16,
                            runSpacing: 14,
                            children: [
                              ElevatedButton.icon(
                                onPressed: copyQuote,
                                icon: const Icon(Icons.content_copy),
                                label: const Text("Copy"),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor:
                                      const Color(0xff5B21B6),
                                  minimumSize:
                                      Size(screenWidth * 0.38, 52),
                                  elevation: 8,
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(30),
                                  ),
                                ),
                              ),
                              ElevatedButton.icon(
                                onPressed: newQuote,
                                icon:
                                    const Icon(Icons.refresh_rounded),
                                label: const Text("New Quote"),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      const Color(0xff5B21B6),
                                  foregroundColor: Colors.white,
                                  minimumSize:
                                      Size(screenWidth * 0.38, 52),
                                  elevation: 8,
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(30),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}