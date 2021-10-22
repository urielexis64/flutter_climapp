import 'package:bloc/bloc.dart';
import 'package:climapp/models/clima.dart';
import 'package:meta/meta.dart';

part 'clima_event.dart';
part 'clima_state.dart';

class ClimaBloc extends Bloc<ClimaEvent, ClimaState> {
  ClimaBloc() : super(ClimaState()) {
    on<ClimaEvent>((event, emit) {
      if (event is ClimaLoading) {
        emit(state.copyWith(isLoading: true));
      }
      if (event is ClimaLoaded) {
        emit(state.copyWith(
          isLoading: false,
          clima: event.clima,
        ));
      }
      if (event is ClimaReset) {
        emit(state.copyWith(isLoading: false, isError: false, clima: null));
      }
      if (event is ClimaError) {
        emit(state.copyWith(
          isLoading: false,
          isError: true,
          errorMessage: event.errorMessage,
        ));
      }
    });
  }
}
