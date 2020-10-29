library bbcode_text;

import 'package:bbcode_text/multiple_characters_end_flat_text.dart';
import 'package:bbob_dart/bbob_dart.dart' as bb;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class BBCodeText extends MultipleCharactersEndFlatText {
  final int index;
  final TextStyle Function(TextStyle textStyle) styleBuilder;
  final InlineSpan Function(
    Map<String, String> args,
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
    final _element = element;
    return spanBuilder(
      _element.attributes,
      _element.tag,
      content,
      source,
      index - startFlag.length + 1,
      style,
    );
  }

  bb.Element get element => bb.parse(source).first;

  @override
  String get content {
    final _element = element;
    if (_element.textContent.isNotEmpty) return _element.textContent;
    return contentWithEndFlag.substring(
      _element.tag.length + 2 - startFlag.length,
      contentWithEndFlag.length - endFlag.length,
    );
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
    Map<String, String> args,
    String tagSource,
    String content,
    String source,
    int start,
    TextStyle textStyle,
  ) spanBuilder;

  BBCodeTextSpanBuilderData({this.styleBuilder, @required this.spanBuilder});
}
