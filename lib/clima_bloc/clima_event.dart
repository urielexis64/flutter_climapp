part of 'clima_bloc.dart';

@immutable
abstract class ClimaEvent {}

class ClimaLoading extends ClimaEvent {}

class ClimaError extends ClimaEvent {
  final String errorMessage;

  ClimaError(this.errorMessage);
}

class ClimaLoaded extends ClimaEvent {
  final Clima clima;

  ClimaLoaded(this.clima);
}

class ClimaReset extends ClimaEvent {}
