import 'package:bbcode_text/bbcode_text.dart';
import 'package:extended_text_field/extended_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('MultipleCharactersEndFlatText Test', () {
    final source = ' 200x50]https://humulos.com/digimon/images/art/dm20/omega_as.jpg[/img';
    // ignore: missing_required_param
    final text = BBCodeText('img', 4, TextStyle())..appendContent(source);
    final text2 = BBCodeText(
      'img',
      4,
      TextStyle(),
      spanBuilder: (Map<String, String> args, String tagSource, String content, String source, int start, TextStyle textStyle) {
        return SpecialTextSpan(
          text: content,
          actualText: source,
          style: textStyle,
          start: start,
        );
      },
    )..appendContent(source);
    expect(text.source, '[img 200x50]https://humulos.com/digimon/images/art/dm20/omega_as.jpg[/img]');
    expect(text.content, 'https://humulos.com/digimon/images/art/dm20/omega_as.jpg');
    expect(text.finishText().runtimeType.toString(), 'TextSpan');
    final inlineSpan = text2.finishText();
    expect(inlineSpan.runtimeType.toString(), 'SpecialTextSpan');
    debugPrint(inlineSpan.toPlainText());
  });

  test('use demo', () {
    final builder = BBCodeTextSpanBuilder();
    final textSpan = builder.build('asdsad[img 200x50]https://humulos.com/digimon/images/art/dm20/omega_as.jpg[/img]');
    debugPrint(textSpan.toStringDeep());
  });
}

class BBCodeTextSpanBuilder extends SpecialTextSpanBuilder {
  final BBCodeTextBuilder _bbCodeTextBuilder;

  BBCodeTextSpanBuilder() : _bbCodeTextBuilder = BBCodeTextBuilder() {
    _bbCodeTextBuilder.add(
      'img',
      BBCodeTextSpanBuilderData(
        styleBuilder: (old) => old?.copyWith(),
        spanBuilder: (Map<String, String> args, String tagSource, String content, String source, int start, TextStyle textStyle) {
          return SpecialTextSpan(
            text: content,
            actualText: source,
            style: textStyle,
            start: start,
          );
        },
      ),
    );
  }

  @override
  SpecialText createSpecialText(String flag, {TextStyle textStyle, onTap, int index}) {
    if (flag == null || flag.isEmpty) return null;
    return _bbCodeTextBuilder.tryCreate(flag, index, textStyle);
  }
}
