import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'capitalizerbloc_event.dart';
part 'capitalizerbloc_state.dart';

class CapitalizerblocBloc extends Bloc<CapitalizerblocEvent, String> {
  CapitalizerblocBloc() : super("") {
    on<Capitalize>(_onCapitalize);
  }

  void _onCapitalize(Capitalize event, Emitter<String> emit) {
    emit(StringToCapitalize(event.textData).textData);
  }
}
