part of 'clima_bloc.dart';

class ClimaState {
  final Clima? clima;
  final bool isLoading;
  final bool isError;
  final String errorMessage;

  ClimaState({
    this.clima,
    this.isLoading = false,
    this.isError = false,
    this.errorMessage = '',
  });

  ClimaState copyWith(
      {Clima? clima, bool? isLoading, bool? isError, String? errorMessage}) {
    return ClimaState(
      clima: clima,
      isLoading: isLoading ?? this.isLoading,
      isError: isError ?? this.isError,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
