import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'counterbloc_state.dart';

class CounterblocCubit extends Cubit<int> {
  CounterblocCubit() : super(0);

  void incrementCount() {
    emit(state + 1);
  }
}
