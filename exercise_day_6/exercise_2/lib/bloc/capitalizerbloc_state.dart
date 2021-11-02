part of 'capitalizerbloc_bloc.dart';

@immutable
abstract class CapitalizerblocState {}

class CapitalizerblocInitial extends CapitalizerblocState {}

class StringToCapitalize extends CapitalizerblocState {
  String _textData = "";

  StringToCapitalize(String incomingStr) {
    _capitalize(incomingStr);
  }

  void _capitalize(String incomingStr) {
    _textData = incomingStr.toUpperCase();
  }

  String get textData => _textData;
}
