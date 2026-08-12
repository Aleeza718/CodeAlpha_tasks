import 'package:flutter/material.dart';

import '../models/quote.dart';

class FavoritesScreen extends StatelessWidget {
  final List<Quote> favoriteQuotes;

  const FavoritesScreen({
    super.key,
    required this.favoriteQuotes,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Favorite Quotes"),
        centerTitle: true,
        backgroundColor: const Color(0xff5B21B6),
        foregroundColor: Colors.white,
      ),
      body: favoriteQuotes.isEmpty
          ? const Center(
              child: Text(
                "❤️ No favorite quotes yet!",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: favoriteQuotes.length,
              itemBuilder: (context, index) {
                final quote = favoriteQuotes[index];

                return Card(
                  elevation: 5,
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        const Icon(
                          Icons.favorite,
                          color: Colors.red,
                        ),

                        const SizedBox(height: 12),

                        Text(
                          "“${quote.text}”",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            height: 1.5,
                          ),
                        ),

                        const SizedBox(height: 12),

                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            "— ${quote.author}",
                            style: TextStyle(
                              color: Colors.grey.shade700,
                              fontStyle: FontStyle.italic,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}