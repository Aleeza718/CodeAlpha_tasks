class Quote {
  final String text;
  final String author;
  bool isFavorite;

  Quote({
    required this.text,
    required this.author,
    this.isFavorite = false,
  });
}