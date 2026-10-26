import 'package:explore_bangladesh/models/travel_place.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TravelPlace Model Tests', () {
    test('all places list has valid data and unique IDs', () {
      expect(TravelPlace.all, isNotEmpty);

      final ids = TravelPlace.all.map((p) => p.id).toList();
      final uniqueIds = ids.toSet();

      expect(ids.length, equals(uniqueIds.length));
    });

    test('all places have positive estimated budget and non-empty fields', () {
      for (final place in TravelPlace.all) {
        expect(place.id, isNotEmpty);
        expect(place.name, isNotEmpty);
        expect(place.division, isNotEmpty);
        expect(place.category, isNotEmpty);
        expect(place.description, isNotEmpty);
        expect(place.imageUrl, isNotEmpty);
        expect(place.bestTime, isNotEmpty);
        expect(place.estimatedBudget, greaterThan(0));
      }
    });
  });
}
