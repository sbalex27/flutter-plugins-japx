import 'package:japx/japx.dart';
import 'package:test/test.dart';

void main() {
  for (final includeList in <String?>[null, '', 'products']) {
    group('Relationship meta with includeList=$includeList', () {
      Map<String, dynamic> decode(Map<String, dynamic> resource,
          {List<Map<String, dynamic>>? included}) {
        return Japx.decode({
          'data': resource,
          if (included != null) 'included': included,
        }, includeList: includeList)['data'] as Map<String, dynamic>;
      }

      test('extracts meta without linkage and preserves value types', () {
        final result = decode({
          'type': 'categories',
          'id': '23',
          'attributes': <String, dynamic>{'name': 'Herramientas manuales'},
          'relationships': {
            'products': {
              'meta': {
                'count': 23,
                'available': true,
                'missing': null,
                'tags': ['tools'],
                'details': {'total': 23},
                'total_count': 23,
              },
            },
            'suppliers': {
              'meta': {'count': 2},
            },
          },
        });
        expect(result, {
          'type': 'categories',
          'id': '23',
          'name': 'Herramientas manuales',
          'productsCount': 23,
          'productsAvailable': true,
          'productsMissing': null,
          'productsTags': ['tools'],
          'productsDetails': {'total': 23},
          'productsTotal_count': 23,
          'suppliersCount': 2,
        });
      });

      for (final linkage in [null, <dynamic>[]]) {
        test('extracts meta with linkage=$linkage', () {
          final result = decode({
            'type': 'categories',
            'id': '23',
            'relationships': {
              'products': {
                'data': linkage,
                'meta': {'count': 0},
              },
            },
          });
          expect(result['productsCount'], 0);
        });
      }

      for (final existing in [null, 99]) {
        test('preserves existing attribute=$existing', () {
          final result = decode({
            'type': 'categories',
            'id': '23',
            'attributes': <String, dynamic>{'productsCount': existing},
            'relationships': {
              'products': {
                'meta': {'count': 23},
              },
            },
          });
          expect(result.containsKey('productsCount'), isTrue);
          expect(result['productsCount'], existing);
        });
      }

      for (final meta in [null, 'invalid', 42, <dynamic>[]]) {
        test('ignores non-object meta=$meta', () {
          final result = decode({
            'type': 'categories',
            'id': '23',
            'relationships': {
              'products': {'meta': meta},
              'suppliers': <String, dynamic>{},
            },
          });
          expect(result, {'type': 'categories', 'id': '23'});
        });
      }

      if (includeList != '') {
        test('extracts nested resource meta alongside resolved linkage', () {
          final result = decode({
            'type': 'categories',
            'id': '23',
            'relationships': {
              'products': {
                'data': [
                  {'type': 'products', 'id': '1'},
                ],
                'meta': {'count': 1},
              },
            },
          }, included: [
            {
              'type': 'products',
              'id': '1',
              'relationships': {
                'reviews': {
                  'meta': {'count': 5},
                },
              },
            },
          ]);
          expect(result['productsCount'], 1);
          expect(result['products'], [
            {'type': 'products', 'id': '1', 'reviewsCount': 5},
          ]);
        });
      }
    });
  }
}
