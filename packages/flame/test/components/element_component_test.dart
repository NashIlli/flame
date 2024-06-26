import 'package:flame/components.dart';
import 'package:flame/text.dart';
import 'package:test/test.dart';

void main() {
  group('ElementComponent', () {
    test('document size can be specified via the size parameter', () {
      final c = TextElementComponent.fromDocument(
        document: DocumentRoot([]),
        size: Vector2(100, 200),
      );
      expect(c.documentSize, equals(Vector2(100, 200)));
      expect(c.size, equals(Vector2.zero()));
    });

    test('document size can be specified via the style', () {
      final c = TextElementComponent.fromDocument(
        document: DocumentRoot([]),
        style: DocumentStyle(width: 100, height: 200),
      );
      expect(c.documentSize, equals(Vector2(100, 200)));
      expect(c.size, equals(Vector2.zero()));
    });

    test('document size can be super-specified if matching', () {
      final c = TextElementComponent.fromDocument(
        document: DocumentRoot([]),
        style: DocumentStyle(width: 100, height: 200),
        size: Vector2(100, 200),
      );
      expect(c.documentSize, equals(Vector2(100, 200)));
      expect(c.size, equals(Vector2.zero()));
    });

    test('document size must be specified', () {
      expect(
        () {
          TextElementComponent.fromDocument(
            document: DocumentRoot([]),
            style: DocumentStyle(),
          );
        },
        throwsA(
          predicate((e) {
            return e is ArgumentError &&
                e.message == 'Either style.width or size.x must be provided.';
          }),
        ),
      );
    });

    test('size cannot be over-specified if mismatched', () {
      expect(
        () {
          TextElementComponent.fromDocument(
            document: DocumentRoot([]),
            style: DocumentStyle(width: 100, height: 200),
            size: Vector2(100, 300),
          );
        },
        throwsA(
          predicate((e) {
            return e is ArgumentError &&
                e.message ==
                    'style.height and size.y, if both provided, must match.';
          }),
        ),
      );
    });

    test('size is computed from the element bounding box', () {
      final c = TextElementComponent.fromDocument(
        document: DocumentRoot([
          ParagraphNode.simple('line 1'),
          ParagraphNode.simple('line 2'),
        ]),
        size: Vector2(800, 160), // oversized
      );
      expect(c.documentSize, equals(Vector2(800, 160)));
      expect(c.size, equals(Vector2(96, 44)));
    });
  });
}
