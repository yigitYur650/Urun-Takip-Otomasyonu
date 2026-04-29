import 'package:craft_tracker/features/works/data/models/work_model.dart';
import 'package:craft_tracker/features/works/domain/entities/work.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final tWorkModel = WorkModel(
    id: 'test-id',
    title: 'Test Work',
    price: 99.9,
    isPaid: true,
    createdAt: DateTime.parse('2024-01-01T00:00:00.000Z'),
  );

  test('should be a subclass of Work entity', () {
    expect(tWorkModel, isA<Work>());
  });

  group('fromMap', () {
    test('should return a valid model from Map', () {
      final map = {
        'id': 'test-id',
        'title': 'Test Work',
        'price': 99.9,
        'is_paid': 1,
        'created_at': '2024-01-01T00:00:00.000Z',
      };

      final result = WorkModel.fromMap(map);

      expect(result.id, tWorkModel.id);
      expect(result.title, tWorkModel.title);
      expect(result.price, tWorkModel.price);
      expect(result.isPaid, tWorkModel.isPaid);
      expect(result.createdAt, tWorkModel.createdAt);
    });
  });

  group('toMap', () {
    test('should return a valid Map containing proper data', () {
      final expectedMap = {
        'id': 'test-id',
        'title': 'Test Work',
        'price': 99.9,
        'is_paid': 1,
        'created_at': '2024-01-01T00:00:00.000Z',
      };

      final result = tWorkModel.toMap();

      expect(result, expectedMap);
    });
  });
}
