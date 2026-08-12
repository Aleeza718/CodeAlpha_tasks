import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class QuoteCard extends StatelessWidget {
  final String quote;
  final String author;
  final bool isFavorite;
  final VoidCallback onFavoriteTap;

  const QuoteCard({
    super.key,
    required this.quote,
    required this.author,
    required this.isFavorite,
    required this.onFavoriteTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: screenWidth * 0.85,
        ),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.06,
            vertical: 28,
          ),
          decoration: BoxDecoration(
            color: const Color(0xffF8F7FF),
            borderRadius: BorderRadius.circular(22),

            border: Border.all(
              color: const Color(0xFF7C4DFF),
              width: 1.5,
            ),

            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.12),
                blurRadius: 18,
                spreadRadius: 1,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  onPressed: onFavoriteTap,
                  icon: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: Icon(
                      isFavorite
                          ? Icons.favorite
                          : Icons.favorite_border,
                      key: ValueKey(isFavorite),
                      color: isFavorite
                          ? Colors.red
                          : Colors.grey.shade500,
                      size: 26,
                    ),
                  ),
                ),
              ),

              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '“ ',
                      style: GoogleFonts.poppins(
                        fontSize: screenWidth < 400 ? 30 : 38,
                        color: const Color(0xff6C3EF4),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: quote,
                      style: GoogleFonts.poppins(
                        fontSize: screenWidth < 400 ? 21 : 26,
                        height: 1.5,
                        color: Colors.black87,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextSpan(
                      text: ' ”',
                      style: GoogleFonts.poppins(
                        fontSize: screenWidth < 400 ? 30 : 38,
                        color: const Color(0xff6C3EF4),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              Container(
                width: 70,
                height: 3,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF8B5CF6),
                      Color(0xFF6C3EF4),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),

              const SizedBox(height: 18),

              Text(
                "— $author",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.grey.shade700,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}