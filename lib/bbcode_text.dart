library bbcode_text;

import 'package:bbcode_text/multiple_characters_end_flat_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class BBCodeText extends MultipleCharactersEndFlatText {
  final int index;
  final TextStyle Function(TextStyle textStyle) styleBuilder;
  final InlineSpan Function(
    String tagSource,
    String content,
    String source,
    int start,
    TextStyle textStyle,
  ) spanBuilder;

  BBCodeText(
    String tagFlag,
    this.index,
    TextStyle textStyle, {
    this.styleBuilder,
    @required this.spanBuilder,
  }) : super('[$tagFlag', '[/$tagFlag]', textStyle);

  @override
  InlineSpan finishText() {
    final style = styleBuilder?.call(this.textStyle) ?? textStyle;
    if (spanBuilder == null) return TextSpan(text: source, style: style);
    return spanBuilder(
      RegExp('\\[(.*)\\]').firstMatch(source)[1],
      content,
      source,
      index - startFlag.length + 1,
      style,
    );
  }


  @override
  String get content {
    return RegExp('\\](.*)\\[').firstMatch(source)[1];
  }
}

class BBCodeTextBuilder {
  Map<String, BBCodeTextSpanBuilderData> supportMap = {};

  void add(String tag, BBCodeTextSpanBuilderData data) {
    supportMap[tag] = data;
  }

  BBCodeText tryCreate(String textStack, int index, TextStyle textStyle) {
    final tagFlag = textStack.split('[').last;
    if (supportMap.containsKey(tagFlag)) {
      return BBCodeText(
        tagFlag,
        index,
        textStyle,
        styleBuilder: supportMap[tagFlag].styleBuilder,
        spanBuilder: supportMap[tagFlag].spanBuilder,
      );
    }
    return null;
  }
}

class BBCodeTextSpanBuilderData {
  final TextStyle Function(TextStyle textStyle) styleBuilder;
  final InlineSpan Function(
    String tagSource,
    String content,
    String source,
    int start,
    TextStyle textStyle,
  ) spanBuilder;

  BBCodeTextSpanBuilderData({this.styleBuilder, @required this.spanBuilder});
}
