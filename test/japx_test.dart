import 'package:japx/src/parser.dart';
import 'package:test/test.dart';

import 'test_data.dart';

void main() {
  test(
      'Basic decoding',
      () async => compare(
          Japx.decode(await decodingSample1()), await resultDecoding1()));
  test(
      'Relationship decoding',
      () async => compare(
          Japx.decode(await decodingSample2()), await resultDecoding2()));
  test(
      'Additional info decoding',
      () async => compare(
          Japx.decode(await decodingSample3()), await resultDecoding3()));
  test(
      'Recursive decoding',
      () async => compare(
          Japx.decode(await decodingSample4(),
              includeList: 'author.article.author'),
          await resultDecoding4()));
  test(
      'Relationship no include decoding',
      () async => compare(
          Japx.decode(await decodingSample5(),
              includeList: 'author.article.author'),
          await resultDecoding5()));
  test(
      'Advanced decoding',
      () async => compare(
          Japx.decode(await decodingSample6(),
              includeList: 'author,comments.author'),
          await resultDecoding6()));
  test(
      'Empty relationship decoding',
      () async => compare(
          Japx.decode(await decodingSample7(),
              includeList: 'author.categories,author.article.author'),
          await resultDecoding7()));

  test('Nested relationship not included decoding', () async {
    var decoded = Japx.decode(await decodingSample8());
    var expected = await resultDecoding8();
    expect(decoded['data']['author']['categories'], isNotEmpty);
    expect(expected['data']['author']['categories'], isNotEmpty);
  });

  test(
      'Basic encoding',
      () async => compare(
          Japx.encode(await encodingSample1()), await resultEncoding1()));
  test(
      'Extra params encoding',
      () async => compare(
          Japx.encode(await encodingSample2()), await resultEncoding2()));
  test(
      'Meta encoding',
      () async => compare(
          Japx.encode(await encodingSample3()), await resultEncoding3()));
  test(
      'Recursive encoding',
      () async => compare(
          Japx.encode(await encodingSample4()), await resultEncoding4()));
  test(
      'Simple encoding',
      () async => compare(
          Japx.encode(await encodingSample5()), await resultEncoding5()));
  test(
      'List encoding',
      () async => compare(
          Japx.encode(await encodingSample6()), await resultEncoding6()));

  test(
      'Resource identifiers',
      () async => compare(
          Japx.encode(await encodingSample7()), await resultEncoding7()));

  test(
      'Nullable relationships',
      () async => compare(
          Japx.encode(await encodingSample8()), await resultEncoding8()));

  test('Null body',
      () async => expect(Japx.encode(null), await resultEncoding9()));

  test(
      'Null field relationship',
      () async => expect(
          Japx.encode(await encodingSample10()), await resultEncoding10()));
}

void compare(Map<String, dynamic> sample, Map<String, dynamic> result) =>
    expect(sample, result);
