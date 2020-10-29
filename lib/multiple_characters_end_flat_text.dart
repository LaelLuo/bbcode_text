import 'package:extended_text_field/extended_text_field.dart';
import 'package:flutter/material.dart';

abstract class MultipleCharactersEndFlatText extends SpecialText {
  MultipleCharactersEndFlatText(String startFlag, String endFlag, TextStyle textStyle) : super(startFlag, endFlag, textStyle);

  String get content => contentWithEndFlag.substring(0, contentWithEndFlag.length - endFlag.length);

  String get contentWithEndFlag => getContent() + endFlag[endFlag.length - 1];

  String get source => startFlag + contentWithEndFlag;
}
