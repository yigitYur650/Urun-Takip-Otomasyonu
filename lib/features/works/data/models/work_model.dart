import '../../domain/entities/work.dart';

class WorkModel extends Work {
  const WorkModel({
    required super.id,
    required super.title,
    required super.price,
    required super.isPaid,
    required super.createdAt,
  });

  factory WorkModel.fromMap(Map<String, dynamic> map) {
    return WorkModel(
      id: map['id'] as String,
      title: map['title'] as String,
      price: (map['price'] as num).toDouble(),
      isPaid: (map['is_paid'] as int) == 1,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'is_paid': isPaid ? 1 : 0,
      'created_at': createdAt.toIso8601String(),
    };
  }
  
  factory WorkModel.fromEntity(Work work) {
    return WorkModel(
      id: work.id,
      title: work.title,
      price: work.price,
      isPaid: work.isPaid,
      createdAt: work.createdAt,
    );
  }
}
