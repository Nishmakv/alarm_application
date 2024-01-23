part of 'weather_bloc.dart';

sealed class WeatherEvent extends Equatable {
  const WeatherEvent();

  @override
  List<Object> get props => [];

  get position => null;
}

class WeatherProcess extends WeatherEvent {
  final Position position;
  const WeatherProcess(  this.position);
  @override
  List<Object> get props => [position];
}
