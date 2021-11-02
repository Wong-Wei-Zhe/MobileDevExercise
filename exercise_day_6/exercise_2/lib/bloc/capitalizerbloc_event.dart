part of 'capitalizerbloc_bloc.dart';

enum EventStatus { CAPITALIZE }

@immutable
abstract class CapitalizerblocEvent {}

class Capitalize extends CapitalizerblocEvent {
  final String textData;
  final EventStatus status;

  Capitalize(this.textData, this.status);
}
