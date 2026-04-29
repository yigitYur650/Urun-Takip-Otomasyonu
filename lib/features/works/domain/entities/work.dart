class Work {
  final String id;
  final String title;
  final double price;
  final bool isPaid;
  final DateTime createdAt;

  const Work({
    required this.id,
    required this.title,
    required this.price,
    required this.isPaid,
    required this.createdAt,
  });
}
